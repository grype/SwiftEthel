import Cuckoo
@testable import Ethel

import Beacon
import Foundation






public class MockClient: Client, Cuckoo.ClassMock {
    
    public typealias MocksType = Client
    
    public typealias Stubbing = __StubbingProxy_Client
    public typealias Verification = __VerificationProxy_Client

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: Client?

    public func enableDefaultImplementation(_ stub: Client) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public override var baseUrl: URL {
        get {
            return cuckoo_manager.getter("baseUrl",
                superclassCall:
                    
                    super.baseUrl
                    ,
                defaultCall: __defaultImplStub!.baseUrl)
        }
        
    }
    
    
    
    
    
    public override var session: URLSession! {
        get {
            return cuckoo_manager.getter("session",
                superclassCall:
                    
                    super.session
                    ,
                defaultCall: __defaultImplStub!.session)
        }
        
    }
    
    
    
    
    
    public override var tasks: [URLSessionTask: Transport] {
        get {
            return cuckoo_manager.getter("tasks",
                superclassCall:
                    
                    super.tasks
                    ,
                defaultCall: __defaultImplStub!.tasks)
        }
        
    }
    
    

    

    
    
    
    
    public override func createTransport() -> Transport {
        
    return cuckoo_manager.call(
    """
    createTransport() -> Transport
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.createTransport()
                ,
            defaultCall: __defaultImplStub!.createTransport())
        
    }
    
    
    
    
    
    public override func prepare() -> TransportBuilding {
        
    return cuckoo_manager.call(
    """
    prepare() -> TransportBuilding
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.prepare()
                ,
            defaultCall: __defaultImplStub!.prepare())
        
    }
    
    
    
    
    
    public override func validate(response: URLResponse) -> Error? {
        
    return cuckoo_manager.call(
    """
    validate(response: URLResponse) -> Error?
    """,
            parameters: (response),
            escapingParameters: (response),
            superclassCall:
                
                super.validate(response: response)
                ,
            defaultCall: __defaultImplStub!.validate(response: response))
        
    }
    
    
    
    
    
