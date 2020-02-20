//
//  Created by Anton Heestand on 2020-02-20.
//

import Foundation
import Combine

//typealias LiveFloat = Live<CGFloat>

@propertyWrapper class Live<T>/*: Publisher*/ {
    var value: T
    let name: String
    let info: String
    var callbacks: [(T) -> ()] = []
    init(default defaultValue: T, name: String, info: String) {
        value = defaultValue
//        wrappedValue = defaultValue
        self.name = name
        self.info = info
    }
    var wrappedValue: T {
        get { value }
        set {
            print("set", value)
            value = newValue
            callbacks.forEach({ $0(value) })
        }
    }
//    var subscriptions: [LiveSubscription<AnySubscriber, T>] = []
//    public typealias Output = T
//    public typealias Failure = Never
//    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
//        subscriber.receive(subscription: self)
//    }
    func publisher() -> LivePublisher<T> {
        LivePublisher(live: self)
    }
}

struct LivePublisher<T>: Publisher {
    typealias Output = T
    typealias Failure = Never
    let live: Live<T>
    init(live: Live<T>) {
        self.live = live
    }
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == LivePublisher.Failure, S.Input == LivePublisher.Output {
        let subscription = LiveSubscription(subscriber: subscriber, live: live)
        subscriber.receive(subscription: subscription)
    }
}

final class LiveSubscription<SubscriberType: Subscriber, T>: Subscription where SubscriberType.Input == T {
    private var subscriber: SubscriberType?
    let live: Live<T>
    init(subscriber: SubscriberType, live: Live<T>) {
        self.subscriber = subscriber
        self.live = live
        live.callbacks.append { value in
            print("call", value, self.subscriber != nil)
            _ = self.subscriber?.receive(value)
        }
    }
    func request(_ demand: Subscribers.Demand) {}
    func cancel() {
        print("cancel sub")
        subscriber = nil
    }
}
