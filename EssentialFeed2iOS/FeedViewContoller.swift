//
//  FeedViewContoller.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Zitkus on 08/06/2025.
//

import Foundation
import EssentialFeed2
import UIKit

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL)
    func cancelImageDataLoad(from url: URL)
}

public final class FeedViewController: UITableViewController {
    public let mainLoadingIndicator = UIActivityIndicatorView(style: .large)
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedImage]()

    
    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLoadingIndicator.center = view.center
        view.addSubview(mainLoadingIndicator)
        
        let control = UIRefreshControl()
        refreshControl = control
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl!.frame.size.height), animated: false)
        
        mainLoadingIndicator.startAnimating()
        load { [weak self] in
            self?.mainLoadingIndicator.stopAnimating()
        }
    }
    
    @objc private func refresh(){
        refreshControl?.beginRefreshing()
        load { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func load(completion: @escaping () -> Void) {
        feedLoader?.load { [weak self] result in
            guard let self = self else { return }
            if let feed = try? result.get() {
                self.tableModel = feed
                self.tableView.reloadData()
            }
            completion()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        imageLoader?.loadImageData(from: cellModel.url)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellModel = tableModel[indexPath.row]
        imageLoader?.cancelImageDataLoad(from: cellModel.url)
    }
}
