import Combine
import XCTest
import Networking

final class NetworkingTests: XCTestCase {

    private var sut: Networking!
    
    private var cancellableBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        URLProtocol.registerClass(MockURLProtocol.self)
        
        sut = .init(session: URLSession(configuration: configuration))
    }
    
    override func tearDown() {
        
        sut = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        
        super.tearDown()
    }
    
    func testRequest_ShouldReturnSameURL() {
        
        let expectation = expectation(description: "request expectation")
        
        defer { waitForExpectations(timeout: 1) }
        
        let url = URL(string: "http://test.com")!
        
        let mockResponse = Networking.Response<String>(
            data: "Test",
            response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        )
        
        let request = URLRequest(url: url)
        
        sut
            .request(request)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { (response: Networking.Response<String>) in
                    expectation.fulfill()
                    XCTAssertEqual(response.response.url, mockResponse.response.url)
                    XCTAssertEqual(response.response.statusCode, mockResponse.response.statusCode)
                    XCTAssertNil(response.response.allHeaderFields)
            })
            .store(in: &cancellableBag)
    }
}
