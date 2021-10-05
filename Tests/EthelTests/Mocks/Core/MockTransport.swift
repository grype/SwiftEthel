import Cuckoo
@testable import Ethel

import Beacon
import Foundation


public class MockTransport: Transport, Cuckoo.ClassMock {
    
    public typealias MocksType = Transport
    
    public typealias Stubbing = __StubbingProxy_Transport
    public typealias Verification = __VerificationProxy_Transport

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: Transport?

    public func enableDefaultImplementation(_ stub: Transport) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var type: RequestType {
        get {
            return cuckoo_manager.getter("type",
                superclassCall:
                    
                    super.type
                    ,
                defaultCall: __defaultImplStub!.type)
        }
        
        set {
            cuckoo_manager.setter("type",
                value: newValue,
                superclassCall:
                    
                    super.type = newValue
                    ,
                defaultCall: __defaultImplStub!.type = newValue)
        }
        
    }
    
    
    
    public override var contentWriter: ((Any) throws -> Data?)? {
        get {
            return cuckoo_manager.getter("contentWriter",
                superclassCall:
                    
                    super.contentWriter
                    ,
                defaultCall: __defaultImplStub!.contentWriter)
        }
        
        set {
            cuckoo_manager.setter("contentWriter",
                value: newValue,
                superclassCall:
                    
                    super.contentWriter = newValue
                    ,
                defaultCall: __defaultImplStub!.contentWriter = newValue)
        }
        
    }
    
    
    
    public override var contentReader: ((Data) throws -> Any?)? {
        get {
            return cuckoo_manager.getter("contentReader",
                superclassCall:
                    
                    super.contentReader
                    ,
                defaultCall: __defaultImplStub!.contentReader)
        }
        
        set {
            cuckoo_manager.setter("contentReader",
                value: newValue,
                superclassCall:
                    
                    super.contentReader = newValue
                    ,
                defaultCall: __defaultImplStub!.contentReader = newValue)
        }
        
    }
    
    
    
    public override var session: URLSession {
        get {
            return cuckoo_manager.getter("session",
                superclassCall:
                    
                    super.session
                    ,
                defaultCall: __defaultImplStub!.session)
        }
        
    }
    
    
    
    public override var request: URLRequest? {
        get {
            return cuckoo_manager.getter("request",
                superclassCall:
                    
                    super.request
                    ,
                defaultCall: __defaultImplStub!.request)
        }
        
        set {
            cuckoo_manager.setter("request",
                value: newValue,
                superclassCall:
                    
                    super.request = newValue
                    ,
                defaultCall: __defaultImplStub!.request = newValue)
        }
        
    }
    
    
    
    public override var response: URLResponse? {
        get {
            return cuckoo_manager.getter("response",
                superclassCall:
                    
                    super.response
                    ,
                defaultCall: __defaultImplStub!.response)
        }
        
    }
    
    
    
    public override var isComplete: Bool {
        get {
            return cuckoo_manager.getter("isComplete",
                superclassCall:
                    
                    super.isComplete
                    ,
                defaultCall: __defaultImplStub!.isComplete)
        }
        
    }
    
    
    
    public override var responseData: Data? {
        get {
            return cuckoo_manager.getter("responseData",
                superclassCall:
                    
                    super.responseData
                    ,
                defaultCall: __defaultImplStub!.responseData)
        }
        
    }
    
    
    
    public override var responseError: Error? {
        get {
            return cuckoo_manager.getter("responseError",
                superclassCall:
                    
                    super.responseError
                    ,
                defaultCall: __defaultImplStub!.responseError)
        }
        
    }
    
    
    
    public override var task: URLSessionTask? {
        get {
            return cuckoo_manager.getter("task",
                superclassCall:
                    
                    super.task
                    ,
                defaultCall: __defaultImplStub!.task)
        }
        
    }
    
    
    
    public override var requestContents: Any? {
        get {
            return cuckoo_manager.getter("requestContents",
                superclassCall:
                    
                    super.requestContents
                    ,
                defaultCall: __defaultImplStub!.requestContents)
        }
        
        set {
            cuckoo_manager.setter("requestContents",
                value: newValue,
                superclassCall:
                    
                    super.requestContents = newValue
                    ,
                defaultCall: __defaultImplStub!.requestContents = newValue)
        }
        
    }
    
    
    
    public override var responseContents: Any? {
        get {
            return cuckoo_manager.getter("responseContents",
                superclassCall:
                    
                    super.responseContents
                    ,
                defaultCall: __defaultImplStub!.responseContents)
        }
        
    }
    
    
    
