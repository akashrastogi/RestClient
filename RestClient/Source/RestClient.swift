//
//  APIClient.swift
//  RestClient
//
//  Created by Akash Rastogi on 23/2/22.
//

import Foundation

public actor RestClient {
  private let session: URLSession
  private let host: String
  public init(
    host: String,
    configuration: URLSessionConfiguration = .ephemeral
  ) {
    self.host = host
    session = URLSession(configuration: configuration)
  }

  public func send<T: Decodable>(_ request: Request<T>) async throws -> T {
    let urlRequest = try await makeRequest(request)
    let response = try await session.data(for: urlRequest, delegate: nil)
    if let httpResponse = response.1 as? HTTPURLResponse,
       (200 ..< 300).contains(httpResponse.statusCode)
    {
      return try JSONDecoder().decode(T.self, from: response.0)
    } else {
      throw ApiError(
        httpURLResponse: response.1 as? HTTPURLResponse,
        httpRawResponse: response.0
      )
    }
  }
}

private extension RestClient {
  func makeURL(path: String, queryParams: [String: String]?) throws -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path
    var queryItems = [URLQueryItem]()
    queryParams?.forEach {
      queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
    }
    components.queryItems = queryItems
    guard let url = components.url else {
      throw URLError(.badURL)
    }
    return url
  }

  func makeRequest<T>(_ request: Request<T>) async throws -> URLRequest {
    let url = try makeURL(path: request.path, queryParams: request.queryParams)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    if let body = request.body {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
    }
    return urlRequest
  }
}
