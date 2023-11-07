//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/5/23.
//

import Foundation
import Combine
import CombineUtil

protocol SuperPayRepository {
    /// 현재 잔액을 스트림 관리
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

final class SuperPayRepositoryImp: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    private let balanceSubject = CurrentValuePublisher<Double>(0)
    
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            self?.bgQueue.async {
                Thread.sleep(forTimeInterval: 2)
                promise(.success(()))
                
                // 새로운 충전 금액 업데이트 로직
                let newBalance = (self?.balanceSubject.value).map { $0 + amount }
                newBalance.map { self?.balanceSubject.send($0) }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private let bgQueue = DispatchQueue(label: "topup.repository.queue")
}