    public override func execute<T>(_ endpoint: Endpoint, with block: () -> TransportBuilding) async throws -> T {
        	return try await withoutActuallyEscaping(block, do: { (block: @escaping () -> TransportBuilding) -> T in

    return try await cuckoo_manager.callThrows(
    """
    execute(_: Endpoint, with: () -> TransportBuilding) async throws -> T
    """,
            parameters: (endpoint, block),
            escapingParameters: (endpoint, { () -> TransportBuilding in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall:
                
                await super.execute(endpoint, with: block)
                ,
            defaultCall: await __defaultImplStub!.execute(endpoint, with: block))
        	})

    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?)  {
        
    return cuckoo_manager.call(
    """
    urlSession(_: URLSession, didBecomeInvalidWithError: Error?)
    """,
            parameters: (session, error),
            escapingParameters: (session, error),
            superclassCall:
                
                super.urlSession(session, didBecomeInvalidWithError: error)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, didBecomeInvalidWithError: error))
        
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)  {
        
    return cuckoo_manager.call(
    """
    urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError: Error?)
    """,
            parameters: (session, task, error),
            escapingParameters: (session, task, error),
            superclassCall:
                
                super.urlSession(session, task: task, didCompleteWithError: error)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, task: task, didCompleteWithError: error))
        
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)  {
        
    return cuckoo_manager.call(
    """
    urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive: Data)
    """,
            parameters: (session, dataTask, data),
            escapingParameters: (session, dataTask, data),
            superclassCall:
                
                super.urlSession(session, dataTask: dataTask, didReceive: data)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, dataTask: dataTask, didReceive: data))
        
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)  {
        
    return cuckoo_manager.call(
    """
    urlSession(_: URLSession, task: URLSessionTask, didSendBodyData: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    """,
            parameters: (session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend),
            escapingParameters: (session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend),
            superclassCall:
                
                super.urlSession(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend))
        
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)  {
        
    return cuckoo_manager.call(
    """
    urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo: URL)
    """,
            parameters: (session, downloadTask, location),
            escapingParameters: (session, downloadTask, location),
            superclassCall:
                
                super.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location))
        
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)  {
        
    return cuckoo_manager.call(
    """
    urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    """,
            parameters: (session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite),
            escapingParameters: (session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite),
            superclassCall:
                
                super.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite))
        
    }
    
    

    public struct __StubbingProxy_Client: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var baseUrl: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockClient, URL> {
            return .init(manager: cuckoo_manager, name: "baseUrl")
        }
        
        
        
        
        var session: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockClient, URLSession?> {
            return .init(manager: cuckoo_manager, name: "session")
        }
        
        
        
        
        var tasks: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockClient, [URLSessionTask: Transport]> {
            return .init(manager: cuckoo_manager, name: "tasks")
        }
        
        
        
        
        
        func createTransport() -> Cuckoo.ClassStubFunction<(), Transport> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    createTransport() -> Transport
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func prepare() -> Cuckoo.ClassStubFunction<(), TransportBuilding> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    prepare() -> TransportBuilding
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validate<M1: Cuckoo.Matchable>(response: M1) -> Cuckoo.ClassStubFunction<(URLResponse), Error?> where M1.MatchedType == URLResponse {
            let matchers: [Cuckoo.ParameterMatcher<(URLResponse)>] = [wrap(matchable: response) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    validate(response: URLResponse) -> Error?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, T>(_ endpoint: M1, with block: M2) -> Cuckoo.ClassStubThrowingFunction<(Endpoint, () -> TransportBuilding), T> where M1.MatchedType == Endpoint, M2.MatchedType == () -> TransportBuilding {
            let matchers: [Cuckoo.ParameterMatcher<(Endpoint, () -> TransportBuilding)>] = [wrap(matchable: endpoint) { $0.0 }, wrap(matchable: block) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    execute(_: Endpoint, with: () -> TransportBuilding) async throws -> T
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(_ session: M1, didBecomeInvalidWithError error: M2) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, Error?)> where M1.MatchedType == URLSession, M2.OptionalMatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, Error?)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: error) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    urlSession(_: URLSession, didBecomeInvalidWithError: Error?)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable>(_ session: M1, task: M2, didCompleteWithError error: M3) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, URLSessionTask, Error?)> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionTask, M3.OptionalMatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionTask, Error?)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: task) { $0.1 }, wrap(matchable: error) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError: Error?)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ session: M1, dataTask: M2, didReceive data: M3) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, URLSessionDataTask, Data)> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionDataTask, M3.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionDataTask, Data)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: dataTask) { $0.1 }, wrap(matchable: data) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive: Data)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(_ session: M1, task: M2, didSendBodyData bytesSent: M3, totalBytesSent: M4, totalBytesExpectedToSend: M5) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, URLSessionTask, Int64, Int64, Int64)> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionTask, M3.MatchedType == Int64, M4.MatchedType == Int64, M5.MatchedType == Int64 {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionTask, Int64, Int64, Int64)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: task) { $0.1 }, wrap(matchable: bytesSent) { $0.2 }, wrap(matchable: totalBytesSent) { $0.3 }, wrap(matchable: totalBytesExpectedToSend) { $0.4 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    urlSession(_: URLSession, task: URLSessionTask, didSendBodyData: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ session: M1, downloadTask: M2, didFinishDownloadingTo location: M3) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, URLSessionDownloadTask, URL)> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionDownloadTask, M3.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionDownloadTask, URL)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: downloadTask) { $0.1 }, wrap(matchable: location) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo: URL)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(_ session: M1, downloadTask: M2, didWriteData bytesWritten: M3, totalBytesWritten: M4, totalBytesExpectedToWrite: M5) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, URLSessionDownloadTask, Int64, Int64, Int64)> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionDownloadTask, M3.MatchedType == Int64, M4.MatchedType == Int64, M5.MatchedType == Int64 {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionDownloadTask, Int64, Int64, Int64)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: downloadTask) { $0.1 }, wrap(matchable: bytesWritten) { $0.2 }, wrap(matchable: totalBytesWritten) { $0.3 }, wrap(matchable: totalBytesExpectedToWrite) { $0.4 }]
            return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method:
    """
    urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_Client: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var baseUrl: Cuckoo.VerifyReadOnlyProperty<URL> {
            return .init(manager: cuckoo_manager, name: "baseUrl", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var session: Cuckoo.VerifyReadOnlyProperty<URLSession?> {
            return .init(manager: cuckoo_manager, name: "session", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var tasks: Cuckoo.VerifyReadOnlyProperty<[URLSessionTask: Transport]> {
            return .init(manager: cuckoo_manager, name: "tasks", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func createTransport() -> Cuckoo.__DoNotUse<(), Transport> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    createTransport() -> Transport
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func prepare() -> Cuckoo.__DoNotUse<(), TransportBuilding> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    prepare() -> TransportBuilding
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validate<M1: Cuckoo.Matchable>(response: M1) -> Cuckoo.__DoNotUse<(URLResponse), Error?> where M1.MatchedType == URLResponse {
            let matchers: [Cuckoo.ParameterMatcher<(URLResponse)>] = [wrap(matchable: response) { $0 }]
            return cuckoo_manager.verify(
    """
    validate(response: URLResponse) -> Error?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, T>(_ endpoint: M1, with block: M2) -> Cuckoo.__DoNotUse<(Endpoint, () -> TransportBuilding), T> where M1.MatchedType == Endpoint, M2.MatchedType == () -> TransportBuilding {
            let matchers: [Cuckoo.ParameterMatcher<(Endpoint, () -> TransportBuilding)>] = [wrap(matchable: endpoint) { $0.0 }, wrap(matchable: block) { $0.1 }]
            return cuckoo_manager.verify(
    """
    execute(_: Endpoint, with: () -> TransportBuilding) async throws -> T
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(_ session: M1, didBecomeInvalidWithError error: M2) -> Cuckoo.__DoNotUse<(URLSession, Error?), Void> where M1.MatchedType == URLSession, M2.OptionalMatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, Error?)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: error) { $0.1 }]
            return cuckoo_manager.verify(
    """
    urlSession(_: URLSession, didBecomeInvalidWithError: Error?)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable>(_ session: M1, task: M2, didCompleteWithError error: M3) -> Cuckoo.__DoNotUse<(URLSession, URLSessionTask, Error?), Void> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionTask, M3.OptionalMatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionTask, Error?)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: task) { $0.1 }, wrap(matchable: error) { $0.2 }]
            return cuckoo_manager.verify(
    """
    urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError: Error?)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ session: M1, dataTask: M2, didReceive data: M3) -> Cuckoo.__DoNotUse<(URLSession, URLSessionDataTask, Data), Void> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionDataTask, M3.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionDataTask, Data)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: dataTask) { $0.1 }, wrap(matchable: data) { $0.2 }]
            return cuckoo_manager.verify(
    """
    urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive: Data)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(_ session: M1, task: M2, didSendBodyData bytesSent: M3, totalBytesSent: M4, totalBytesExpectedToSend: M5) -> Cuckoo.__DoNotUse<(URLSession, URLSessionTask, Int64, Int64, Int64), Void> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionTask, M3.MatchedType == Int64, M4.MatchedType == Int64, M5.MatchedType == Int64 {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionTask, Int64, Int64, Int64)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: task) { $0.1 }, wrap(matchable: bytesSent) { $0.2 }, wrap(matchable: totalBytesSent) { $0.3 }, wrap(matchable: totalBytesExpectedToSend) { $0.4 }]
            return cuckoo_manager.verify(
    """
    urlSession(_: URLSession, task: URLSessionTask, didSendBodyData: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ session: M1, downloadTask: M2, didFinishDownloadingTo location: M3) -> Cuckoo.__DoNotUse<(URLSession, URLSessionDownloadTask, URL), Void> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionDownloadTask, M3.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionDownloadTask, URL)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: downloadTask) { $0.1 }, wrap(matchable: location) { $0.2 }]
            return cuckoo_manager.verify(
    """
    urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo: URL)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(_ session: M1, downloadTask: M2, didWriteData bytesWritten: M3, totalBytesWritten: M4, totalBytesExpectedToWrite: M5) -> Cuckoo.__DoNotUse<(URLSession, URLSessionDownloadTask, Int64, Int64, Int64), Void> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionDownloadTask, M3.MatchedType == Int64, M4.MatchedType == Int64, M5.MatchedType == Int64 {
            let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionDownloadTask, Int64, Int64, Int64)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: downloadTask) { $0.1 }, wrap(matchable: bytesWritten) { $0.2 }, wrap(matchable: totalBytesWritten) { $0.3 }, wrap(matchable: totalBytesExpectedToWrite) { $0.4 }]
            return cuckoo_manager.verify(
    """
    urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class ClientStub: Client {
    
    
    
    
    public override var baseUrl: URL {
        get {
            return DefaultValueRegistry.defaultValue(for: (URL).self)
        }
        
    }
    
    
    
    
    
    public override var session: URLSession! {
        get {
            return DefaultValueRegistry.defaultValue(for: (URLSession?).self)
        }
        
    }
    
    
    
    
    
    public override var tasks: [URLSessionTask: Transport] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([URLSessionTask: Transport]).self)
        }
        
    }
    
    

    

    
    
    
    
    public override func createTransport() -> Transport  {
        return DefaultValueRegistry.defaultValue(for: (Transport).self)
    }
    
    
    
    
    
    public override func prepare() -> TransportBuilding  {
        return DefaultValueRegistry.defaultValue(for: (TransportBuilding).self)
    }
    
    
    
    
    
    public override func validate(response: URLResponse) -> Error?  {
        return DefaultValueRegistry.defaultValue(for: (Error?).self)
    }
    
    
    
    
    
    public override func execute<T>(_ endpoint: Endpoint, with block: () -> TransportBuilding) async throws -> T  {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




