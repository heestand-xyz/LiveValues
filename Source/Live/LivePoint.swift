//
//  LivePoint.swift
//  Live
//
//  Created by Anton Heestand on 2018-11-27.
//  Open Source - MIT License
//

#if os(macOS)
import AppKit
#endif
import CoreGraphics

public class LivePoint: LiveComboValue, CustomStringConvertible {
    
    public typealias RAW = LiveFloat
    
    public var name: String?
    
    public let type: Any.Type = CGPoint.self
    
    public var liveCallbacks: [() -> ()] = []
    
    public var x: LiveFloat
    public var y: LiveFloat
    
    public var rawCombo: [LiveFloat] { [x, y] }
    
    public var description: String {
        let _x: CGFloat = round(CGFloat(x) * 1_000) / 1_000
        let _y: CGFloat = round(CGFloat(y) * 1_000) / 1_000
        return "live\(name != nil ? "[\(name!)]" : "")(x:\("\(_x)".zfill(3)),y:\("\(_y)".zfill(3)))"
    }
    
    public var size: LiveSize { return LiveSize(w: x, h: y) }
    
    // MARK: Uniform
    
    public var uniformIsNew: Bool {
        return x.uniformIsNew || y.uniformIsNew
    }
    
    public var uniformList: [CGFloat] {
        return [x.uniform, y.uniform]
    }
    
    public var cg: CGPoint {
        return CGPoint(x: x.cg, y: y.cg)
    }
    
    // MARK: Points
    
//    public static var circle: LiveColor {
//    }
    
    public static var zero: LivePoint { return LivePoint(x: 0.0, y: 0.0) }
    
    // MARK: - Life Cycle
    
    public init(_ liveValue: @escaping () -> (CGPoint)) {
        x = LiveFloat({ liveValue().x })
        y = LiveFloat({ liveValue().y })
    }
    
    public init(x: LiveFloat, y: LiveFloat) {
        self.x = x
        self.y = y
    }
    
    public init(_ point: CGPoint) {
        x = LiveFloat(point.x)
        y = LiveFloat(point.y)
    }
    
    public init(name: String, point: CGPoint) {
        self.name = name
        x = LiveFloat(point.x)
        y = LiveFloat(point.y)
    }
    
    public init(_ vector: CGVector) {
        x = LiveFloat(vector.dx)
        y = LiveFloat(vector.dy)
    }
    
    public init(name: String, vector: CGVector) {
        self.name = name
        x = LiveFloat(vector.dx)
        y = LiveFloat(vector.dy)
    }
    
//    public init(xRel: LiveFloat, yRel: LiveFloat, res: NODE.Res) {
//        x = LiveFloat({ return CGFloat(xRel) / res.width })
//        y = LiveFloat({ return CGFloat(yRel) / res.width })
//    }
    
    // MARK: Flow Funcs
    
    public func delay(frames: LiveInt) -> LivePoint {
        return LivePoint(x: x.delay(frames: frames), y: y.delay(frames: frames))
    }
    
    public func delay(seconds: LiveFloat) -> LivePoint {
        return LivePoint(x: x.delay(seconds: seconds), y: y.delay(seconds: seconds))
    }
    
//    /// filter over frames.
//    public func filter(frames: LiveInt) -> LivePoint {
//        return LivePoint(x: x.filter(frames: frames), y: y.filter(frames: frames))
//    }
    
    /// filter over seconds. smooth off is linear. smooth on is cosine smoothness (default)
    public func filter(seconds: LiveFloat, smooth: Bool = true) -> LivePoint {
        return LivePoint(x: x.filter(seconds: seconds, smooth: smooth), y: y.filter(seconds: seconds, smooth: smooth))
    }
    
    public func liveCircle(seconds: LiveFloat = 1.0, scale: LiveFloat = 1.0) -> LivePoint {
        return LivePoint(x: cos(.live * seconds) * scale, y: sin(.live * seconds) * scale)
    }
    
    /// noise is a combo of liveRandom and smooth filter
    ///
    /// deafults - liveRandom range: -0.5...0.5 - filter seconds: 1.0
    public static func noise(xRange: ClosedRange<CGFloat> = -0.5...0.5,
                             yRange: ClosedRange<CGFloat> = -0.5...0.5,
                             seconds: LiveFloat = 1.0) -> LivePoint {
        return LivePoint(x: LiveFloat.noise(range: xRange, seconds: seconds),
                         y: LiveFloat.noise(range: yRange, seconds: seconds))
    }
    
