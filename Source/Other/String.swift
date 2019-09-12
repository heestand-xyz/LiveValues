//
//  Helpers.swift
//  Live
//
//  Created by Hexagons on 2018-11-26.
//  Open Source - MIT License
//

import Foundation

extension String {
    
    public subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    public subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public func zfill(_ length: Int) -> String {
        guard contains(".") else { return self }
        let diff = (length + 2) - count
        let postfix = diff > 0 ? String(repeating: "0", count: diff) : ""
        return self + postfix
    }
    
    public func zfillOrg(_ length: Int) -> String {
        let diff = (length - count)
        let prefix = (diff > 0 ? String(repeating: "0", count: diff) : "")
        return (prefix + self)
    }
    
}
