// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

extension String{
    
    public func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
