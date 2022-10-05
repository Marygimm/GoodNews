//
//  NewsListTableViewController.swift
//  GoodNews
//
//  Created by Mary Moreira on 04/08/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewsListTableViewController: UITableViewController {
    
    private var articleListViewModel: ArticleListViewModel?
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateNews()
    }
    
    //normal call without rxSwift just replace on viewDidLoad the call
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
    // call with rxSwift 
    private func populateNews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=cebc5a0f8fa34a869086e5b3e37f3db5") else { return }
        
        Observable.just(url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> [Article]? in
                return try? JSONDecoder().decode(ArticleList.self, from: data).articles
            }.subscribe(onNext: { [weak self] articles in
                if let articles = articles {
                    DispatchQueue.main.async {
                        self?.articleListViewModel = ArticleListViewModel(articles: articles)
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
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
