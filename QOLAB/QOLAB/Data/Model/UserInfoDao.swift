//
//  UserInfoDao.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

class UserInfoDao {
    
    static let USER_INFO = "userInfo"
    
    func getUserInfo() -> FetchUserInfoResponse? {
        guard let data = UserDefaults.standard.data(forKey: UserInfoDao.USER_INFO) else {
            return nil
        }
        let user = try? JSONDecoder().decode(FetchUserInfoResponse.self, from: data)
        return user
    }

    func setUserInfo(user: FetchUserInfoResponse) {
        do {
            let data = try? JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: UserInfoDao.USER_INFO)
        }
    }
}
