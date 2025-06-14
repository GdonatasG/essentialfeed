//
//  FeedViewContoller.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Zitkus on 08/06/2025.
//

import Foundation
import EssentialFeed2
import UIKit

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var loadController: FeedLoadViewController?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedImage]() {
        didSet { tableView.reloadData() }
    }
    private var cellControllers = [IndexPath: FeedImageCellController]()
    
    public var mainLoadingIndicator: UIActivityIndicatorView? {
        return loadController?.mainLoadingIndicator
    }
    
    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.loadController = FeedLoadViewController(feedLoader: feedLoader)
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadController?.mainLoadingIndicator.center = view.center
        if let indicator = loadController?.mainLoadingIndicator {
            view.addSubview(indicator)
        }
        refreshControl = loadController?.refreshControl
        loadController?.onFeedLoaded = { [weak self] feed in
            self?.tableModel = feed
        }
        tableView.prefetchDataSource = self
        loadController?.load()
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellController)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = FeedImageCellController(model: cellModel, imageLoader: imageLoader!)
        cellControllers[indexPath] = cellController
        return cellController
    }
    
    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
}
