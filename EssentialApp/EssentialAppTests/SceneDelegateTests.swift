//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Donatas Žitkus on 05/07/2025.
//

import XCTest
import EssentialFeed2iOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = try! makeUIWindow()
        let sut = SceneDelegate()
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertTrue(window.isKeyWindow, "Expected window to be the key window")
        XCTAssertFalse(window.isHidden, "Expected window to be visible")
    }
    
    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = try! makeUIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedViewController, "Expected a feed controller as top view controller, got \(String(describing: topController)) instead")
    }
    
    // MARK: - Helpers
    private func makeUIWindow() throws -> UIWindow {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            throw NSError(domain: "WindowSceneError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No connected UIWindowScene available"])
        }
        return UIWindow(windowScene: scene)
    }
    
}
