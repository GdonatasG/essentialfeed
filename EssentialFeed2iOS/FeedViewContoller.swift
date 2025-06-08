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
            guard let _ = self else { return }
            completion()
        }
    }
}
