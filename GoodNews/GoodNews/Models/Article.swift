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


struct Article: Decodable {
    let title: String?
    let description: String?
}

