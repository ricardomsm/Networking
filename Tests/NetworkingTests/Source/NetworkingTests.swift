import Networking
import XCTest

final class NetworkingTests: XCTestCase {

    private var sut: Networking!
    
    override func setUp() {
        super.setUp()
        
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        URLProtocol.registerClass(MockURLProtocol.self)
        
		sut = .live(session: .init(configuration: configuration))
    }
    
    override func tearDown() {
        
        sut = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        
        super.tearDown()
    }
    
    func testRequest_ShouldReturnSameURL() async throws {

        let url = URL(string: "http://test.com")!
        
        let mockResponse = Networking.Response<String>(
            data: "Test",
			response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [:])!
        )
        
        let request = URLRequest(url: url)
		let response: Networking.Response<String> = try await sut.apiRequest(urlRequest: request)

		XCTAssertEqual(response.data, mockResponse.data)
		XCTAssertEqual(response.response.url, mockResponse.response.url)
		XCTAssertEqual(response.response.statusCode, mockResponse.response.statusCode)
    }
}
