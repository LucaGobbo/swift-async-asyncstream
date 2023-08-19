//
//  AsyncStream.swift
//
//
//  Created by Luca Gobbo on 15/08/2023.
//

public extension AsyncStream {
    /// Convert an asynchronous AsyncStream into a standard AsyncStream. In certain scenarios, an actor might provide an
    /// asynchronous stream which will require the callee to use the await keyword when calling it. However, situations
    /// may arise where the stream must be utilized within a non-asynchronous context. By employing this initializer,
    /// the stream can be converted into a regular AsyncStream to accommodate such requirements.
    ///
    /// #Example code
    /// ```
    ///
    /// actor MyActor {
    ///   func myStream() -> AsyncStream<Int> { ... }
    /// }
    ///
    /// // the interface
    /// struct MyClient {
    ///   var myStream: () -> AsyncStream<Int>
    /// }
    ///
    /// MyClient {
    ///   let actor = MyActor()
    ///   return AsyncStream { await actor.myStream() }
    /// }
    /// ```
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
