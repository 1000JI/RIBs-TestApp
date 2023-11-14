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

public final class SuperPayRepositoryMock: SuperPayRepository {
    
    /// balance를 실제 우리가 업데이트 할 수 있는 Subject
    public var balanceSubject = CurrentValuePublisher<Double>(0)
    public var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    
    public var topupCallCount = 0
    public var topupAmount: Double?
    public var paymentMethodID: String?
    public var shouldTopupSucceed: Bool = true
    public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        topupCallCount += 1
        topupAmount = amount
        self.paymentMethodID = paymentMethodID
        
        if shouldTopupSucceed {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "SuperPayRepositoryMock", code: 0)).eraseToAnyPublisher()
        }
    }
    
    public init() { }
    
}
