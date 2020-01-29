//
//  Live.swift
//  Live
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

//infix operator ++
infix operator --
infix operator **
//infix operator !**
//infix operator !&
infix operator <>
infix operator ><
//infix operator ~
//infix operator °
//infix operator <->
//infix operator >-<
//infix operator +-+
//prefix operator °

public class LiveValues {
    
    public static let main = LiveValues()
    
    // MARK: - Version
    
    public var version: (app: String, build: String)? {
        guard let infos = Bundle(for: LiveValues.self).infoDictionary else { return nil }
        guard let appVersion: String = infos["CFBundleShortVersionString"] as? String else { return nil }
        guard let buildVersion: String = infos["CFBundleVersion"] as? String else { return nil }
        return (app: appVersion, build: buildVersion)
    }
    
    // MARK:  Frame Loop
    
    #if os(macOS)
    typealias _DisplayLink = CVDisplayLink
    #else
    typealias _DisplayLink = CADisplayLink
    #endif
    var displayLink: _DisplayLink?
    
    public var frame = 0
    let startDate = Date()
    var frameDate = Date()
    var finalFrameDate: Date?
    public var seconds: CGFloat {
        return CGFloat(-startDate.timeIntervalSinceNow)
    }
    
    var frameCallbacks: [(id: UUID, callback: () -> ())] = []
    
    var _fps: Int = -1
    public var fps: Int { return min(_fps, fpsMax) }
    public var fpsMax: Int { if #available(iOS 10.3, *) {
        #if os(macOS)
        return 60
        #else
        return UIScreen.main.maximumFramesPerSecond
        #endif
    } else { return -1 } }
    
    // MARK: Color
    
    public var bits: LiveColor.Bits = ._8
    public var colorSpace: LiveColor.Space = .sRGB
    
    // MARK: - Life Cycle
    
    init() {
        
        #if os(macOS)
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        let displayLinkOutputCallback: CVDisplayLinkOutputCallback = { (displayLink: CVDisplayLink,
                                                                        inNow: UnsafePointer<CVTimeStamp>,
                                                                        inOutputTime: UnsafePointer<CVTimeStamp>,
                                                                        flagsIn: CVOptionFlags,
                                                                        flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                                                                        displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn in
            LiveValues.main.frameLoop()
            return kCVReturnSuccess
        }
        CVDisplayLinkSetOutputCallback(displayLink!, displayLinkOutputCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        CVDisplayLinkStart(displayLink!)
        #else
        displayLink = CADisplayLink(target: self, selector: #selector(frameLoop))
        displayLink!.add(to: RunLoop.main, forMode: .common)
        #endif
        
    }
    
    // MARK: - Frame Loop
    
    @objc func frameLoop() {
        let frameTime = -frameDate.timeIntervalSinceNow
        _fps = Int(round(1.0 / frameTime))
        frameDate = Date()
        frame += 1
        for frameCallback in self.frameCallbacks {
            frameCallback.callback()
        }
    }
    
    // MARK: - Listen
    
    public enum ListenState {
        case `continue`
        case done
    }
    
    public func listenToFramesUntil(callback: @escaping () -> (ListenState)) {
        let id = UUID()
        frameCallbacks.append((id: id, callback: {
            if callback() == .done {
                self.unlistenToFrames(for: id)
            }
        }))
    }
    
    public func listenToFrames(id: UUID, callback: @escaping () -> ()) {
        frameCallbacks.append((id: id, callback: {
            callback()
        }))
    }
    
    public func listenToFrames(callback: @escaping () -> ()) {
        frameCallbacks.append((id: UUID(), callback: {
            callback()
        }))
    }
    
    public func unlistenToFrames(for id: UUID) {
        for (i, frameCallback) in self.frameCallbacks.enumerated() {
            if frameCallback.id == id {
                frameCallbacks.remove(at: i)
                break
            }
        }
    }
    
}
