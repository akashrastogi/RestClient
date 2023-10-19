//
//  RestClientTests.swift
//  RestClientTests
//
//  Created by Akash Rastogi on 19/10/23.
//

import XCTest
@testable import RestClient

final class RestClientTests: XCTestCase {
  var apiClient: APIClient!

  override func setUp() {
    super.setUp()

    // Configure the MockURLProtocol and URLSession for your tests
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]

    apiClient = APIClient(scheme: .https, host: "example.com", configuration: configuration)
  }

  override func tearDown() {
    apiClient = nil
    super.tearDown()
  }

  func testSuccessAPICall() async throws {
    let resource = RequestResource(method: .get, path: "/user", queryParams: ["id": "1"])
    MockURLProtocol.requestHandler = {request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
      return (response, MockData.validUserData)
    }
    let result: User = try await apiClient.execute(resource)
    XCTAssertEqual(result.userId, 101)
    XCTAssertEqual(result.name, "Akash")
    XCTAssertEqual(result.city, "Singapore")
  }

  func testBadStatusCode() async throws {
    let resource = RequestResource(method: .get, path: "/user", queryParams: ["id": "1"])
    MockURLProtocol.requestHandler = {request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: "2.0", headerFields: nil)!
      return (response, MockData.validUserData)
    }
    do {
      let _: User = try await apiClient.execute(resource)
      XCTFail("Error needs to be thrown")
    } catch {
      XCTAssertEqual(error as? ApiError, .customError(httpURLResponse: nil, data: nil))
    }
  }

  func testParsingFailed() async throws {
    let resource = RequestResource(method: .get, path: "/user", queryParams: ["id": "1"])
    MockURLProtocol.requestHandler = {request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
      return (response, MockData.invalidUserData)
    }
    do {
      let _: User = try await apiClient.execute(resource)
      XCTFail("Error needs to be thrown")
    } catch {
      XCTAssertEqual(error as? ApiError, .parsingFailed(error: NSError()))
    }
  }
}
