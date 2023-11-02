//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/2/23.
//

import ModernRIBs

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SuperPayDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

/// 디펜던시를 프로토콜로 묶어서 관리하게 되면 고쳐야 할 부분이 줄어들게 됨
protocol SuperPayDashboardInteractorDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {
    
    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?
    
    private let dependency: SuperPayDashboardInteractorDependency
    init(
        presenter: SuperPayDashboardPresentable,
        dependency: SuperPayDashboardInteractorDependency
    ) {
        self.dependency = dependency
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
}
