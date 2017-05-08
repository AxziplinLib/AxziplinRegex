//
//  Status.swift
//  Regex
//
//  Created by devedbox on 2017/5/7.
//  Copyright © 2017年 AxziplinLib. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

// MARK: CharacterConvertible.

/// Types conform to this protocol can generate a instance of `Character`, or throws an error of `RegexError` if cannot.
public protocol CharacterConvertible {
    /// Creates or transition to a instance of `Character`.
    ///
    /// - Throws: An error of `RegexError` if failed.
    /// - Returns: An instance of `Character`.
    func asCharacter() throws -> Character
}

extension CharacterConvertible {
    /// Get character object by variable.
    var character: Character? { return try? asCharacter() }
}

extension Character: CharacterConvertible {
    public func asCharacter() throws -> Character { return self }
}

extension String: CharacterConvertible {
    public func asCharacter() throws -> Character {
        guard characters.count > 0 else { throw RegexError.convertFailed(.outOfBounds) }
        return characters[characters.startIndex]
    }
}

public protocol StateReadable {
    var status: State.Status { get }
    func result(of character: CharacterConvertible?) throws -> State.Result
}

public protocol StateChainable {
    mutating func link(to character: CharacterConvertible?) -> State
}

extension State {
    public enum Result {
        case matched, missed
        
        var matched: Bool { return self == .matched }
    }
}

extension State {
    public enum Status {
        case initial, intermediate, final
    }
}

public struct State {
    fileprivate var _next: Any?
    public var character: CharacterConvertible?
    public var states: [(CharacterConvertible&StateReadable)?] = []
    
    public init(_ character: CharacterConvertible? = nil, next: State? = nil) {
        self.character = character
        _next = next
    }
}

extension State {
    /// The next state object, may be nil.
    public var next: State? { return _next as? State }
    /// Creates a state object which is status of initial.
    public static var initial: State { return State() }
}

extension State: StateReadable {
    public var status: State.Status {
        return .intermediate
    }
    
    public func result(of character: CharacterConvertible?) throws -> State.Result {
        guard let lhs = self.character?.character, let rhs = character?.character else { return .missed }
        guard lhs == rhs else { return .missed }
        return .matched
    }
}

extension State: StateChainable {
    @discardableResult
    public mutating func link(to character: CharacterConvertible? = nil) -> State {
        _next = State()
        self.character = character
        return next!
    }
}
