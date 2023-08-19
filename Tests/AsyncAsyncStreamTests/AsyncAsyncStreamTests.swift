//
//  AsyncAsyncStreamTests.swift
//
//
//  Created by Luca Gobbo on 15/08/2023.
//

import XCTest
@testable import AsyncAsyncStream

@available(iOS 16.0, *)
final class AsyncAsyncStreamTests: XCTestCase {
    func stream() async -> AsyncStream<Int> {
        AsyncStream { continuation in
            Task {
                continuation.yield(1)
                try await Task.sleep(for: .milliseconds(100))
                continuation.yield(2)
                try await Task.sleep(for: .milliseconds(100))
                continuation.yield(3)
                try await Task.sleep(for: .milliseconds(200))
                continuation.finish()
            }
        }
    }

    func testStream() async throws {
        let mappedStream = AsyncStream {
            await self.stream()
        }

        var result: [Int] = []
        for await output in mappedStream {
            result.append(output)
        }

        XCTAssertEqual([1, 2, 3], result)
    }
}
