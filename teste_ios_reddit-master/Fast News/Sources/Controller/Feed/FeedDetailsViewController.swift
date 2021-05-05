//
//  FeedDetailsViewController.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit

class FeedDetailsViewController: UIViewController {

    //MARK: - Properties
  
    var hotNewsViewModel: HotNewsViewModel?
    var hotNews: [HotNews] = [HotNews]()
    
    var comments: [Comment] = [Comment]() {
        didSet {
            var viewModels: [TypeProtocol] = [TypeProtocol]()
            
            if let hotNews = hotNewsViewModel {
                viewModels.append(hotNews)
            }
            _ = comments.map { (comment) in
                viewModels.append(CommentViewModel(comment: comment))
            }
            self.mainView.setup(with: viewModels, and: self)
        }
    }
    
    var mainView: FeedDetailsView {
        guard let view = self.view as? FeedDetailsView else {
            fatalError("View is not of type FeedDetailsView!")
        }
        return view
    }
    
    @objc func share(){
        
        let urlLink = hotNewsViewModel?.url
        let message = "Hey, look at this news!"
        //Set the link to share.
        if let link = NSURL(string: urlLink!)
        {
         let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
         activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
  
    
    override func viewDidLoad() {
 
        let logoutBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
 
        HotNewsProvider.shared.hotNewsComments(id: hotNewsViewModel?.id ?? "") { (completion) in
            do {
                let comments = try completion()
                
                self.comments = comments
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension FeedDetailsViewController: FeedViewDelegate {
    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        guard self.mainView.viewModels[indexPath.row].type == .hotNews,
            let viewModel = self.mainView.viewModels[indexPath.row] as? HotNewsViewModel else {
                return
        }
        
        if let url = URL(string: viewModel.url) {
            UIApplication.shared.open(url)
        }
    }
}
