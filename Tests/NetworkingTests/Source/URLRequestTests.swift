import XCTest
import Networking

final class URLRequestTests: XCTestCase {
    
    func testRequestInit_ShouldReturnValidData() {
        
        let url = URL(string: "https://test.com")!
        let request = URLRequest(url: url, httpMethod: .get, headers: ["testKey": "testValue"])
        
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, RequestMethod.get.rawValue)
        XCTAssertEqual(request.allHTTPHeaderFields, ["testKey": "testValue"])
    }
}