    public override var description: String {
        get {
            return cuckoo_manager.getter("description",
                superclassCall:
                    
                    super.description
                    ,
                defaultCall: __defaultImplStub!.description)
        }
        
    }
    

    

    
    
    
    public override func execute(completion aCompletionBlock: @escaping Completion) -> URLSessionTask {
        
    return cuckoo_manager.call("execute(completion: @escaping Completion) -> URLSessionTask",
            parameters: (aCompletionBlock),
            escapingParameters: (aCompletionBlock),
            superclassCall:
                
                super.execute(completion: aCompletionBlock)
                ,
            defaultCall: __defaultImplStub!.execute(completion: aCompletionBlock))
        
    }
    
    
    
    public override func setRequestContents(_ contents: Any?) throws {
        
    return try cuckoo_manager.callThrows("setRequestContents(_: Any?) throws",
            parameters: (contents),
            escapingParameters: (contents),
            superclassCall:
                
                super.setRequestContents(contents)
                ,
            defaultCall: __defaultImplStub!.setRequestContents(contents))
        
    }
    
    
    
    public override func getResponseContents() throws -> Any? {
        
    return try cuckoo_manager.callThrows("getResponseContents() throws -> Any?",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getResponseContents()
                ,
            defaultCall: __defaultImplStub!.getResponseContents())
        
    }
    

