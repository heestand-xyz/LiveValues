//
//  Created by Anton Heestand on 2020-02-20.
//

import Foundation
import Combine

public protocol AnyLive: Identifiable, Equatable, Codable {}

@propertyWrapper public class Live<T: AnyLive> {
    public let name: String
    public let info: String
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
    public init(default defaultValue: T, name: String, info: String) {
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
}

public struct LivePublisher<T: AnyLive>: Publisher {
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

final class LiveSubscription<SubscriberType: Subscriber, T: AnyLive>: Subscription where SubscriberType.Input == T {
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

struct AnyAnyLive<T: AnyLive> {
    let val: T
    init(_ val: T) {
        self.val = val
    }
}
