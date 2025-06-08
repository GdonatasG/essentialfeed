//
//  FeedViewControllerTests.swift
//  EssentialFeed2iOSTests
//
//  Created by Donatas Zitkus on 08/06/2025.
//

import XCTest
import UIKit
import EssentialFeed2

final class FeedViewController: UITableViewController {
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    private var loader: FeedLoader?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        
        let control = UIRefreshControl()
        refreshControl = control
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        loadingIndicator.startAnimating()
        load { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc private func refresh(){
        refreshControl?.beginRefreshing()
        load { [weak self] in
            guard let self = self else { return }
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func load(completion: @escaping () -> Void) {
        loader?.load { [weak self] result in
            guard let _ = self else { return }
            completion()
        }
    }
}

final class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_pullToRefresh_loadsFeed() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
            
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.loadingIndicator.isAnimating, true)
    }
    
    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading()
        
        XCTAssertEqual(sut.loadingIndicator.isAnimating, false)
    }
    
    func test_viewDidLoad_doesNotShowPullToRefreshIndicator() {
        let (sut, _) = makeSUT()
            
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeak(loader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading() {
            completions[0](.success([]))
        }
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
