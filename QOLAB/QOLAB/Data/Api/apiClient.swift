//
//  apiClient.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case networkError(Int)
    case parseError
    case serverError(Int)
    case otherError(String)
}

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
