//
//  LiveValue.swift
//  Live
//
//  Created by Anton Heestand on 2018-11-26.
//  Open Source - MIT License
//

import Foundation

public protocol LiveValue: class {

    var name: String? { get }
    var description: String { get }
    
    /// auto thing
    var type: Any.Type { get }

    var uniformIsNew: Bool { get }
    
    func listenToLive(_ callback: @escaping () -> ())
    
}

public extension LiveValue {
    func listenToLive(_ callback: @escaping () -> ()) {
        if let liveBool: LiveBool = self as? LiveBool {
            liveBool.liveCallbacks.append(callback)
        } else if let liveInt: LiveInt = self as? LiveInt {
            liveInt.liveCallbacks.append(callback)
        } else if let liveFloat: LiveFloat = self as? LiveFloat {
            liveFloat.liveCallbacks.append(callback)
        } else if let livePoint: LivePoint = self as? LivePoint {
            livePoint.rawCombo.forEach { raw in
                raw.liveCallbacks.append(callback)
            }
        } else if let liveSize: LiveSize = self as? LiveSize {
            liveSize.rawCombo.forEach { raw in
                raw.liveCallbacks.append(callback)
            }
        } else if let liveRect: LiveRect = self as? LiveRect {
            liveRect.rawCombo.forEach { raw in
                raw.liveCallbacks.append(callback)
            }
        } else if let liveColor: LiveColor = self as? LiveColor {
            liveColor.rawCombo.forEach { raw in
                raw.liveCallbacks.append(callback)
            }
        } else if let liveVec: LiveVec = self as? LiveVec {
            liveVec.rawCombo.forEach { raw in
                raw.liveCallbacks.append(callback)
            }
        }
    }
}

public protocol LiveComboValue: LiveValue {

    associatedtype RAW: LiveRawValue
    var rawCombo: [RAW] { get }
    
}

public protocol LiveRawValue: LiveValue {
    
    associatedtype T: Equatable
    
    var liveValue: () -> (T) { get }
    init(_ value: T)
    init(_ liveValue: @escaping () -> (T))
    
    var liveCallbacks: [() -> ()] { get set }
    
    var liveCache: T! { get set }
    func checkFuture()
    
}


extension LiveRawValue {
    public func checkFuture() {
        liveCache = liveValue()
        LiveValues.main.listenToFrames { [weak self] in
            guard let self = self else { return }
            guard self.liveCache != self.liveValue() else { return }
            self.liveCache = self.liveValue()
            self.liveCallbacks.forEach({ $0() })
        }
    }
}
