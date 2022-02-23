//
//  ApiError.swift
//  RestClient
//
//  Created by Akash Rastogi on 23/2/22.
//

import Foundation

public struct ApiError: Error {
  public let httpURLResponse: HTTPURLResponse?
  public let httpRawResponse: Data?

  public init(
    httpURLResponse: HTTPURLResponse? = nil,
    httpRawResponse: Data? = nil
  ) {
    self.httpURLResponse = httpURLResponse
    self.httpRawResponse = httpRawResponse
  }
}
