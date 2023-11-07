//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import Foundation

public struct AddPaymentMethodInfo {
    public let number: String
    public let cvc: String
    public let expiration: String
    
    public init(
        number: String,
        cvc: String,
        expiration: String
    ) {
        self.number = number
        self.cvc = cvc
        self.expiration = expiration
    }
}
