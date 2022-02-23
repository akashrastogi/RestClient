//
//  Request.swift
//  RestClient
//
//  Created by Akash Rastogi on 22/2/22.
//

import Foundation

// MARK: Http Methods

public enum HttpMethod: String {
  case get = "GET"
  case head = "HEAD"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

// MARK: Request parameters

public struct Request<Response> {
  var method: HttpMethod
  var path: String
  var queryParams: [String: String]? = nil
  var body: [String: AnyObject]? = nil
  var headers: [String: String]? = nil
  var shouldRetry: Bool = true
}
