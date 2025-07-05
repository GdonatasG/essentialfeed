//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Donatas Žitkus on 05/07/2025.
//

import XCTest
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                XCTFail("No connected UIWindowScene available")
                return
            }
        let window = UIWindow(windowScene: scene)
        let sut = SceneDelegate()
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertTrue(window.isKeyWindow, "Expected window to be the key window")
        XCTAssertFalse(window.isHidden, "Expected window to be visible")
    }
    
}
