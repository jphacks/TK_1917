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
    var category: String
}

struct ActivityData: Codable {
    var appName: String
    var typeCount: Int
}

struct UserSitRequest: Codable {
    var sittingTime: Int
}

struct SittingActivityData: Codable {
    var sittingStayTime: Int
}

struct UserNetworkRequest: Codable {
    var activityName: String
    var data: NetworkActivityData
}

struct NetworkActivityData: Codable {
    var ssid: String
    var stayTime: Int
}

struct ChromeTabRequest: Codable {
    var activityName: String
    var data: ChromeTabData
    var category: String
}

struct ChromeTabData: Codable {
    var status: String
    var url: String
}
