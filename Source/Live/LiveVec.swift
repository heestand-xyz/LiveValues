//
//  LiveVec.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import CoreGraphics
import SceneKit

public class LiveVec: LiveValue {
    
    public var name: String?
    
    public let type: Any.Type = SCNVector3.self
    
    public var x: LiveFloat
    public var y: LiveFloat
    public var z: LiveFloat
    
    public var description: String {
        let _x: CGFloat = round(CGFloat(x) * 1_000) / 1_000
        let _y: CGFloat = round(CGFloat(y) * 1_000) / 1_000
        let _z: CGFloat = round(CGFloat(z) * 1_000) / 1_000
        return "live\(name != nil ? "[\(name!)]" : "")(x:\("\(_x)".zfill(3)),y:\("\(_y)".zfill(3)),z:\("\(_z)".zfill(3)))"
    }
    
    public var uniformIsNew: Bool {
        return x.uniformIsNew || y.uniformIsNew || z.uniformIsNew
    }
    
    public var uniformList: [CGFloat] {
        return [x.uniform, y.uniform, z.uniform]
    }
    
    public static let zero = LiveVec(x: 0, y: 0, z: 0)
    public static let one = LiveVec(x: 1, y: 1, z: 1)
    
    var vec: SCNVector3 {
        SCNVector3(x.cg, y.cg, z.cg)
    }
       
    public enum Axis {
        case x
        case y
        case z
    }
    
    // MARK: - Life Cycle
    
    public init(_ liveValue: @escaping () -> (SCNVector3)) {
        let val = liveValue()
        x = LiveFloat({ return CGFloat(val.x) })
        y = LiveFloat({ return CGFloat(val.y) })
        z = LiveFloat({ return CGFloat(val.z) })
    }
    
    public init(x: LiveFloat, y: LiveFloat, z: LiveFloat) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(_ val: LiveFloat) {
        self.x = val
        self.y = val
        self.z = val
    }
    
    public init(_ vec: SCNVector3) {
        x = LiveFloat(vec.x)
        y = LiveFloat(vec.y)
        z = LiveFloat(vec.z)
    }
        
    // MARK: Flow Funcs
    
    public func delay(frames: LiveInt) -> LiveVec {
        return LiveVec(x: x.delay(frames: frames),
                       y: y.delay(frames: frames),
                       z: z.delay(frames: frames))
    }
    
    public func delay(seconds: LiveFloat) -> LiveVec {
        return LiveVec(x: x.delay(seconds: seconds),
                       y: y.delay(seconds: seconds),
                       z: z.delay(seconds: seconds))
    }
    
    /// filter over seconds. smooth off is linear. smooth on is cosine smoothness (default)
    public func filter(seconds: LiveFloat, smooth: Bool = true) -> LiveVec {
        return LiveVec(x: x.filter(seconds: seconds, smooth: smooth),
                       y: y.filter(seconds: seconds, smooth: smooth),
                       z: z.filter(seconds: seconds, smooth: smooth))
    }
    
    public func liveCircle(seconds: LiveFloat = 1.0, scale: LiveFloat = 1.0) -> LiveVec {
        return LiveVec(x: cos(.live * seconds) * scale,
                       y: sin(.live * seconds) * scale,
                       z: sin(.live * seconds) * scale)
    }
    
    /// noise is a combo of liveRandom and smooth filter
    ///
    /// deafults - liveRandom range: -0.5...0.5 - filter seconds: 1.0
    public static func noise(xRange: ClosedRange<CGFloat> = -0.5...0.5,
                             yRange: ClosedRange<CGFloat> = -0.5...0.5,
                             zRange: ClosedRange<CGFloat> = -0.5...0.5,
                             seconds: LiveFloat = 1.0) -> LiveVec {
        return LiveVec(x: LiveFloat.noise(range: xRange, seconds: seconds),
                       y: LiveFloat.noise(range: yRange, seconds: seconds),
                       z: LiveFloat.noise(range: zRange, seconds: seconds))
    }
    
    // MARK: Equatable
    
    
    public static func == (lhs: LiveVec, rhs: LiveVec) -> LiveBool {
        return LiveBool({ return CGFloat(lhs.x) == CGFloat(rhs.x) && CGFloat(lhs.y) == CGFloat(rhs.y) })
    }
    public static func != (lhs: LiveVec, rhs: LiveVec) -> LiveBool {
        return !(lhs == rhs)
    }
    
    // MARK: Operators
    
