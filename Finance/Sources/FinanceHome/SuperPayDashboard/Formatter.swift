//
//  NumberFormatter.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
