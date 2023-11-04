//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/4/23.
//

import ModernRIBs

/// Topup 리블렛이 동작하기 위해 필요한 것들을 선언해두는 곳
/// 부모 리블렛이 뷰 컨트롤러를 하나 지정해줘야 함
protocol TopupDependency: Dependency {
    /// Topup 리블렛이 소유하고 있는 뷰가 아니라 Topup 리블렛을 띄운 부모가 지정해준 뷰
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    fileprivate var topupBaseViewController: ViewControllable { return dependency.topupBaseViewController }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
    
    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: TopupListener) -> TopupRouting {
        let component = TopupComponent(dependency: dependency)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let addPaymenetMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        
        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethodBuildable: addPaymenetMethodBuilder
        )
    }
}
