//
//  XCTestCaseMemoryLeakTracking.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Zitkus on 15/05/2025.
//

import XCTest

extension XCTestCase {
    public func trackForMemoryLeak(
        _ instace: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instace] in
            XCTAssertNil(instace, "Instance should have been deallocated. Potential memory leak!", file: file, line: line)
        }
    }
}
