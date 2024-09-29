import ConcurrencyExtras
//
//  AsyncStream.swift
//
//
//  Created by Luca Gobbo on 15/08/2023.
//
import Foundation

extension AsyncStream {
    /// Convert an asynchronous AsyncStream into a standard AsyncStream.
    public init<S: AsyncSequence>(_ sequence: @Sendable @escaping () async -> S)
    where S.Element == Element, Element: Sendable {
        self = AsyncAsyncSequence(sequence).eraseToStream()
    }
}

private struct AsyncAsyncSequence<S: AsyncSequence>: AsyncSequence where S.Element: Sendable {
    typealias AsyncIterator = Iterator
    private var sequence: @Sendable () async -> S

    typealias Element = S.Element
    public init(_ sequence: @Sendable @escaping () async -> S) {
        self.sequence = sequence
    }

    func makeAsyncIterator() -> Iterator {
        Iterator(sequence: sequence)
    }

    struct Iterator: AsyncIteratorProtocol {
        var sequence: @Sendable () async -> S
        var iterator: S.AsyncIterator?
        mutating func next() async throws -> Element? {
            if iterator == nil {
                iterator = await sequence().makeAsyncIterator()
            }

            return try await iterator?.next()
        }
    }
}
