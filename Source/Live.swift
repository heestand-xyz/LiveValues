//
//  Created by Anton Heestand on 2020-02-20.
//

import Foundation
import Combine

@propertyWrapper class Live<T: LiveValue> {
    let name: String
    let info: String
    var wrappedValue: T {
        didSet {
//            if let raw: LiveRawValue = wrappedValue as? LiveRawValue {
//                raw.liveCallbacks.append {
//                    self.callbacks.forEach({ $0(self.wrappedValue) })
//                }
//            } else if let combo: LiveComboValue = wrappedValue as? LiveComboValue {
//                combo.rawCombo.forEach { raw in
//                    raw.liveCallbacks.append {
//                        callbacks.forEach({ $0(wrappedValue) })
//                    }
//                }
//            }
            callbacks.forEach({ $0(wrappedValue) })
        }
    }
    var callbacks: [(T) -> ()] = []
    init(default defaultValue: T, name: String, info: String) {
        wrappedValue = defaultValue
        self.name = name
        self.info = info
    }
    func publisher() -> LivePublisher<T> {
        LivePublisher(live: self)
    }
}

struct LivePublisher<T: LiveValue>: Publisher {
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

final class LiveSubscription<SubscriberType: Subscriber, T: LiveValue>: Subscription where SubscriberType.Input == T {
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