    public static func + (lhs: LiveVec, rhs: LiveVec) -> LiveVec {
        return LiveVec(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    public static func + (lhs: LiveVec, rhs: LiveFloat) -> LiveVec {
        return LiveVec(x: lhs.x + rhs, y: lhs.y + rhs, z: lhs.z + rhs)
    }
    public static func + (lhs: LiveFloat, rhs: LiveVec) -> LiveVec {
        return LiveVec(x: lhs + rhs.x, y: lhs + rhs.y, z: lhs + rhs.z)
    }
    public static func += (lhs: inout LiveVec, rhs: LiveVec) {
        let _lhs = lhs; lhs = LiveVec(x: _lhs.x + rhs.x, y: _lhs.y + rhs.y, z: _lhs.z + rhs.z)
    }
    public static func += (lhs: inout LiveVec, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LiveVec(x: _lhs.x + rhs, y: _lhs.y + rhs, z: _lhs.z + rhs)
    }
    
    public static func - (lhs: LiveVec, rhs: LiveVec) -> LiveVec {
        return LiveVec(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    public static func - (lhs: LiveVec, rhs: LiveFloat) -> LiveVec {
        return LiveVec(x: lhs.x - rhs, y: lhs.y - rhs, z: lhs.z - rhs)
    }
    public static func - (lhs: LiveFloat, rhs: LiveVec) -> LiveVec {
        return LiveVec(x: lhs - rhs.x, y: lhs - rhs.y, z: lhs - rhs.z)
    }
    public static func -= (lhs: inout LiveVec, rhs: LiveVec) {
        let _lhs = lhs; lhs = LiveVec(x: _lhs.x - rhs.x, y: _lhs.y - rhs.y, z: _lhs.z - rhs.z)
    }
    public static func -= (lhs: inout LiveVec, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LiveVec(x: _lhs.x - rhs, y: _lhs.y - rhs, z: _lhs.z - rhs)
    }
    
    public static func * (lhs: LiveVec, rhs: LiveVec) -> LiveVec {
        return LiveVec(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    public static func * (lhs: LiveVec, rhs: LiveFloat) -> LiveVec {
        return LiveVec(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    public static func * (lhs: LiveFloat, rhs: LiveVec) -> LiveVec {
        return LiveVec(x: lhs * rhs.x, y: lhs * rhs.y, z: lhs * rhs.z)
    }
    public static func *= (lhs: inout LiveVec, rhs: LiveVec) {
        let _lhs = lhs; lhs = LiveVec(x: _lhs.x * rhs.x, y: _lhs.y * rhs.y, z: _lhs.z * rhs.z)
    }
    public static func *= (lhs: inout LiveVec, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LiveVec(x: _lhs.x * rhs, y: _lhs.y * rhs, z: _lhs.z * rhs)
    }
    
    public static func / (lhs: LiveVec, rhs: LiveVec) -> LiveVec {
        return LiveVec(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    public static func / (lhs: LiveVec, rhs: LiveFloat) -> LiveVec {
        return LiveVec(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    public static func / (lhs: LiveFloat, rhs: LiveVec) -> LiveVec {
        return LiveVec(x: lhs / rhs.x, y: lhs / rhs.y, z: lhs / rhs.z)
    }
    public static func /= (lhs: inout LiveVec, rhs: LiveVec) {
        let _lhs = lhs; lhs = LiveVec(x: _lhs.x / rhs.x, y: _lhs.y / rhs.y, z: _lhs.z / rhs.z)
    }
    public static func /= (lhs: inout LiveVec, rhs: LiveFloat) {
        let _lhs = lhs; lhs = LiveVec(x: _lhs.x / rhs, y: _lhs.y / rhs, z: _lhs.z / rhs)
    }
    
    public prefix static func - (operand: LiveVec) -> LiveVec {
        return LiveVec(x: -operand.x, y: -operand.y, z: -operand.z)
    }
    
    
    public func flipX() -> LiveVec {
        return LiveVec(x: -x, y: y, z: z)
    }
    public func flipY() -> LiveVec {
        return LiveVec(x: x, y: -y, z: z)
    }
    public func flipZ() -> LiveVec {
        return LiveVec(x: x, y: y, z: -z)
    }
    public func flipXY() -> LiveVec {
        return LiveVec(x: -x, y: -y, z: z)
    }
    public func flipXZ() -> LiveVec {
        return LiveVec(x: -x, y: y, z: -z)
    }
    public func flipYZ() -> LiveVec {
        return LiveVec(x: x, y: -y, z: -z)
    }
    public func flipXYZ() -> LiveVec {
        return LiveVec(x: -x, y: -y, z: -z)
    }
    
    public func rotate(by ang: LiveFloat, over axis: Axis, at origin: LiveVec = .zero) -> LiveVec {
        switch axis {
        case .x:
            let ty = (y - origin.y)
            let tz = (z - origin.z)
            var rot = atan2(ty, tz)
            rot += ang
            let rad = sqrt(pow(ty, 2) + pow(tz, 2))
            let y = origin.y + cos(rot) * rad
            let z = origin.z + sin(rot) * rad
            return LiveVec(x: self.x, y: y, z: z)
        case .y:
            let tx = (x - origin.x)
            let tz = (z - origin.z)
            var rot = atan2(tx, tz)
            rot += ang
            let rad = sqrt(pow(tx, 2) + pow(tz, 2))
            let x = origin.x + cos(rot) * rad
            let z = origin.z + sin(rot) * rad
            return LiveVec(x: x, y: self.y, z: z)
        case .z:
            let tx = (x - origin.x)
            let ty = (y - origin.y)
            var rot = atan2(ty, tx)
            rot += ang
            let rad = sqrt(pow(tx, 2) + pow(ty, 2))
            let x = origin.x + cos(rot) * rad
            let y = origin.y + sin(rot) * rad
            return LiveVec(x: x, y: y, z: self.z)
        }
    }
    
    
//    public mutating func zRotate(by ang: CGFloat, at origin: LiveVec = .zero) {
//        let tx = (x - origin.x)
//        let ty = (y - origin.y)
//        var rot = atan2(ty, tx)
//        rot += ang
//        let rad = sqrt(pow(tx, 2) + pow(ty, 2))
//        x = origin.x + cos(rot) * rad
//        y = origin.y + sin(rot) * rad
//    }
//    public mutating func scale(by s: CGFloat, at origin: LiveVec = .zero) {
//        scale(by: LiveVec(xyz: s), at: origin)
//    }
//    public mutating func scale(by s: LiveVec, at origin: LiveVec = .zero) {
//        let vec = self - origin
//        self = origin + vec * s
//    }
    
}
