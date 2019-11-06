//
//  defaultCategoryDataModel.swift
//  QOLAB
//
//  Created by Oshima Masachika on 2019/11/07.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

// struct CategoryObject: Codable {
//    let survey: [String]
//    let implementation: [String]
//    let breakTime: [String]
//    let writing: [String]
// }
//
// struct Category: Codable {
//    let app: CategoryObject
//    let domain: CategoryObject
// }
// struct CategoryObject: Codable {
//    let survey: [String]
//    let implementation: [String]
//    let breakTime: [String]
//    let writing: [String]
// }

struct Category: Codable {
    let app: [String: [String]]
    let domain: [String: [String]]
}
