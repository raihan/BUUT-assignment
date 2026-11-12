//
//  ApiServiceTests.swift
//  ApiService
//
//  Created by Abdullah Zubair on 11/11/2026.
//

import Foundation
import Testing
@testable import ApiService

@Suite(.serialized)
struct ApiServiceTests {
    let subject = ApiService(configuration: .stub)

    init() {
        // The stub is shared by all tests, so start every test from a clean state.
        URLProtocolStub.error = nil
        URLProtocolStub.requestHandler = nil
    }

    @Test
    func successfulRequest() async throws {
        let model = ModelMock(int: 42)

        URLProtocolStub.requestHandler = { urlRequest in
            #expect(urlRequest.url == URL(string: .baseUrl + "/test"))
            return (HTTPURLResponse(), try JSONEncoder().encode(model))
        }

        let request = Request(path: "/test")
        let decodedModel: ModelMock = try await subject.send(request, ModelMock.self)
        #expect(model == decodedModel)
    }

    @Test func badURL() async throws {
        let error = await #expect(throws: ApiError.self) {
            _ = try await subject.send(.init(path: "test"), ModelMock.self)
        }

        guard case .invalidUrl = error else {
            Issue.record("Expected .invalidUrl, got \(String(describing: error))")
            return
        }
    }

    @Test func requestFailure() async throws {
        URLProtocolStub.error = .other(URLError(.notConnectedToInternet))

        let error = await #expect(throws: ApiError.self) {
            _ = try await subject.send(.init(path: "/test"), ModelMock.self)
        }

        guard case .requestFailure = error else {
            Issue.record("Expected .requestFailure, got \(String(describing: error))")
            return
        }
    }

    @Test func invalidHTTPStatus() async throws {
        let url = try #require(URL(string: .baseUrl + "/test/1/1"))

        URLProtocolStub.requestHandler = { urlRequest in
            #expect(urlRequest.url == url)

            return (
                try #require(HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)),
                Data()
            )
        }

        let error = await #expect(throws: ApiError.self) {
            _ = try await subject.send(.init(path: "/test/1/1"), ModelMock.self)
        }

        guard case .statusCode(500) = error else {
            Issue.record("Expected .statusCode(500), got \(String(describing: error))")
            return
        }
    }

    @Test func decodingFailed() async throws {
        let url = URL(string: .baseUrl + "/test/1/1")

        URLProtocolStub.requestHandler = { urlRequest in
            #expect(urlRequest.url == url)
            return (HTTPURLResponse(), Data())
        }

        let error = await #expect(throws: ApiError.self) {
            _ = try await subject.send(.init(path: "/test/1/1"), ModelMock.self)
        }

        guard case .decodeFailed = error else {
            Issue.record("Expected .decodeFailed, got \(String(describing: error))")
            return
        }
    }
}
