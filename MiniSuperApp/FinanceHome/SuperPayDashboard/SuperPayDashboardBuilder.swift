//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/2/23.
//

import ModernRIBs
import Foundation

protocol SuperPayDashboardDependency: Dependency {
    /// 부모로 부터 받을 의존성을 기입 하게 됨(슈퍼페이대시보드는 뷰의 역할이 좀 더크므로 부모로 부터 받는 것이 좋아보임)
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
    var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
    var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {

    override init(dependency: SuperPayDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
        let component = SuperPayDashboardComponent(dependency: dependency)
        let viewController = SuperPayDashboardViewController()
        let interactor = SuperPayDashboardInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
