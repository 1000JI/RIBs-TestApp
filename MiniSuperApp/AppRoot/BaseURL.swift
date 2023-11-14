//
//  BaseURL.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/13/23.
//

import Foundation

struct BaseURL {
    var financeBaseURL: URL {
        #if UITESTING
        return URL(string: "http://localhost:8080")!
        #else
        return URL(string: "http://finance.superapp.com/api/v1")!
        #endif
    }
}
