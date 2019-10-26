//
//  AccessTokenDao.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation
import RxSwift
import JWTDecode

class AccessTokenDao {
    
    static let ACCESS_TOKEN = "accessToken"
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: AccessTokenDao.ACCESS_TOKEN)
    }

    func setAccessToken(accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: AccessTokenDao.ACCESS_TOKEN)
    }
    
    func isExpired(accessToken: String) -> Bool {
        guard let jwt = try? decode(jwt: accessToken), let expDate = jwt.body["exp_date"] as? String else {
            return true
        }
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd HH:mm:ss", options: 0, locale: Locale(identifier: "ja_JP"))
        if let dt = formatter.date(from: String(expDate[..<expDate.index(expDate.startIndex, offsetBy: 19)])) {
            return dt < Date()
        }
        return true
    }
    
//    func fetch(accessToken: String) -> Observable<String?> {
//        return Observable.create { observer in
//            guard let jwt = try? decode(jwt: accessToken),
//                let refreshToken = jwt.body["refresh_token"] as? String else {
//                    return Disposables.create()
//            }
//            ApiRequest.refreshAccessToken(refreshToken: refreshToken) { result in
//                switch result {
//                case .success(let v):
//                    if let value = v {
//                        observer.on(.next(value.accessToken))
//                        observer.on(.completed)
//                    }
//                case .failure(let e):
//                    print(e)
//                }
//            }
//            return Disposables.create()
//        }
//    }
}
