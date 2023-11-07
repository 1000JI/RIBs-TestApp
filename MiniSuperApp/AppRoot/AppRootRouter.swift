import ModernRIBs
import RIBsUtil
import FinanceHome

protocol AppRootInteractable: Interactable,
                              AppHomeListener,
                              FinanceHomeListener,
                              ProfileHomeListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    private let appHome: AppHomeBuildable
    private let financeHome: FinanceHomeBuildable
    private let profileHome: ProfileHomeBuildable
    
    private var appHomeRouting: ViewableRouting?
    private var financeHomeRouting: ViewableRouting?
    private var profileHomeRouting: ViewableRouting?
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        appHome: AppHomeBuildable,
        financeHome: FinanceHomeBuildable,
        profileHome: ProfileHomeBuildable
    ) {
        self.appHome = appHome
        self.financeHome = financeHome
        self.profileHome = profileHome
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    /// 자식 빌더의 Build Method를 호출해서 Return 된 라우터를 받음
    func attachTabs() {
        let appHomeRouting = appHome.build(withListener: interactor)
        let financeHomeRouting = financeHome.build(withListener: interactor)
        let profileHomeRouting = profileHome.build(withListener: interactor)
        
        // RIBs Framework에 있는 메소드이며, RIBs 트리를 만들어서 각 리블렛의 레퍼런스를 유지하고
        // 인터렉터의 라이프사이클 관련 메소드를 호출하는 작업
        attachChild(appHomeRouting)
        attachChild(financeHomeRouting)
        attachChild(profileHomeRouting)
        
        // viewControllable -> UIViewController를 한번 감싼 인터페이스
        // 왜?? UIKit을 감추기 위해서 :)
        let viewControllers = [
            NavigationControllerable(root: appHomeRouting.viewControllable),
            NavigationControllerable(root: financeHomeRouting.viewControllable),
            profileHomeRouting.viewControllable
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
