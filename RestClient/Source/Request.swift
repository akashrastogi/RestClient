//
//  Request.swift
//  RestClient
//
//  Created by Akash Rastogi on 22/2/22.
//

import Foundation

// MARK: URL Scheme

public enum Scheme: String {
  case http = "http"
  case https = "https"
}

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

public struct RequestResource {
  let method: HttpMethod
  let path: String
  let queryParams: [String: String]? = nil
  let body: [String: AnyObject]? = nil
  let headers: [String: String]? = nil
  let shouldRetry: Bool = true
}
