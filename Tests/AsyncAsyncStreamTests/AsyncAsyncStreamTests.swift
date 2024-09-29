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
  
    
    func testMakeStream() async throws {
        let (stream, continuation) = AsyncStream.makeStream(of: Int.self)
        let mappedStream = AsyncStream {
           stream
        }
        
        var result: [Int] = []
        let task = Task {
            for await output in mappedStream {
                result.append(output)
            }
        }
        continuation.yield(1)
        await Task.yield()
        try await Task.sleep(for: .milliseconds(100))
        continuation.yield(2)
        await Task.yield()
        try await Task.sleep(for: .milliseconds(100))
        continuation.yield(3)
        await Task.yield()
        try await Task.sleep(for: .milliseconds(200))
        continuation.finish()
        
        
        
        XCTAssertEqual([1, 2, 3], result)
        
        task.cancel()
    }

    func testStream() async throws {
        
        let finishedStream = self.expectation(description: "wait until stream finsihes")
        
        @Sendable func stream() async -> AsyncStream<Int> {
            
            AsyncStream { continuation in
                Task {
                    continuation.yield(1)
                    await Task.yield()
                    try await Task.sleep(for: .milliseconds(100))
                    continuation.yield(2)
                    await Task.yield()
                    try await Task.sleep(for: .milliseconds(100))
                    continuation.yield(3)
                    await Task.yield()
                    try await Task.sleep(for: .milliseconds(200))
                    print("finish")
                    continuation.finish()
                    print("finsihed")
                    finishedStream.fulfill()
                }
            }
        }
        
        let mappedStream = AsyncStream {
            await stream()
        }

        var result: [Int] = []
        for await output in mappedStream {
            result.append(output)
        }

        XCTAssertEqual([1, 2, 3], result)
        
        await fulfillment(of: [finishedStream], timeout: 1)
        
    }
}
