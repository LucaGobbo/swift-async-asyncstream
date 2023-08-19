//
//  AsyncStream.swift
//
//
//  Created by Luca Gobbo on 15/08/2023.
//

public extension AsyncStream {
    /// Convert an asynchronous AsyncStream into a standard AsyncStream.
    init<S: AsyncSequence>(_ sequence: @escaping () async -> S) where S.Element == Element {
        var iterator: S.AsyncIterator?
        self.init {
            if iterator == nil {
                iterator = await sequence().makeAsyncIterator()
            }
            return try? await iterator?.next()
        }
    }
}
