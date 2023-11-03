//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
