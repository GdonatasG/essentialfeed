//
//  FeedViewContoller.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Zitkus on 08/06/2025.
//

import Foundation
import UIKit

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var loadController: FeedLoadViewController?
    var tableModel = [FeedImageCellController]() {
        didSet { tableView.reloadData() }
    }
    
    public var mainLoadingIndicator: UIActivityIndicatorView? {
        return loadController?.mainLoadingIndicator
    }
    
    convenience init(loadController: FeedLoadViewController) {
        self.init()
        self.loadController = loadController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadController?.mainLoadingIndicator.center = view.center
        if let indicator = loadController?.mainLoadingIndicator {
            view.addSubview(indicator)
        }
        refreshControl = loadController?.refreshControl
        tableView.prefetchDataSource = self
        loadController?.loadFeed()
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}
