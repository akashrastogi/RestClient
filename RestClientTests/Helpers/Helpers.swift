//
//  Helpers.swift
//  RestClientTests
//
//  Created by Akash Rastogi on 20/10/23.
//

import Foundation
@testable import RestClient

extension RestClient.ApiError: Equatable {
  public static func == (lhs: RestClient.ApiError, rhs: RestClient.ApiError) -> Bool {
    switch (lhs, rhs) {
    case (.badUrl, .badUrl): return true
    case (.parsingFailed, .parsingFailed): return true
    case (.customError, .customError): return true
    default: return false
    }
  }
}
