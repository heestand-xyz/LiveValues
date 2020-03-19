//
//  Created by Anton Heestand on 2020-02-20.
//

import Foundation
import Combine

@available(OSX 10.15, *)
@available(iOS 13.0, *)
@available(tvOS 13.0, *)
public protocol AnyLive {
    func sink(update: @escaping () -> ()) -> AnyCancellable
}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
@available(tvOS 13.0, *)
@propertyWrapper public class Live<T>: AnyLive, CustomStringConvertible {
    public let name: String
    var snakeName: String { name.lowercased().replacingOccurrences(of: " ", with: "_") }
    public let info: String?
    public var description: String { "live-\(snakeName)(\(wrappedValue))" }
    public var wrappedValue: T {
        didSet {
            callbacks.forEach({ $0(wrappedValue) })
            if let liveValue = wrappedValue as? LiveValue {
                liveValue.listenToLive { [weak self] in
                    guard let self = self else { return }
                    self.callbacks.forEach({ $0(self.wrappedValue) })
                }
            }
        }
    }
    var callbacks: [(T) -> ()] = []
    public init(wrappedValue initialValue: T) {
        wrappedValue = initialValue
        self.name = ""
        self.info = nil
    }
    public init(default defaultValue: T, name: String, info: String? = nil) {
        wrappedValue = defaultValue
        self.name = name
        self.info = info
    }
    public func publisher() -> LivePublisher<T> {
        LivePublisher(live: self)
    }
    func sink(receiveValue: @escaping ((T) -> Void)) -> AnyCancellable {
        publisher().sink(receiveValue: receiveValue)
    }
    public func sink(update: @escaping () -> ()) -> AnyCancellable {
        publisher().sink(receiveValue: { _ in update() })
    }
    public func getLive<T>() -> Live<T>? {
        return self as? Live<T>
    }
}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
@available(tvOS 13.0, *)
public struct LivePublisher<T>: Publisher {
    public typealias Output = T
    public typealias Failure = Never
    let live: Live<T>
    init(live: Live<T>) {
        self.live = live
    }
    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == LivePublisher.Failure, S.Input == LivePublisher.Output {
        let subscription = LiveSubscription(subscriber: subscriber, live: live)
        subscriber.receive(subscription: subscription)
    }
}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
@available(tvOS 13.0, *)
final class LiveSubscription<SubscriberType: Subscriber, T>: Subscription where SubscriberType.Input == T {
    private var subscriber: SubscriberType?
    let live: Live<T>
    init(subscriber: SubscriberType, live: Live<T>) {
        self.subscriber = subscriber
        self.live = live
        live.callbacks.append { value in
            _ = self.subscriber?.receive(value)
        }
    }
    func request(_ demand: Subscribers.Demand) {}
    func cancel() {
        subscriber = nil
    }
}
