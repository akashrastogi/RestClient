//
//  ApiError.swift
//  RestClient
//
//  Created by Akash Rastogi on 23/2/22.
//

import Foundation

public struct ApiError: Error {
  public let httpURLResponse: HTTPURLResponse?
  public let data: Data?

  public init(
    httpURLResponse: HTTPURLResponse? = nil,
    data: Data? = nil,
    error: Error? = nil
  ) {
    self.httpURLResponse = httpURLResponse
    self.data = data
  }
}
