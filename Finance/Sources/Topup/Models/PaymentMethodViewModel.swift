//
//  File.swift
//  
//
//  Created by 천지운 on 11/8/23.
//

import UIKit
import FinanceEntity

struct PaymentMethodViewModel {
    let name: String
    let digits: String
    let color: UIColor
    
    init(_ paymentMethod: PaymentMethod) {
        name = paymentMethod.name
        digits = "**** \(paymentMethod.digits)"
        color = UIColor(hex: paymentMethod.color) ?? .systemGray4
    }
}
