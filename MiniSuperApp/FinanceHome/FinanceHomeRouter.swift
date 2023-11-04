import ModernRIBs

/// listener에 등록하기 위해서 SuperPayDashboardListener를 상속 받도록 함
protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    /// 자식 리블렛을 붙일 때 혹시나 실수로 아니면 버그로 똑같은 자식을 두 번 이상 붙이지 않도록 방어로직 추가
    private var superPayRouting: Routing?
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    
    private var cardOnFileRouting: Routing?
    private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    
    private var addPaymentMethodRouting: Routing?
    private var addPaymentMethodBuildable: AddPaymentMethodBuildable
    
    private var topupRouting: Routing?
    private var topupBuildable: TopupBuildable
    
    // 자식 빌더를 프로퍼티로 추가 후 생성자에도 추가를 해줌
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        topupBuildable: TopupBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.topupBuildable = topupBuildable
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
    
    func attachCardOnFileDashboard() {
        if cardOnFileRouting != nil {
            return
        }
        
        let router = cardOnFileDashboardBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        self.superPayRouting = router
        attachChild(router)
    }
    
    func attachAddPaymentMethod() {
        // 모달로 띄울 경우 제스처로 닫을 수 있음.
        // 따라서 addPaymentMethodRouting 값이 nil이 아니라 추가가 안되는 문제가 발생 할 수 있음
        // 뷰컨을 띄웠던 부모가 자식을 무조건 책임지고 닫아야함
        // 그래서 어태치와 디테치가 같이 있다보니 관리가 편해지고 어디서든 사용 할 수 있게됨(재사용성)
        // 뷰컨이 자신을 Dismiss하는 코드를 자기 자신 안에서 부를 때가 있는데 그렇게 되면 그 뷰컨은 재사용하기가 어려움
        // 왜냐하면 뷰컨을 쓰는 부모의 입장에서는 이 뷰컨의 라이프 사이클을 전적으로 관리할 수 없게 되기 때문..
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        // viewControllable에서 프레젠트 하는 로직은 거의 모든 곳에서 사용되기 때문에 유틸 만듬!
        viewControllable.present(navigation, animated: true, completion: nil)
        
        addPaymentMethodRouting = router
        attachChild(router)
    }
    
    func detachAddPamyentMethod() {
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        viewControllable.dismiss(completion: nil)
        
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachTopup() {
        if topupRouting != nil {
            return
        }
        
        let router = topupBuildable.build(withListener: interactor)
        topupRouting = router
        attachChild(router)
    }
    
    func detachTopup() {
        guard let router = topupRouting else {
            return
        }
        
        detachChild(router)
        self.topupRouting = nil
    }
    
}
