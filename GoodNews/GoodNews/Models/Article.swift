//
//  Article.swift
//  GoodNews
//
//  Created by Mary Moreira on 04/08/2022.
//

import Foundation

struct ArticleList: Decodable {
    let articles: [Article]
}

extension ArticleList {
    static var all: Resource<ArticleList>? = {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=cebc5a0f8fa34a869086e5b3e37f3db5") else { return nil }
        return Resource(url: url)
    }()
    
    static var empty: ArticleList = {
        return ArticleList(articles: [Article(title: "", description: "")])
    }()
    
}


struct Article: Decodable {
    let title: String?
    let description: String?
}