    // MARK: Equatable
    
    public static func == (lhs: LivePoint, rhs: LivePoint) -> LiveBool {
        return LiveBool({ return CGFloat(lhs.x) == CGFloat(rhs.x) && CGFloat(lhs.y) == CGFloat(rhs.y) })
    }
    public static func != (lhs: LivePoint, rhs: LivePoint) -> LiveBool {
        return !(lhs == rhs)
    }
    
    // MARK: Operators
    
    public static func + (lhs: LivePoint, rhs: LivePoint) -> LivePoint {
        return LivePoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    public static func + (lhs: LivePoint, rhs: LiveFloat) -> LivePoint {
        return LivePoint(x: lhs.x + rhs, y: lhs.y + rhs)
    }
    public static func + (lhs: LiveFloat, rhs: LivePoint) -> LivePoint {
        return LivePoint(x: lhs + rhs.x, y: lhs + rhs.y)
    }
    public static func += (lhs: inout LivePoint, rhs: LivePoint) {
        let _lhs = lhs; lhs = LivePoint(x: _lhs.x + rhs.x, y: _lhs.y + rhs.y)
    }
    public static func += (lhs: inout LivePoint, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LivePoint(x: _lhs.x + rhs, y: _lhs.y + rhs)
    }
    
    public static func - (lhs: LivePoint, rhs: LivePoint) -> LivePoint {
        return LivePoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    public static func - (lhs: LivePoint, rhs: LiveFloat) -> LivePoint {
        return LivePoint(x: lhs.x - rhs, y: lhs.y - rhs)
    }
    public static func - (lhs: LiveFloat, rhs: LivePoint) -> LivePoint {
        return LivePoint(x: lhs - rhs.x, y: lhs - rhs.y)
    }
    public static func -= (lhs: inout LivePoint, rhs: LivePoint) {
        let _lhs = lhs; lhs = LivePoint(x: _lhs.x - rhs.x, y: _lhs.y - rhs.y)
    }
    public static func -= (lhs: inout LivePoint, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LivePoint(x: _lhs.x - rhs, y: _lhs.y - rhs)
    }
    
    public static func * (lhs: LivePoint, rhs: LivePoint) -> LivePoint {
        return LivePoint(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    public static func * (lhs: LivePoint, rhs: LiveFloat) -> LivePoint {
        return LivePoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    public static func * (lhs: LiveFloat, rhs: LivePoint) -> LivePoint {
        return LivePoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    public static func *= (lhs: inout LivePoint, rhs: LivePoint) {
        let _lhs = lhs; lhs = LivePoint(x: _lhs.x * rhs.x, y: _lhs.y * rhs.y)
    }
    public static func *= (lhs: inout LivePoint, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LivePoint(x: _lhs.x * rhs, y: _lhs.y * rhs)
    }
    
    public static func / (lhs: LivePoint, rhs: LivePoint) -> LivePoint {
        return LivePoint(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    public static func / (lhs: LivePoint, rhs: LiveFloat) -> LivePoint {
        return LivePoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    public static func / (lhs: LiveFloat, rhs: LivePoint) -> LivePoint {
        return LivePoint(x: lhs / rhs.x, y: lhs / rhs.y)
    }
    public static func /= (lhs: inout LivePoint, rhs: LivePoint) {
        let _lhs = lhs; lhs = LivePoint(x: _lhs.x / rhs.x, y: _lhs.y / rhs.y)
    }
    public static func /= (lhs: inout LivePoint, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LivePoint(x: _lhs.x / rhs, y: _lhs.y / rhs)
    }
    
    public prefix static func - (operand: LivePoint) -> LivePoint {
        return LivePoint(x: -operand.x, y: -operand.y)
    }
    
    
    public func flipX() -> LivePoint {
        return LivePoint(x: -x, y: y)
    }
    public func flipY() -> LivePoint {
        return LivePoint(x: x, y: -y)
    }
    public func flipXY() -> LivePoint {
        return LivePoint(x: -x, y: -y)
    }
    public func flop() -> LivePoint {
        return LivePoint(x: y, y: x)
    }
    
}

public func atan(of point: LivePoint) -> LiveFloat {
    return LiveFloat({ return atan2(CGFloat(point.y), CGFloat(point.x)) })
}

public func pointFrom(angle: LiveFloat, radius: LiveFloat = 0.5) -> LivePoint {
    return LivePoint(x: cos(angle * .pi * 2) * radius, y: sin(angle * .pi * 2) * radius)
}
