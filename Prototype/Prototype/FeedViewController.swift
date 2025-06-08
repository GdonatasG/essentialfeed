//
//  FeedViewController.swift
//  Prototype
//
//  Created by Donatas Zitkus on 05/06/2025.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}

final class FeedViewController: UITableViewController {
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private var feed = [FeedImageViewModel]()
    
    override func viewDidLoad() {
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl!.frame.size.height), animated: false)
        
        loadingIndicator.startAnimating()
        load(completion: { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        })
    }
    
    @IBAction func refresh() {
        refreshControl?.beginRefreshing()
        load(completion: {
            self.refreshControl?.endRefreshing()
        })
    }
    
    private func load(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if (self.feed.isEmpty) {
                self.feed = FeedImageViewModel.prototypeFeed
                self.tableView.reloadData()
            }
            completion()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
        let model = feed[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension FeedImageCell {
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil
        
        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil
        
        fadeIn(UIImage(named: model.imageName))
    }
}
