//
//  apiRequest.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation
import SwiftyJSON
struct APIClient {
    
    static func fetchUserInfo(_ completion: @escaping (FetchUserInfoResponse?) -> Void) {
        let decoder = JSONDecoder()
        let components = URLComponents(string: APIURL.baseUrl + "/me")
        guard let url = components?.url else {
            return
        }
        
        var request = URLRequest(url: (components?.url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(("Bearer " + AccessTokenDao().getAccessToken()!) , forHTTPHeaderField: "Authorization")
        print(AccessTokenDao().getAccessToken() ?? "")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            if (error == nil) {
                
                do {
                    print(String(data: data!, encoding: .utf8))
                    let res = try decoder.decode(FetchUserInfoResponse.self, from: data!)
                    UserInfoDao().setUserInfo(user: res)
                    completion(res)
                } catch {
                    completion(nil)
                }
            } else {
                print("error")
            }
        })
        task.resume()
    }
    
    static func singIn(userInfo: AuthRequest, _ completion: @escaping (LoginResponse?) -> Void) {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        var request = URLRequest(url: URL(string:APIURL.baseUrl + "/signin")!)
        

        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        // set the header(s)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(AccessTokenDao().getAccessToken() ?? "", forHTTPHeaderField: "Authorization: Bearer")

        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: JSONSerialization.jsonObject(with: encoder.encode(userInfo)), options: [])
        }catch{
            print(error.localizedDescription)
        }
        // use NSURLSessionDataTask
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            if (error == nil) {
                do {
                    let res = try decoder.decode(LoginResponse.self, from: data!)
                    AccessTokenDao().setAccessToken(accessToken: res.access_token)
                    completion(res)
                } catch {
                    completion(nil)
                }
            } else {
                print("error")
            }
        })
        task.resume()
    }
    
    static func singUp(userInfo: AuthRequest, _ completion: @escaping ([PlaygroundStr]) -> Void) {
        let components = URLComponents(string: APIURL.baseUrl + "/signup")
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

enum APIURL {
    static let baseUrl = "https://qolab-api.herokuapp.com"
}
