import Foundation

public extension URLRequest {
    
    init(
        url: URL,
        httpMethod: RequestMethod,
        headers: [String: String] = [:],
        cachePolicy: CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60
    ) {
        
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        setHTTPMethod(httpMethod)
        setHeaders(headers)
    }
    
    mutating func setHeaders(_ headers: [String: String]) {
        headers.forEach { addValue($1, forHTTPHeaderField: $0) }
    }
    
    mutating func setHTTPMethod(_ method: RequestMethod) { httpMethod = method.rawValue }
}