	public struct __StubbingProxy_Transport: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var type: Cuckoo.ClassToBeStubbedProperty<MockTransport, RequestType> {
	        return .init(manager: cuckoo_manager, name: "type")
	    }
	    
	    
	    var contentWriter: Cuckoo.ClassToBeStubbedOptionalProperty<MockTransport, ((Any) throws -> Data?)> {
	        return .init(manager: cuckoo_manager, name: "contentWriter")
	    }
	    
	    
	    var contentReader: Cuckoo.ClassToBeStubbedOptionalProperty<MockTransport, ((Data) throws -> Any?)> {
	        return .init(manager: cuckoo_manager, name: "contentReader")
	    }
	    
	    
	    var session: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTransport, URLSession> {
	        return .init(manager: cuckoo_manager, name: "session")
	    }
	    
	    
	    var request: Cuckoo.ClassToBeStubbedOptionalProperty<MockTransport, URLRequest> {
	        return .init(manager: cuckoo_manager, name: "request")
	    }
	    
	    
	    var response: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTransport, URLResponse?> {
	        return .init(manager: cuckoo_manager, name: "response")
	    }
	    
	    
	    var isComplete: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTransport, Bool> {
	        return .init(manager: cuckoo_manager, name: "isComplete")
	    }
	    
	    
	    var responseData: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTransport, Data?> {
	        return .init(manager: cuckoo_manager, name: "responseData")
	    }
	    
	    
	    var responseError: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTransport, Error?> {
	        return .init(manager: cuckoo_manager, name: "responseError")
	    }
	    
	    
	    var task: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTransport, URLSessionTask?> {
	        return .init(manager: cuckoo_manager, name: "task")
	    }
	    
	    
	    var requestContents: Cuckoo.ClassToBeStubbedOptionalProperty<MockTransport, Any> {
	        return .init(manager: cuckoo_manager, name: "requestContents")
	    }
	    
	    
	    var responseContents: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTransport, Any?> {
	        return .init(manager: cuckoo_manager, name: "responseContents")
	    }
	    
	    
	    var description: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTransport, String> {
	        return .init(manager: cuckoo_manager, name: "description")
	    }
	    
	    
	    func execute<M1: Cuckoo.Matchable>(completion aCompletionBlock: M1) -> Cuckoo.ClassStubFunction<(Completion), URLSessionTask> where M1.MatchedType == Completion {
	        let matchers: [Cuckoo.ParameterMatcher<(Completion)>] = [wrap(matchable: aCompletionBlock) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTransport.self, method: "execute(completion: @escaping Completion) -> URLSessionTask", parameterMatchers: matchers))
	    }
	    
	    func setRequestContents<M1: Cuckoo.OptionalMatchable>(_ contents: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Any?)> where M1.OptionalMatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any?)>] = [wrap(matchable: contents) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTransport.self, method: "setRequestContents(_: Any?) throws", parameterMatchers: matchers))
	    }
	    
	    func getResponseContents() -> Cuckoo.ClassStubThrowingFunction<(), Any?> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTransport.self, method: "getResponseContents() throws -> Any?", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_Transport: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var type: Cuckoo.VerifyProperty<RequestType> {
	        return .init(manager: cuckoo_manager, name: "type", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var contentWriter: Cuckoo.VerifyOptionalProperty<((Any) throws -> Data?)> {
	        return .init(manager: cuckoo_manager, name: "contentWriter", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var contentReader: Cuckoo.VerifyOptionalProperty<((Data) throws -> Any?)> {
	        return .init(manager: cuckoo_manager, name: "contentReader", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var session: Cuckoo.VerifyReadOnlyProperty<URLSession> {
	        return .init(manager: cuckoo_manager, name: "session", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var request: Cuckoo.VerifyOptionalProperty<URLRequest> {
	        return .init(manager: cuckoo_manager, name: "request", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var response: Cuckoo.VerifyReadOnlyProperty<URLResponse?> {
	        return .init(manager: cuckoo_manager, name: "response", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isComplete: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isComplete", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var responseData: Cuckoo.VerifyReadOnlyProperty<Data?> {
	        return .init(manager: cuckoo_manager, name: "responseData", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var responseError: Cuckoo.VerifyReadOnlyProperty<Error?> {
	        return .init(manager: cuckoo_manager, name: "responseError", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var task: Cuckoo.VerifyReadOnlyProperty<URLSessionTask?> {
	        return .init(manager: cuckoo_manager, name: "task", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var requestContents: Cuckoo.VerifyOptionalProperty<Any> {
	        return .init(manager: cuckoo_manager, name: "requestContents", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var responseContents: Cuckoo.VerifyReadOnlyProperty<Any?> {
	        return .init(manager: cuckoo_manager, name: "responseContents", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var description: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "description", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func execute<M1: Cuckoo.Matchable>(completion aCompletionBlock: M1) -> Cuckoo.__DoNotUse<(Completion), URLSessionTask> where M1.MatchedType == Completion {
	        let matchers: [Cuckoo.ParameterMatcher<(Completion)>] = [wrap(matchable: aCompletionBlock) { $0 }]
	        return cuckoo_manager.verify("execute(completion: @escaping Completion) -> URLSessionTask", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setRequestContents<M1: Cuckoo.OptionalMatchable>(_ contents: M1) -> Cuckoo.__DoNotUse<(Any?), Void> where M1.OptionalMatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any?)>] = [wrap(matchable: contents) { $0 }]
	        return cuckoo_manager.verify("setRequestContents(_: Any?) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getResponseContents() -> Cuckoo.__DoNotUse<(), Any?> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getResponseContents() throws -> Any?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class TransportStub: Transport {
    
    
    public override var type: RequestType {
        get {
            return DefaultValueRegistry.defaultValue(for: (RequestType).self)
        }
        
        set { }
        
    }
    
    
    public override var contentWriter: ((Any) throws -> Data?)? {
        get {
            return DefaultValueRegistry.defaultValue(for: (((Any) throws -> Data?)?).self)
        }
        
        set { }
        
    }
    
    
    public override var contentReader: ((Data) throws -> Any?)? {
        get {
            return DefaultValueRegistry.defaultValue(for: (((Data) throws -> Any?)?).self)
        }
        
        set { }
        
    }
    
    
    public override var session: URLSession {
        get {
            return DefaultValueRegistry.defaultValue(for: (URLSession).self)
        }
        
    }
    
    
    public override var request: URLRequest? {
        get {
            return DefaultValueRegistry.defaultValue(for: (URLRequest?).self)
        }
        
        set { }
        
    }
    
    
    public override var response: URLResponse? {
        get {
            return DefaultValueRegistry.defaultValue(for: (URLResponse?).self)
        }
        
    }
    
    
    public override var isComplete: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public override var responseData: Data? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Data?).self)
        }
        
    }
    
    
    public override var responseError: Error? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Error?).self)
        }
        
    }
    
    
    public override var task: URLSessionTask? {
        get {
            return DefaultValueRegistry.defaultValue(for: (URLSessionTask?).self)
        }
        
    }
    
    
    public override var requestContents: Any? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Any?).self)
        }
        
        set { }
        
    }
    
    
    public override var responseContents: Any? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Any?).self)
        }
        
    }
    
    
    public override var description: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    

    

    
    public override func execute(completion aCompletionBlock: @escaping Completion) -> URLSessionTask  {
        return DefaultValueRegistry.defaultValue(for: (URLSessionTask).self)
    }
    
    public override func setRequestContents(_ contents: Any?) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func getResponseContents() throws -> Any?  {
        return DefaultValueRegistry.defaultValue(for: (Any?).self)
    }
    
}

