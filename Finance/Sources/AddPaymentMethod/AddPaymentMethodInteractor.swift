//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import ModernRIBs
import Combine
import FinanceEntity
import FinanceRepository

protocol AddPaymentMethodRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodPresentable: Presentable {
    var listener: AddPaymentMethodPresentableListener? { get set }
}

public protocol AddPaymentMethodListener: AnyObject {
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}

protocol AddPaymentMethodInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>, AddPaymentMethodInteractable, AddPaymentMethodPresentableListener {

    weak var router: AddPaymentMethodRouting?
    weak var listener: AddPaymentMethodListener?

    private let dependency: AddPaymentMethodInteractorDependency
    
    private var cancellabels: Set<AnyCancellable>
    
    init(
        presenter: AddPaymentMethodPresentable,
        dependency: AddPaymentMethodInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellabels = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.addPaymentMethodDidTapClose()
    }
    
    func didTapConfirm(with number: String, cvc: String, expiry: String) {
        dependency.cardOnFileRepository.addCard(
            info: AddPaymentMethodInfo(
                number: number,
                cvc: cvc,
                expiration: expiry
            )
        ).sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] method in
                // 콜이 성공하면 addPaymentMethod 할일을 완료한 것이며, 리스너인 부모리블렛에게 결과를 알려주면 됨
                self?.listener?.addPaymentMethodDidAddCard(paymentMethod: method)
            }
        ).store(in: &cancellabels)
    }
}
