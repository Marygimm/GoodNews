//
//  Webservice.swift
//  GoodNews
//
//  Created by Mary Moreira on 04/08/2022.
//

import Foundation

class Webservice {
    
    func getArticles(url: URL, completion: @escaping([Article]?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
       
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let articlesList = try? JSONDecoder().decode(ArticleList.self, from: data)
                
                if let list = articlesList {
                    completion(list.articles)
                }
            }
        }.resume()
    }
}
