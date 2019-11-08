//
//  UserActivityResponse.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/27.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

struct UserActivityResponse: Codable {
    var activityName: String
    var data: ActivityData
    var category: String
}
