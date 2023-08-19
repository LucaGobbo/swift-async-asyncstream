# swift-async-asyncstream


When you have an Actor which exposes an async stream but you want to just expose the async stream in your interface

## Example

When you have the following code 

```swift
struct Interface {
  var makeStream: () -> AsyncStream<Int>
}

actor MyActor {
  func makeStream() -> AsyncStream<Int>  { 
      // ... 
  }
}

```

### this code won't compile:

```swift

let actor = MyActor()
Interface { 
  actor.makeStream() // ❌ 'async' call in a function that does not support concurrency
}

// or

Interface { 
  await actor.makeStream() // ❌ Cannot pass function of type '() async -> AsyncStream<Int>' to parameter expecting synchronous function type
}

```

### Use the new initialiser the code actualy compiles

```swift
Interface { 
  AsyncStream { 
    await actor.makeStream() 
  }
}
```




