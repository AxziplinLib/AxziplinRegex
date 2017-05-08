//
//  StateTests.swift
//  Regex
//
//  Created by devedbox on 2017/5/7.
//  Copyright © 2017年 AxziplinLib. All rights reserved.
//

import XCTest
import Regex

class StateTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStateResult() {
        let character: Character = "c"
        let state = State(character)
        let result = try? state.result(of: character)
        
        XCTAssert(result == .matched, "Result of State failed.")
    }
    
    func testStateChain() {
        var initial = State.initial
        var state0 = initial.link(to: "a")
        var state1 = state0.link(to: "b")
        var state2 = state1.link(to: "c")
        let final = state2.link()
    }
    
    func testStringConformCharacterConvertible() {
        let string = ""
        do {
            let _ = try string.asCharacter()
        } catch RegexError.convertFailed(let reason) {
            XCTAssert(reason == .outOfBounds, "Empty convert to one character failed.")
        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }
}
