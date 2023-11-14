//
//  File.swift
//  
//
//  Created by 천지운 on 11/14/23.
//

import Foundation
import FinanceRepository
import CombineUtil
import Combine
import FinanceEntity

public final class CardOnFileRepositoryMock: CardOnFileRepository {
    
    public var cardOnFileSuject: CurrentValuePublisher<[PaymentMethod]> = .init([])
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { cardOnFileSuject }
    
    public var addCardCallCount = 0
    public var addCardInfo: AddPaymentMethodInfo?
    public var addedPaymentMethod: PaymentMethod?
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
        addCardCallCount += 1
        addCardInfo = info
        
        if let addedPaymentMethod = addedPaymentMethod {
            return Just(addedPaymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "CardOnFileRepositoryMock", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
    }
    
    public var fetchCallCount = 0
    public func fetch() {
        fetchCallCount += 1
    }
    
    public init() { }
    
}
