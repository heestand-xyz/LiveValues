//
//  LiveValue.swift
//  Live
//
//  Created by Anton Heestand on 2018-11-26.
//  Open Source - MIT License
//

import Foundation

public protocol LiveValue {
    
    var name: String? { get }
    var description: String { get }

    var uniformIsNew: Bool { get }
    
}
