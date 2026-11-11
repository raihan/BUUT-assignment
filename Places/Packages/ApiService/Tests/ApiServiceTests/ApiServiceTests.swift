//
//  ApiServiceTests.swift
//  ApiService
//
//  Created by Abdullah Zubair on 13/07/2026.
//

import Foundation
import Testing
@testable import ApiService

@Suite(.serialized)
struct ApiServiceTests {
    private let baseUrl = URL(string: "https://mock.url")!

    @Test
    func successfulRequest() async throws {
        let subject = ApiService(configuration: .stub)

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
        let subject = ApiService(configuration: .stub)

        URLProtocolStub.error = ApiError.invalidUrl

        await #expect(throws: ApiError.self) {
            _ = try await subject.send(.init(path: "test"), ModelMock.self)
        }
    }

    @Test func invalidHTTPStatus() async throws {
        let subject = ApiService(configuration: .stub)
        let url = URL(string: .baseUrl + "/test/1/1")!

        URLProtocolStub.requestHandler = { urlRequest in
            #expect(urlRequest.url == url)

            return (
                try #require(HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)),
                Data()
            )
        }

        await #expect(throws: ApiError.self) {
            _ = try await subject.send(.init(path: "/test/1/1"), ModelMock.self)
        }
    }

    @Test func decodingFailed() async throws {
        let subject = ApiService(configuration: .stub)
        let url = URL(string: .baseUrl + "/test/1/1")

        URLProtocolStub.requestHandler = { urlRequest in
            #expect(urlRequest.url == url)
            return (HTTPURLResponse(), Data())
        }

        await #expect(throws: ApiError.self) {
            _ = try await subject.send(.init(path: "/test/1/1"), ModelMock.self)
        }
    }
}
