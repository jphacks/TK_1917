//
//  AuthRequest.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

struct AuthRequest: Encodable {
    var email: String
    var password: String
}
