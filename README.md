# RxSwift to Combine Cheatsheet
This is a Cheatsheet for [RxSwift](https://github.com/ReactiveX/RxSwift) developers interested in Apple's new [Combine](https://developer.apple.com/documentation/combine) framework.

It's based on the following blog post: [https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b](https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b)

## [Basics](Data/basics.csv)

|                       | RxSwift                          | Combine                                    |
|-----------------------|----------------------------------|--------------------------------------------|
| Deployment Target     | iOS 8.0+                         | iOS 13.0+                                  |
| Platforms supported   | iOS, macOS, tvOS, watchOS, Linux | iOS, macOS, tvOS, watchOS, UIKit for Mac ¹ |
| Spec                  | Reactive Extensions (ReactiveX)  | Reactive Streams (+ adjustments)           |
| Framework Consumption | Third-party                      | First-party (built-in)                     |
| Maintained by         | Open-Source / Community          | Apple                                      |
| UI Bindings           | RxCocoa                          | SwiftUI ²                                  |


## [Core Components](Data/core_components.csv)

| RxSwift                   | Combine                  | Notes                                                                                                                                                           |
|---------------------------|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Observable                | Publisher                |                                                                                                                                                                 |
| Driver                    | BindableObject (SwiftUI) | Both guarantee no failure, but Driver guarantees delivery on Main Thread. In Combine, SwiftUI recreates the entire view hierarachy on the Main Thread, instead. |
| Single                    | Future                   |                                                                                                                                                                 |
| Disposable                | Cancellable              | There's no DisposeBag in Combine, AnyCancellable cancels on deinit.                                                                                             |
| Observer                  | Subscriber               |                                                                                                                                                                 |
| ConnectableObservableType | ConnectablePublisher     |                                                                                                                                                                 |
| SubjectType               | Subject                  |                                                                                                                                                                 |
| PublishSubject            | PassthroughSubject       |                                                                                                                                                                 |
| BehaviorSubject           | CurrentValueSubject      | This seems to be the type that holds @State under the hood                                                                                                      |
| SchedulerType             | Scheduler                |                                                                                                                                                                 |


## [Operators](Data/operators.csv)

| RxSwift              | Combine                                  | Notes                                                                                                    |
|----------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------|
| asObservable()       | eraseToAnyPublisher()                    |                                                                                                          |
| asObserver()         | eraseToAnySubject()                      |                                                                                                          |
| bind(to:)            | `assign(to:on:)`                         | Assign uses a KeyPath which is really nice and useful. RxSwift needs a Binder / ObserverType to bind to. |
| buffer               | buffer                                   |                                                                                                          |
| catchError           | catch                                    |                                                                                                          |
| catchErrorJustReturn | replaceError(with:)                      |                                                                                                          |
| combineLatest        | combineLatest, tryCombineLatest          |                                                                                                          |
| compactMap           | compactMap, tryCompactMap                |                                                                                                          |
| concat               | append, prepend                          |                                                                                                          |
| concatMap            | ❌                                        |                                                                                                          |
| create               | AnyPublisher                             | AnyPublisher has an initializer with an anonymous closure, similar to Observable.create                  |
| debounce             | debounce                                 |                                                                                                          |
| debug                | print                                    |                                                                                                          |
| ifEmpty(default:)    | ❌                                        |                                                                                                          |
| ifEmpty(switchTo:)   | replaceEmpty(with:)                      |                                                                                                          |
| deferred             | Publishers.Deferred                      |                                                                                                          |
| delay                | delay                                    |                                                                                                          |
| delaySubscription    | ❌                                        |                                                                                                          |
| dematerialize        | ❌                                        |                                                                                                          |
| distinctUntilChanged | removeDuplicates, tryRemoveDuplicates    |                                                                                                          |
| do                   | handleEvents                             |                                                                                                          |
| elementAt            | output(at:)                              |                                                                                                          |
| empty                | Publishers.Empty(completeImmediately: true) |                                                                                                          |
| enumerated           | ❌                                        |                                                                                                          |
| error                | Publishers.Once                          | Publishers.Once has an initializer that takes an Error                                                   |
| filter               | filter, tryFilter                        |                                                                                                          |
| first                | first, tryFirst                          |                                                                                                          |
| flatMap              | flatMap                                  |                                                                                                          |
| flatMapFirst         | ❌                                        |                                                                                                          |
| flatMapLatest        | switchToLatest                           |                                                                                                          |
| from                 | ❌                                        |                                                                                                          |
| groupBy              | ❌                                        |                                                                                                          |
| ignoreElements       | ignoreOutput                             |                                                                                                          |
| interval             | ❌                                        |                                                                                                          |
| just                 | Publishers.Just                          |                                                                                                          |
| map                  | map, tryMap                              |                                                                                                          |
| materialize          | ❌                                        |                                                                                                          |
| merge                | merge, tryMerge                          |                                                                                                          |
| multicast            | multicast                                |                                                                                                          |
| never                | Publishers.Empty(completeImmediately: false) |                                                                                                          |
| observeOn            | receive(on:)                             |                                                                                                          |
| of                   | ❌                                        |                                                                                                          |
| range                | ❌                                        |                                                                                                          |
| reduce               | reduce, tryReduce                        |                                                                                                          |
| repeatElement        | ❌                                        |                                                                                                          |
| retry, retry(3)      | retry, retry(3)                          |                                                                                                          |
| retryWhen            | ❌                                        |                                                                                                          |
| sample               | ❌                                        |                                                                                                          |
| scan                 | scan, tryScan                            |                                                                                                          |
| share                | share                                    | There’s no replay in Combine, and no scope. Could be “faked” with multicast.                             |
| skip(3)              | dropFirst(3)                             |                                                                                                          |
| skipUntil            | drop(untilOutputFrom:)                   |                                                                                                          |
| skipWhile            | drop(while:), tryDrop(while:)            |                                                                                                          |
| startWith            | ❌                                        |                                                                                                          |
| subscribe            | sink                                     |                                                                                                          |
| subscribeOn          | subscribe(on:)                           | RxSwift uses Schedulers Combine uses RunLoop, DispatchQueue, and OperationQueue.                         |
| take(3).toArray()    | collect(3)                               |                                                                                                          |
| takeLast             | last                                     |                                                                                                          |
| takeUntil            | prefix(untilOutputFrom:)                 |                                                                                                          |
| throttle             | throttle                                 |                                                                                                          |
| timeout              | timeout                                  |                                                                                                          |
| timer                | Timer.publish                            |                                                                                                          |
| toArray()            | collect()                                |                                                                                                          |
| window               | collect(Publishers.TimeGroupingStrategy) | Combine has a TimeGroupingStrategy.byTimeOrCount that could be used as a window.                         |
| withLatestFrom       | ❌                                        |                                                                                                          |
| zip                  | zip                                      |                                                                                                          |


# Contributing
Add any data/operators to the appropriate CSV files in the **Data** folder, run `bundle install` and `generate.rb`.

Finally, commit the changes and submit a Pull Request.
