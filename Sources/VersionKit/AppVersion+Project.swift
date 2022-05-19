//
//  File.swift
//  
//
//  Created by Adam Wienconek on 19/05/2022.
//

import Foundation

public extension AppVersion {
    
    struct Project: Codable, Hashable, Comparable, CustomStringConvertible {
        
        public let rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public var description: String {
            var components = rawValue.components(separatedBy: ".")
            if components.count == 3, components.last == "0" {
                components.removeLast()
            }
            return components.joined(separator: ".")
        }
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            guard lhs.rawValue.first?.isNumber == true else {
                return true
            }
            guard rhs.rawValue.first?.isNumber == true else {
                return false
            }
            return lhs.rawValue < rhs.rawValue
        }
    }
    
}

public extension AppVersion.Project {
    
    static let unknown: Self = .init("–")
    
}
