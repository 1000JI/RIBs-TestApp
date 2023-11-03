//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    /// 부모 리블렛의 Interactor
    weak var listener: CardOnFileDashboardListener?

    private let dependency: CardOnFileDashboardInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: CardOnFileDashboardPresentable,
        dependency: CardOnFileDashboardInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.cardOnFileRepository.cardOnFile.sink { methods in
            let viewModels = methods.prefix(5).map(PaymentMethodViewModel.init)
            self.presenter.update(with: viewModels)
        }.store(in: &cancellables)
    }

    /// 인터렉터가 디테치 되기 전에 Will Design Active가 불림.
    /// 그때, cancellables를 삭제해주면 클로저에서 self 강한 참조를 쓰더라도 문제가 발생 하지 않음
    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didTapAddPaymentMethod() {
        //파이낸스홈에게 알려주는 것이 더 좋아보임(카드온파일은 일부만 담당하고 있기 때문에!)
        listener?.cardOnFileDashboardDidTapAddPaymentMethod()
    }
}
