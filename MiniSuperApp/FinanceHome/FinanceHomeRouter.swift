import ModernRIBs

/// listener에 등록하기 위해서 SuperPayDashboardListener를 상속 받도록 함
protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    
    /// 자식 리블렛을 붙일 때 혹시나 실수로 아니면 버그로 똑같은 자식을 두 번 이상 붙이지 않도록 방어로직 추가
    private var superPayRouting: Routing?
    
    // 자식 빌더를 프로퍼티로 추가 후 생성자에도 추가를 해줌
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSuperPayDashboard() {
        if superPayRouting != nil {
            return
        }
        
        // 자식 리블렛을 붙이려면 먼저 빌더에 빌드 메소드를 호출해서 라우터를 받아야 함
        // 빌드를 해줄 때 리스너를 파라미터로 넘겨줘야 하는데, 자식 리블렛의 리스너는 비즈니스 로딩을 담당하는 인터렉터가 됨
        let router = superPayDashboardBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        self.superPayRouting = router
        attachChild(router)
    }
    
}
