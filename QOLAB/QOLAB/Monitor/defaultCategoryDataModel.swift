//
//  defaultCategoryDataModel.swift
//  QOLAB
//
//  Created by Oshima Masachika on 2019/11/07.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

struct Category: Codable {
    let app: [String: [String]]
    let domain: [String: [String]]
}

enum CategoryName: String {
    case survey
    case implementation
    case writing
    case breakTime = "break"
}
