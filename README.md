# Ethel

[![CI](https://github.com/grype/SwiftEthel/actions/workflows/swift.yml/badge.svg)](https://github.com/grype/SwiftEthel/actions/workflows/swift.yml)

Lightweight framework for composing web service clients in Swift. It encourages to reason about web services in terms of logical structures, and promotes clean and easy to maintain architecture.

Ethel has a simple architecture that is able to support a wide range of APIs, including REST and GraphQL.  It can be used to write complete SDKs of varying complexity.

## Installing

This is a swift package. Use swift package manager to add to a project...

## Logging

Ethel uses ![Beacon](https://github.com/grype/SwiftBeacon) for logging. To start logging, simply create a logger and start it on `Beacon.ethel` object - which is the default `Beacon` on which the framework emits signals.

``` swift
let logger = ConsoleLogger(name: "Playground")
logger.start(on: [Beacon.ethel])
```

## Example

Let's take GitHub's Gists API for example. We'll start by defining the client class.

### The Client

```swift
struct GHClientConfiguration {
    var url: URL
    var authToken: String?
    static var `default` = GHClientConfiguration(url: URL(string: "https://api.github.com/")!, authToken: nil)
}

class GHClient : Client {
    override var baseUrl: URL? { return configuration.url }
    
    static var `default` = GHClient(configuration: GHClientConfiguration.default)
    
    var configuration: GHClientConfiguration
    
    init(configuration aConfig: GHClientConfiguration) {
        configuration = aConfig
        super.init(url: aConfig.url, sessionConfiguration: URLSessionConfiguration.background(withIdentifier: "GHClient"))
    }
}
```

The client needs to be initialized with a base URL of the web service, and a `URLSessionConfiguration` to use for an internally managed `URLSession`. In this particular case, we capture the base URL in the `GHClientConfiguration`, and use a background session configuration.

### The Endpoints

Next, we need to define an endpoint for interfacing with gists. It's a good idea to keep one endpoint class for a particular endpoint (i.e. one class for describing all of the API at the /gists level). Use instance variables to capture various parameters that the endpoint accepts.

Here we define a simple endpoint for /gists, and a method for retrieving a single gist:

```swift
class GHGistsEndpoint : Endpoint {
    
    override class var path: Path { Path() / "gists" }
    
    func gist(withId id: String) -> Promise<GHGist> {
        return getJSON(decoder: nil) { (transport) in
            transport.request?.url?.appendPathComponent(id)
        }
    }
    
}
```

Class-side var `path` returns a path into the web service starting with the client's baseUrl. The method `gist(withId:)` returns a `Promise` which can be used to retrieve the actual value, handle an error, map response to whatever you want, etc. The method retrieves a JSON structure that is converted to `GHGist`, which looks something like this:

```swift
struct GHGist : Codable {
    var id: String?
    var url: URL?
    enum CodingKeys: String, CodingKey {
        case id, url
    }
}
```

Nothing special there - just a Codable struct.

When calling `getJSON`, you can provide your own instance of `JSONDecoder`, otherwise, a default `JSONDecoder()` instance will be used.

The last argument to `getJSON` is a block that will be given an instance of `Transporter`, which encapsulates both, the request and the response. The optional block gives you a chance to configure it, and in the above example, we're modifying the request URL by appending a URL component to access the gist with the given identifier.

Lastly, let's make this endpoint accessible via the client:

```swift
extension GHClient {
  var gists : GHGistsEndpoint {
    return self / GHGistsEndpoint.self
  }
```

At this point we can ask the web service for a gist by ID:

```swift
let client = GHClient.default
client
  .gists
  .gist(withId: "...")
  .done { (gist) in
    // do something about that gist
  }
```

Both, the client and an endpoint get to configure the `Transport` at the time of execution, via `configure(on aTransport: Transport)` method. Which makes it easy to configure requests for all the endpoints, via the client, and per individual endpoint, say adding query items to URL based on instance variables. This is done prior to evaluating the optional block passed to getJSON() method - which is your last opportunity to modify the `Transport` before the client makes a request.

Let's create another endpoint for /gists/public:

```swift
class GHPublicGistsEndpoint : Endpoint {
    
    override class var path : Path { GHGistsEndpoint.path / "public" }
    
    var since: Date?
    
    func configure(on aTransport: Transport) {
        if let since = since {
            aTransport.add(queryItem: URLQueryItem(name: "since", value: dateFormatter.string(from: since)))
        }
    }
    
    func list() -> Promise<[GHGist]> {
        return getJSON()
    }
```

Let's connect it via the /gists endpoint:

```swift
extension GHGistsEndpoint {
  var `public` : GHPublicGistsEndpoint {
    return self / GHPublicGistsEndpoint.self
  }
}
```

And, finally, list some public gists:

```swift
let endpoint = client.gists.public
endpoint.since = Date().addingTimeInterval(-86400)
endpoint.list().done { (gists) in
  // do something
}
```

### Enumeration

It just happens that the /gists/public endpoint is paginated. By using `page` and `per_page` URL queries we can enumerate over a collection of gists, access specific ranges of items. All we need to do is make the endpoint behave as a `Sequence`, using an iterator that captures this information:

```swift
struct GHIterator<U: SequenceEndpoint> : EndpointIterator {
    
    typealias Element = U.Element
    
    var endpoint: U
    
    var hasMore: Bool = true
    
    var page: Int = 1
    
    var pageSize: Int = 5
    
    private var currentOffset: Int = 0
    
    private var elements: [Element]?
    
    init(_ anEndpoint: U) {
        endpoint = anEndpoint
    }
    
    private var needsFetch: Bool {
        guard hasMore else { return false }
        return elements == nil || currentOffset >= elements!.count
    }
    
    mutating func next() -> Element? {
        guard hasMore else { return nil }
        if needsFetch {
            fetch()
        }
        
        guard let elements = elements, elements.count > currentOffset else {
            return nil
        }
        let result = elements[currentOffset]
        currentOffset += 1
        return result
    }
    
    private mutating func fetch() {
        currentOffset = 0
        do {
            elements = try endpoint.next(with: self as! U.Iterator).wait()
            hasMore = (elements?.count ?? 0) == pageSize
            page += 1
        } catch {
            print("Error: \(error)")
        }
    }
}
```

The iterator maintains a variable `hasMore` indicating whether there's more results to fetch, and `next()` method to return the next element. There, we feed in a page of results at a time, and iterate over the results one by one. Fetching is done by calling `SequenceEndpoint.next(with:)` with the configured iterator. After fetching the page, we simply increment the current page number...

Finally, extend `GHPublicGistsEndpoint` to conform to `SequenceEndpoint`:

```swift
extension GHPublicGistsEndpoint : SequenceEndpoint {
    
    typealias Iterator = GHIterator<GHPublicGistsEndpoint>
    typealias Element = GHGist
    
    func makeIterator() -> Iterator {
        return GHIterator(self)
    }
    
    func next(with iterator: Iterator) -> Promise<[GHGist]> {
        return getJSON() { (transport) in
            transport.add(queryItem: URLQueryItem(name: "page", value: "\(iterator.page)"))
            transport.add(queryItem: URLQueryItem(name: "per_page", value: "\(iterator.pageSize)"))
        }
    }
  
}
```

Now, we can query the web service as if it was a Sequence:

```swift
DispatchQueue.global(qos: .background).async {
  client
    .gists
    .public
    .forEach { (gist) in
      // do something
    }
}
```

This will cause the client to make additional requests to the web service as needed. Convenient, but notice that this will continue to make requests until we go through all of them, which is often not the desired behavior. For that reason, all of the `Sequence`'s enumeration methods are complimented with limiting variants, like:

```swift
DispatchQueue.global(qos: .background).async {
  client
    .gists
    .public
    .forEach(limit: 10) { (gist) in
      // do something
    }
}
```

or more generally speaking:

```swift
DispatchQueue.global(qos: .background).async {
  client
    .gists
    .public
    .forEach(until: { (gists) -> Bool
      // return true when we need to bail
    }) { (gist) in
      // do something
    }
}
```

Because all of these methods require making a network request and processing the response synchronously, we are dispatching the process into a background thread. This is possible because we can:

```swift
DispatchQueue.global(qos: .background).async {
  var iterator = client.gists.public.makeIterator()
  while iterator.hasMore {
    let nextItem = iterator.next()
  }
}
```

This also make it possible to fetch data using subscripts:

```swift
extension GHPublicGistsEndpoint {
  subscript(index: Int) -> GHGist? {
    var iterator = makeIterator()
    iterator.pageSize = 1
    iterator.page = index + 1
    return iterator.next()
  }
    
  subscript(range: Range<Int>) -> [GHGist] {
    var iterator = makeIterator()
    iterator.page = Int(floor(Double(range.lowerBound / iterator.pageSize))) + 1
    var result = [GHGist]()
    while iterator.hasMore, result.count < range.upperBound - range.lowerBound {
      guard let found = try? next(with: iterator).wait() else { break }

      let startOffset = (iterator.page - 1) * iterator.pageSize
      let endOffset = startOffset + iterator.pageSize - 1

      let low = Swift.max(range.lowerBound - startOffset, 0)
      let high = iterator.pageSize - Swift.max(endOffset - range.upperBound, 0)

      result.append(contentsOf: found[low..<high])
      iterator.page += 1
    }
    return result
  }
}
```

Let's give it a try:

```swift
DispatchQueue.global(qos: .background).async {
  let gist = client.gists.public[index]
  let someGists = client.gists.public[2..<42]
}
```

This is it, for now...
