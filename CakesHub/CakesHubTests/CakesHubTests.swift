//
//
//  CakesHubTests.swift
//  CakesHubTests
//
//  Created by Milana Shakhbieva on 19.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import XCTest
@testable import CakesHub

class CakesHubTests: XCTestCase {
    
    var sut: AuthViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AuthViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testEmailValidatorTest1() throws {
        XCTAssert(sut.isValidEmail("mashakhbieva@google.co.uk") == true)
    }
    
    func testEmailValidatorTest2() throws {
        XCTAssertTrue(sut.isValidEmail("example@address.com") == true)
    }
    
    func testEmailValidatorTest3() throws {
        XCTAssertFalse(sut.isValidEmail("") == true)
    }
    
    func testEmailValidatorTest4() throws {
        XCTAssertEqual(sut.isValidEmail("invalid@address."), false)
    }
    
    func testEmailValidatorTest5() throws {
        XCTAssertNotEqual(sut.isValidEmail("😤"), true)
    }
    
    func testPerformanceExample() throws {
        self.measure {
            let someArray = Array(0...10000)
            var counter = 0
            
            someArray.forEach {
                counter += $0
            }
        }
    }
}
