//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/5/23.
//

import Foundation

protocol SuperPayRepository {
    /// 현재 잔액을 스트림 관리
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    
}

final class SuperPayRepositoryImp: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    private let balanceSubject = CurrentValuePublisher<Double>(0)
}
