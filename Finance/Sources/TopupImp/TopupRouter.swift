//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/4/23.
//

import ModernRIBs
import AddPaymentMethod
import SuperUI
import RIBsUtil
import FinanceEntity
import Topup

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

/// ViewableRouter가 아닌 Router로 되어있음 -> 뷰가 없다는 뜻이며, 뷰 없는 리블렛을 붙일 경우에는 viewcontrollable에 present 할 필요 없고 attach만 해주면 됨
final class TopupRouter: Router<TopupInteractable>, TopupRouting {
    
    private var navigationControllerable: NavigationControllerable?
    
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let enterAmountBuildable: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    private let cardOnFileBuildable: CardOnFileBuildable
    private var cardOnFileRouing: Routing?
    
    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        enterAmountBuildable: EnterAmountBuildable,
        cardOnFileBuildable: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        self.cardOnFileBuildable = cardOnFileBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllerable != nil {
            navigationControllerable?.dismiss(completion: nil)
        }
    }
    
    func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)
        
        if let navigationControllerable {
            navigationControllerable.pushViewController(router.viewControllable, animated: true)
        } else {
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        self.addPaymentMethodRouting = router
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        navigationControllerable?.popViewController(animated: true)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllerable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if navigationControllerable == nil {
            return
        }
        
        viewController.dismiss(completion: nil)
        self.navigationControllerable = nil
    }
    
    func attachEnterAmount() {
        if enterAmountRouting != nil {
            return
        }
        
        let router = enterAmountBuildable.build(withListener: interactor)
        
        if let navigation = navigationControllerable {
            // 1. 처음부터 카드가 있는 경우 모달로 띄움
            navigation.setViewControllers([router.viewControllable])
            resetChildRouting()
        } else {
            // 2. 카드 추가 화면에서 온 경우에는 푸시로 이동
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        self.enterAmountRouting = router
    }
    
    func detachEnterAmount() {
        guard let router = enterAmountRouting else {
            return
        }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        self.enterAmountRouting = nil
    }
    
    func attachCardOnFile(paymentMethods: [PaymentMethod]) {
        if cardOnFileRouing != nil {
            return
        }
        
        // paymentMethods를 전달하기 위해서는 Build 메소드를 통해 전달하면 됨
        let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
        navigationControllerable?.pushViewController(router.viewControllable, animated: true)
        cardOnFileRouing = router
        attachChild(router)
    }
    
    func detachCardOnFile() {
        guard let router = cardOnFileRouing else {
            return
        }
        
        navigationControllerable?.popViewController(animated: true)
        detachChild(router)
        cardOnFileRouing = nil
    }
    
    func popToRoot() {
        navigationControllerable?.popToRoot(animated: true)
        resetChildRouting()
    }
    
    private func resetChildRouting() {
        // 이미 있었던 View를 날렸기 때문에 router도 같이 삭제를 해줘야 함.
        // Enter Amount가 푸시가 될 때 다시 Enter Amount 밖에 없는 깔끔한 상태로 시작을 하기 때문에,
        // 다른 child들을 다 detach해주고 초기화 하는 작업
        
        if let cardOnFileRouing {
            detachChild(cardOnFileRouing)
            self.cardOnFileRouing = nil
        }
        
        if let addPaymentMethodRouting {
            detachChild(addPaymentMethodRouting)
            self.addPaymentMethodRouting = nil
        }
    }

    // MARK: - Private

    private let viewController: ViewControllable
}
