//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/2/23.
//

import ModernRIBs
import Combine
import Foundation

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    
    func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

/// 디펜던시를 프로토콜로 묶어서 관리하게 되면 고쳐야 할 부분이 줄어들게 됨
protocol SuperPayDashboardInteractorDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {
    
    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?
    
    private let dependency: SuperPayDashboardInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: SuperPayDashboardPresentable,
        dependency: SuperPayDashboardInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.balance.sink { [weak self] balance in
            // Interactor에서 UI를 업데이트 할 때는 Presenter를 호출함.
            // Presenter: Presentable Protocol인데, Superpay 뷰 컨트롤러에서 이 값을 컴포넌트 하고 있음.
            self?.dependency.balanceFormatter.string(from: NSNumber(value: balance)).map({
                self?.presenter.updateBalance($0)
            })
        }.store(in: &cancellables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
