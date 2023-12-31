//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import Foundation
import Combine
import FinanceEntity

/// 서버 API를 호출해서 그 유저에게 등록된 카드 목록을 가져오는 역할
public protocol CardOnFileRepository {
    /// 카드 목록을 데이터 스트림으로 가지고 있고 카드 목록이 필요한 곳에 Subscribe를 할 수 있도록
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
}

public final class CardOnFileRepositoryImp: CardOnFileRepository {
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
    
    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentMethod(id: "0", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
        PaymentMethod(id: "0", name: "현대카드", digits: "8121", color: "#78c5f5ff", isPrimary: false),
//        PaymentMethod(id: "0", name: "국민은행", digits: "2812", color: "#65c466ff", isPrimary: false),
//        PaymentMethod(id: "0", name: "카카오뱅크", digits: "8751", color: "#ffcc00ff", isPrimary: false),
    ])
    
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
        let paymentMethod = PaymentMethod(
            id: "00",
            name: "New 카드",
            digits: "\(info.number.suffix(4))",
            color: "",
            isPrimary: false
        )
        var new = paymentMethodsSubject.value
        new.append(paymentMethod)
        paymentMethodsSubject.send(new)
        
        return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
}
