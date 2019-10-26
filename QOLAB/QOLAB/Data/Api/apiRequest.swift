//
//  apiRequest.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

struct APIClient {

    static func fetchArticle(_ completion: @escaping ([PlaygroundStr]) -> Void) {
        let components = URLComponents(string: "http://localhost:3000/playground")
        guard let url = components?.url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decorder = JSONDecoder()
                do {
                    let articles = try decorder.decode([PlaygroundStr].self, from: data)
                    completion(articles)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print(error ?? "Error")
            }
        }
        task.resume()
    }
}
