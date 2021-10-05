import Cuckoo
@testable import Ethel

import Beacon
import Foundation
import PromiseKit


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
        
    return cuckoo_manager.call("createTransport() -> Transport",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.createTransport()
                ,
            defaultCall: __defaultImplStub!.createTransport())
        
    }
    
    
    
    public override func prepare() -> TransportBuilding {
        
    return cuckoo_manager.call("prepare() -> TransportBuilding",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.prepare()
                ,
            defaultCall: __defaultImplStub!.prepare())
        
    }
    
    
    
    public override func resolve<T>(_ resolver: Resolver<T>, transport: Transport)  {
        
    return cuckoo_manager.call("resolve(_: Resolver<T>, transport: Transport)",
            parameters: (resolver, transport),
            escapingParameters: (resolver, transport),
            superclassCall:
                
                super.resolve(resolver, transport: transport)
                ,
            defaultCall: __defaultImplStub!.resolve(resolver, transport: transport))
        
    }
    
    
    
    public override func validate(response: URLResponse) -> Error? {
        
    return cuckoo_manager.call("validate(response: URLResponse) -> Error?",
            parameters: (response),
            escapingParameters: (response),
            superclassCall:
                
                super.validate(response: response)
                ,
            defaultCall: __defaultImplStub!.validate(response: response))
        
    }
    
    
    
    public override func execute<T>(_ endpoint: Endpoint, with block: () -> TransportBuilding) -> Promise<T> {
        	return withoutActuallyEscaping(block, do: { (block: @escaping () -> TransportBuilding) -> Promise<T> in

    return cuckoo_manager.call("execute(_: Endpoint, with: () -> TransportBuilding) -> Promise<T>",
            parameters: (endpoint, block),
            escapingParameters: (endpoint, { () -> TransportBuilding in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall:
                
                super.execute(endpoint, with: block)
                ,
            defaultCall: __defaultImplStub!.execute(endpoint, with: block))
        	})

    }
    
    
    
    public override func inContext(_ aContext: Context, do aBlock: () -> Void)  {
        	return withoutActuallyEscaping(aBlock, do: { (aBlock: @escaping () -> Void) -> Void in

    return cuckoo_manager.call("inContext(_: Context, do: () -> Void)",
            parameters: (aContext, aBlock),
            escapingParameters: (aContext, { () in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall:
                
                super.inContext(aContext, do: aBlock)
                ,
            defaultCall: __defaultImplStub!.inContext(aContext, do: aBlock))
        	})

    }
    
    
    
    public override func execute(transport: Transport, completion: @escaping () -> Void)  {
        
    return cuckoo_manager.call("execute(transport: Transport, completion: @escaping () -> Void)",
            parameters: (transport, completion),
            escapingParameters: (transport, completion),
            superclassCall:
                
                super.execute(transport: transport, completion: completion)
                ,
            defaultCall: __defaultImplStub!.execute(transport: transport, completion: completion))
        
    }
    
    
    
    public override func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?)  {
        
    return cuckoo_manager.call("urlSession(_: URLSession, didBecomeInvalidWithError: Error?)",
            parameters: (session, error),
            escapingParameters: (session, error),
            superclassCall:
                
                super.urlSession(session, didBecomeInvalidWithError: error)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, didBecomeInvalidWithError: error))
        
    }
    
    
    
    public override func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)  {
        
    return cuckoo_manager.call("urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError: Error?)",
            parameters: (session, task, error),
            escapingParameters: (session, task, error),
            superclassCall:
                
                super.urlSession(session, task: task, didCompleteWithError: error)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, task: task, didCompleteWithError: error))
        
    }
    
    
    
    public override func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)  {
        
    return cuckoo_manager.call("urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive: Data)",
            parameters: (session, dataTask, data),
            escapingParameters: (session, dataTask, data),
            superclassCall:
                
                super.urlSession(session, dataTask: dataTask, didReceive: data)
                ,
            defaultCall: __defaultImplStub!.urlSession(session, dataTask: dataTask, didReceive: data))
        
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
	    
	    
	    var queue: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockClient, DispatchQueue> {
	        return .init(manager: cuckoo_manager, name: "queue")
	    }
	    
	    
	    func createTransport() -> Cuckoo.ClassStubFunction<(), Transport> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "createTransport() -> Transport", parameterMatchers: matchers))
	    }
	    
	    func prepare() -> Cuckoo.ClassStubFunction<(), TransportBuilding> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "prepare() -> TransportBuilding", parameterMatchers: matchers))
	    }
	    
	    func resolve<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, T>(_ resolver: M1, transport: M2) -> Cuckoo.ClassStubNoReturnFunction<(Resolver<T>, Transport)> where M1.MatchedType == Resolver<T>, M2.MatchedType == Transport {
	        let matchers: [Cuckoo.ParameterMatcher<(Resolver<T>, Transport)>] = [wrap(matchable: resolver) { $0.0 }, wrap(matchable: transport) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "resolve(_: Resolver<T>, transport: Transport)", parameterMatchers: matchers))
	    }
	    
	    func validate<M1: Cuckoo.Matchable>(response: M1) -> Cuckoo.ClassStubFunction<(URLResponse), Error?> where M1.MatchedType == URLResponse {
	        let matchers: [Cuckoo.ParameterMatcher<(URLResponse)>] = [wrap(matchable: response) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "validate(response: URLResponse) -> Error?", parameterMatchers: matchers))
	    }
	    
	    func execute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, T>(_ endpoint: M1, with block: M2) -> Cuckoo.ClassStubFunction<(Endpoint, () -> TransportBuilding), Promise<T>> where M1.MatchedType == Endpoint, M2.MatchedType == () -> TransportBuilding {
	        let matchers: [Cuckoo.ParameterMatcher<(Endpoint, () -> TransportBuilding)>] = [wrap(matchable: endpoint) { $0.0 }, wrap(matchable: block) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "execute(_: Endpoint, with: () -> TransportBuilding) -> Promise<T>", parameterMatchers: matchers))
	    }
	    
	    func inContext<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ aContext: M1, do aBlock: M2) -> Cuckoo.ClassStubNoReturnFunction<(Context, () -> Void)> where M1.MatchedType == Context, M2.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Context, () -> Void)>] = [wrap(matchable: aContext) { $0.0 }, wrap(matchable: aBlock) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "inContext(_: Context, do: () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func execute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(transport: M1, completion: M2) -> Cuckoo.ClassStubNoReturnFunction<(Transport, () -> Void)> where M1.MatchedType == Transport, M2.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Transport, () -> Void)>] = [wrap(matchable: transport) { $0.0 }, wrap(matchable: completion) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "execute(transport: Transport, completion: @escaping () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(_ session: M1, didBecomeInvalidWithError error: M2) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, Error?)> where M1.MatchedType == URLSession, M2.OptionalMatchedType == Error {
	        let matchers: [Cuckoo.ParameterMatcher<(URLSession, Error?)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: error) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "urlSession(_: URLSession, didBecomeInvalidWithError: Error?)", parameterMatchers: matchers))
	    }
	    
	    func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable>(_ session: M1, task: M2, didCompleteWithError error: M3) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, URLSessionTask, Error?)> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionTask, M3.OptionalMatchedType == Error {
	        let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionTask, Error?)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: task) { $0.1 }, wrap(matchable: error) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError: Error?)", parameterMatchers: matchers))
	    }
	    
	    func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ session: M1, dataTask: M2, didReceive data: M3) -> Cuckoo.ClassStubNoReturnFunction<(URLSession, URLSessionDataTask, Data)> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionDataTask, M3.MatchedType == Data {
	        let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionDataTask, Data)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: dataTask) { $0.1 }, wrap(matchable: data) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockClient.self, method: "urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive: Data)", parameterMatchers: matchers))
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
	    
	    
	    var queue: Cuckoo.VerifyReadOnlyProperty<DispatchQueue> {
	        return .init(manager: cuckoo_manager, name: "queue", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func createTransport() -> Cuckoo.__DoNotUse<(), Transport> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("createTransport() -> Transport", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func prepare() -> Cuckoo.__DoNotUse<(), TransportBuilding> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("prepare() -> TransportBuilding", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, T>(_ resolver: M1, transport: M2) -> Cuckoo.__DoNotUse<(Resolver<T>, Transport), Void> where M1.MatchedType == Resolver<T>, M2.MatchedType == Transport {
	        let matchers: [Cuckoo.ParameterMatcher<(Resolver<T>, Transport)>] = [wrap(matchable: resolver) { $0.0 }, wrap(matchable: transport) { $0.1 }]
	        return cuckoo_manager.verify("resolve(_: Resolver<T>, transport: Transport)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func validate<M1: Cuckoo.Matchable>(response: M1) -> Cuckoo.__DoNotUse<(URLResponse), Error?> where M1.MatchedType == URLResponse {
	        let matchers: [Cuckoo.ParameterMatcher<(URLResponse)>] = [wrap(matchable: response) { $0 }]
	        return cuckoo_manager.verify("validate(response: URLResponse) -> Error?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func execute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, T>(_ endpoint: M1, with block: M2) -> Cuckoo.__DoNotUse<(Endpoint, () -> TransportBuilding), Promise<T>> where M1.MatchedType == Endpoint, M2.MatchedType == () -> TransportBuilding {
	        let matchers: [Cuckoo.ParameterMatcher<(Endpoint, () -> TransportBuilding)>] = [wrap(matchable: endpoint) { $0.0 }, wrap(matchable: block) { $0.1 }]
	        return cuckoo_manager.verify("execute(_: Endpoint, with: () -> TransportBuilding) -> Promise<T>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func inContext<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ aContext: M1, do aBlock: M2) -> Cuckoo.__DoNotUse<(Context, () -> Void), Void> where M1.MatchedType == Context, M2.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Context, () -> Void)>] = [wrap(matchable: aContext) { $0.0 }, wrap(matchable: aBlock) { $0.1 }]
	        return cuckoo_manager.verify("inContext(_: Context, do: () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func execute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(transport: M1, completion: M2) -> Cuckoo.__DoNotUse<(Transport, () -> Void), Void> where M1.MatchedType == Transport, M2.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Transport, () -> Void)>] = [wrap(matchable: transport) { $0.0 }, wrap(matchable: completion) { $0.1 }]
	        return cuckoo_manager.verify("execute(transport: Transport, completion: @escaping () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(_ session: M1, didBecomeInvalidWithError error: M2) -> Cuckoo.__DoNotUse<(URLSession, Error?), Void> where M1.MatchedType == URLSession, M2.OptionalMatchedType == Error {
	        let matchers: [Cuckoo.ParameterMatcher<(URLSession, Error?)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: error) { $0.1 }]
	        return cuckoo_manager.verify("urlSession(_: URLSession, didBecomeInvalidWithError: Error?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable>(_ session: M1, task: M2, didCompleteWithError error: M3) -> Cuckoo.__DoNotUse<(URLSession, URLSessionTask, Error?), Void> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionTask, M3.OptionalMatchedType == Error {
	        let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionTask, Error?)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: task) { $0.1 }, wrap(matchable: error) { $0.2 }]
	        return cuckoo_manager.verify("urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError: Error?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func urlSession<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ session: M1, dataTask: M2, didReceive data: M3) -> Cuckoo.__DoNotUse<(URLSession, URLSessionDataTask, Data), Void> where M1.MatchedType == URLSession, M2.MatchedType == URLSessionDataTask, M3.MatchedType == Data {
	        let matchers: [Cuckoo.ParameterMatcher<(URLSession, URLSessionDataTask, Data)>] = [wrap(matchable: session) { $0.0 }, wrap(matchable: dataTask) { $0.1 }, wrap(matchable: data) { $0.2 }]
	        return cuckoo_manager.verify("urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive: Data)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
    
    public override var queue: DispatchQueue {
        get {
            return DefaultValueRegistry.defaultValue(for: (DispatchQueue).self)
        }
        
    }
    

    

    
    public override func createTransport() -> Transport  {
        return DefaultValueRegistry.defaultValue(for: (Transport).self)
    }
    
    public override func prepare() -> TransportBuilding  {
        return DefaultValueRegistry.defaultValue(for: (TransportBuilding).self)
    }
    
    public override func resolve<T>(_ resolver: Resolver<T>, transport: Transport)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func validate(response: URLResponse) -> Error?  {
        return DefaultValueRegistry.defaultValue(for: (Error?).self)
    }
    
    public override func execute<T>(_ endpoint: Endpoint, with block: () -> TransportBuilding) -> Promise<T>  {
        return DefaultValueRegistry.defaultValue(for: (Promise<T>).self)
    }
    
    public override func inContext(_ aContext: Context, do aBlock: () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func execute(transport: Transport, completion: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
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
    
}

