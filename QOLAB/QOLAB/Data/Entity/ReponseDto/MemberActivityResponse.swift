//
//  MemberActivityResponse.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/11/05.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

struct MemberActivity: Codable {
    var name: String
    var email: String
    var activity: String
    var labId: String
    var _id: String
    var createdAt: String
    var __v: Int
}
