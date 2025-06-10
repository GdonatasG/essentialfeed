//
//  FeedViewContoller.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Zitkus on 08/06/2025.
//

import Foundation
import EssentialFeed2
import UIKit

public final class FeedViewController: UITableViewController {
    public let mainLoadingIndicator = UIActivityIndicatorView(style: .large)
    private var loader: FeedLoader?
    private var tableModel = [FeedImage]()

    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
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
        loader?.load { [weak self] result in
            guard let self = self else { return }
            self.tableModel = (try? result.get()) ?? []
            self.tableView.reloadData()
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
        return cell
    }
}
