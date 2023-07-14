import Combine
import Foundation

public struct Networking {
	var request: (URLRequest, JSONDecoder) async throws -> (Data, HTTPURLResponse)
}

extension Networking {

	enum Error: Swift.Error {
		case invalidResponse
	}

	public struct Response<T> {
		public let data: T
		public let response: HTTPURLResponse

		public init(data: T, response: HTTPURLResponse) {
			self.data = data
			self.response = response
		}
	}
}

extension Networking {
	public static func live(session: URLSession = .shared) -> Self {
		.init(
			request: { request, decoder in
				let (data, response) = try await session.data(for: request)
				guard let urlResponse = response as? HTTPURLResponse else { throw Error.invalidResponse }
				return (data, urlResponse)
			}
		)
	}

	public static func mock(response: @escaping () -> (Data, HTTPURLResponse)) -> Self { Self { _, _ in response() } }

	public func apiRequest<T: Decodable>(
		urlRequest: URLRequest,
		decoder: JSONDecoder = .init()
	) async throws -> Response<T> {
		let (data, response) = try await request(urlRequest, decoder)
		let decodedData = try decoder.decode(T.self, from: data)
		return Response(data: decodedData, response: response)
	}
}
