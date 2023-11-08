import ModernRIBs
import FinanceRepository
import TransportHome

public protocol AppHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var transportHomeBuildable: TransportHomeBuildable { get }
}

final class AppHomeComponent: Component<AppHomeDependency> {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var transportHomeBuildable: TransportHomeBuildable { dependency.transportHomeBuildable }
}

// MARK: - Builder

public protocol AppHomeBuildable: Buildable {
    func build(withListener listener: AppHomeListener) -> ViewableRouting
}

public final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable {
    
    public override init(dependency: AppHomeDependency) {
        super.init(dependency: dependency)
    }
    
    /// 앱 구조: AppRoot 리블렛(최상위) - AppFinanceHome, Profile(자식들)
    /// 리블렛에 필요한 객체들을 생성
    /// 라우터를 Return -> 부모 리블렛이 사용
    /// 해당 라우터를 가지고 부모 리블렛이 두가지 작업을 하게 됨
    ///     1.AttachChild 호출(AppRootRouter.swift)
    public func build(withListener listener: AppHomeListener) -> ViewableRouting {
        // 로직을 수행하는 데 필요한 객체들을 담고 있을 바구니
        let component = AppHomeComponent(dependency: dependency)
        
        let viewController = AppHomeViewController()
        // 비즈니스 로직이 들어가는 리블렛의 두뇌
        let interactor = AppHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        // 라우터는 리블렛 간의 이동을 담당하는 역할
        return AppHomeRouter(
            interactor: interactor,
            viewController: viewController,
            transportHomeBuildable: component.transportHomeBuildable
        )
    }
}
