//
//  ApiError.swift
//  RestClient
//
//  Created by Akash Rastogi on 23/2/22.
//

import Foundation

enum ApiError: Error {
  case customError(httpURLResponse: HTTPURLResponse?, data: Data?)
  case badUrl(error: NSError)
  case parsingFailed(error: NSError)
}
