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

| RxSwift                       | Combine                               | Notes                                                                                                    |
|-------------------------------|---------------------------------------|----------------------------------------------------------------------------------------------------------|
| asObservable()                | eraseToAnyPublisher()                 |                                                                                                          |
| asObserver()                  | eraseToAnySubject()                   |                                                                                                          |
| bind(to:)                     | `assign(to:on:)`                      | Assign uses a KeyPath which is really nice and useful. RxSwift needs a Binder / ObserverType to bind to. |
| buffer                        | buffer                                |                                                                                                          |
| catchError                    | catch                                 |                                                                                                          |
| catchErrorJustReturn          | catch + just                          |                                                                                                          |
| combineLatest                 | combineLatest, tryCombineLatest       |                                                                                                          |
| compactMap                    | compactMap, tryCompactMap             |                                                                                                          |
| concat                        | append, prepend                       |                                                                                                          |
| debounce                      | debounce                              |                                                                                                          |
| debug                         | print                                 |                                                                                                          |
| delay                         | delay                                 |                                                                                                          |
| distinctUntilChanged          | removeDuplicates, tryRemoveDuplicates |                                                                                                          |
| do                            | handleEvents                          |                                                                                                          |
| enumerated + skipWhile + take | output(at:), output(in:)              |                                                                                                          |
| filter                        | filter, tryFilter                     |                                                                                                          |
| first                         | first, tryFirst                       |                                                                                                          |
| flatMap                       | flatMap                               |                                                                                                          |
| flatMapLatest                 | switchToLatest                        |                                                                                                          |
| ifEmpty(switchTo:)            | replaceEmpty(with:)                   |                                                                                                          |
| ignoreElements()              | ignoreOutput()                        |                                                                                                          |
| just()                        | Publishers.Just()                     |                                                                                                          |
| map                           | map, tryMap                           |                                                                                                          |
| merge                         | merge, tryMerge                       |                                                                                                          |
| multicast                     | multicast                             |                                                                                                          |
| observeOn                     | receive(on:)                          |                                                                                                          |
| reduce                        | reduce, tryReduce                     |                                                                                                          |
| retry, retry(3)               | retry, retry(3)                       |                                                                                                          |
| scan                          | scan, tryScan                         |                                                                                                          |
| share                         | share                                 | There doesn't seem to be a share(replay: 1) in Combine, yet                                              |
| skip(3)                       | dropFirst(3)                          |                                                                                                          |
| skipUntil                     | drop(untilOutputFrom:)                |                                                                                                          |
| skipWhile                     | drop(while:), tryDrop(while:)         |                                                                                                          |
| subscribe                     | sink                                  |                                                                                                          |
| subscribeOn                   | subscribe(on:)                        | RxSwift uses Schedulers Combine uses RunLoop, DispatchQueue, and OperationQueue.                         |
| take(3).toArray()             | collect(3)                            |                                                                                                          |
| takeLast                      | last                                  |                                                                                                          |
| throttle                      | throttle                              |                                                                                                          |
| timeout                       | timeout                               |                                                                                                          |
| toArray()                     | collect()                             |                                                                                                          |
| zip                           | zip                                   |                                                                                                          |


# Contributing
Add any data/operators to the appropriate CSV files in the **Data** folder, run `bundle install` and `generate.rb`.

Finally, commit the changes and submit a Pull Request.