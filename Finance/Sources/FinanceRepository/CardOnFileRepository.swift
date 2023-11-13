//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil
import Network

/// 서버 API를 호출해서 그 유저에게 등록된 카드 목록을 가져오는 역할
public protocol CardOnFileRepository {
    /// 카드 목록을 데이터 스트림으로 가지고 있고 카드 목록이 필요한 곳에 Subscribe를 할 수 있도록
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
    func fetch()
}

public final class CardOnFileRepositoryImp: CardOnFileRepository {
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
    
    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([])
    
    private let network: Network
    private let baseURL: URL
    private var cancellables: Set<AnyCancellable>
    
    public init(
        network: Network,
        baseURL: URL
    ) {
        self.network = network
        self.baseURL = baseURL
        self.cancellables = .init()
    }
    
    public func fetch() {
        let request = CardOnFileRequest(baseURL: baseURL)
        network.send(request).map(\.output.cards)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] cards in
                    self?.paymentMethodsSubject.send(cards)
                }
            )
            .store(in: &cancellables)
    }
    
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
        let request = AddCardRequest(baseURL: baseURL, info: info)
        
        return network.send(request)
            .map(\.output.card)
            .handleEvents(
                receiveOutput: { [weak self] method in
                    guard let this = self else { return }
                    this.paymentMethodsSubject.send(this.paymentMethodsSubject.value + [method])
                }
            )
            .eraseToAnyPublisher()
    }
    
}
