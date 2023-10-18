//
//  APIClient.swift
//  APIClient
//
//  Created by Akash Rastogi on 23/2/22.
//

import Foundation

public protocol APIClientDelegate: AnyObject {
  func willSendRequest(_ request: inout URLRequest)
}

public actor APIClient {
  private let session: URLSession
  private let host: String
  private weak var delegate: APIClientDelegate?

  public init(
    host: String,
    configuration: URLSessionConfiguration = .default,
    delegate: APIClientDelegate? = nil
  ) {
    self.host = host
    self.session = URLSession(configuration: configuration)
    self.delegate = delegate
  }

  public func execute<ApiResponse: Decodable>(
    _ request: RequestResource
  ) async throws -> ApiResponse {
    var urlRequest = try makeRequest(request)
    delegate?.willSendRequest(&urlRequest)
    let (data, response) = try await send(urlRequest)
    try validate(response: response, data: data)
    return try JSONDecoder().decode(ApiResponse.self, from: data)
  }

  public func execute(_ request: RequestResource) async throws -> Void {
    var urlRequest = try makeRequest(request)
    delegate?.willSendRequest(&urlRequest)
    let (data, response) = try await send(urlRequest)
    try validate(response: response, data: data)
  }
}

private extension APIClient {
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

  func makeRequest(_ request: RequestResource) throws -> URLRequest {
    let url = try makeURL(path: request.path, queryParams: request.queryParams)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    if let body = request.body {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
    }
    return urlRequest
  }

  func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
    try await session.data(for: request, delegate: nil)
  }

  func validate(response: URLResponse, data: Data) throws {
    guard let httpResponse = response as? HTTPURLResponse else { return }
    if !(200..<300).contains(httpResponse.statusCode) {
      throw ApiError(httpURLResponse: response as? HTTPURLResponse, data: data)
    }
  }
}