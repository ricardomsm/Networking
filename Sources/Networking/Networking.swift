import Combine
import Foundation

public struct Networking {
    
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(
        _ request: URLRequest,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Response<T>, Error> {
        
        session
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                let decodedData = try decoder.decode(T.self, from: data)
                return Response(data: decodedData, response: response)
            }
            .receive(on: session.delegateQueue)
            .eraseToAnyPublisher()
    }
}

public extension Networking {
    
    struct Response<T> {
        
        public let data: T
        public let response: URLResponse
        
        public init(data: T, response: URLResponse) {
            self.data = data
            self.response = response
        }
    }
}

extension Networking.Response: Equatable where T: Equatable {}

