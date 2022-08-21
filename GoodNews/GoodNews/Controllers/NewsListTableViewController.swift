//
//  NewsListTableViewController.swift
//  GoodNews
//
//  Created by Mary Moreira on 04/08/2022.
//

import Foundation
import UIKit

class NewsListTableViewController: UITableViewController {
    
    private var articleListViewModel: ArticleListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=cebc5a0f8fa34a869086e5b3e37f3db5") else { return }
        Webservice().getArticles(url: url) { articles in
            guard let articles = articles else { return }
            self.articleListViewModel = ArticleListViewModel(articles: articles)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let articleListViewModel = articleListViewModel else {
            return 0
        }

        return articleListViewModel.numberOfSection
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articleListViewModel = articleListViewModel else {
            return 0
        }
        
        return articleListViewModel.numberOfRowsInSection(section)

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else { fatalError("ArticleTableViewCell not found ")}
        let articleViewModel = self.articleListViewModel?.articleAtIndex(indexPath.row)
        cell.titleLabel.text = articleViewModel?.title
        cell.descriptionLabel.text = articleViewModel?.description
        return cell
    }
    
}
