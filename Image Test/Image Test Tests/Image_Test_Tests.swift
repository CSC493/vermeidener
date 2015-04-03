//
//  Image_Test_Tests.swift
//  Image Test Tests
//
//  Created by Christopher Primerano on 2015-02-18.
//  Copyright (c) 2015 Christopher Primerano. All rights reserved.
//

import UIKit
import XCTest
import Image_Test

class Image_Test_Tests: XCTestCase {

    func testExample() {
        let v = Vector(member: 1, 1, 1)
		let v2 = Vector(member: 1, 1, 1)
		
		XCTAssertEqual(v, v2, "Two equal vectors")
		
    }
	
}
