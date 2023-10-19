//
//  MockData.swift
//  RestClientTests
//
//  Created by Akash Rastogi on 20/10/23.
//

import Foundation

enum MockData {
  static var validUserData: Data {
    """
    {
      "userId": 101,
      "name": "Akash",
      "city": "Singapore"
    }
    """.data(using: .utf8)!
  }
  
  static var invalidUserData: Data {
    """
    {
      "userId": 101,
      "city": "Singapore"
    }
    """.data(using: .utf8)!
  }
}
