//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/4/23.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    
    func attachAddPaymentMethod(closeButtonType: DismissButtonType)
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmount()
    func attachCardOnFile(paymentMethods: [PaymentMethod])
    func detachCardOnFile()
    func popToRoot()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private var isEnterAmountRoot: Bool = false
    
    private var paymentMethods: [PaymentMethod] {
        dependency.cardOnFileRepository.cardOnFile.value
    }

    private let dependency: TopupInteractorDependency
    
    init(dependency: TopupInteractorDependency) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
            isEnterAmountRoot = true
            
            // 이렇게 스트림으로 흘려보낸 PaymentMethod는 EnterAmount에서 읽어 화면에 표시
            dependency.paymentMethodStream.send(card)
            
            // 금액 입력 화면
            router?.attachEnterAmount()
        } else {
            isEnterAmountRoot = false
            
            // 카드 추가 화면
            router?.attachAddPaymentMethod(closeButtonType: .close)
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        if !isEnterAmountRoot {
            listener?.topupDidClose()
        }
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        dependency.paymentMethodStream.send(paymentMethod)
        
        if isEnterAmountRoot {
            router?.popToRoot()
        } else {
            isEnterAmountRoot = true
            router?.attachEnterAmount()
        }
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethods: paymentMethods)
    }
    
    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        // attach add card
        router?.attachAddPaymentMethod(closeButtonType: .back)
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(selected)
        }
        router?.detachCardOnFile()
    }
}
