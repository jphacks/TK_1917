//
//  UserActivityRequest.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/27.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

struct UserActivityRequest: Codable {
    var activityName: String
    var data: ActivityData
}

struct ActivityData: Codable {
    var appName: String
    var typeCount: Int
}
