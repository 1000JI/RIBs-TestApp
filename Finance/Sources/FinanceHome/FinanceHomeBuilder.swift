import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import Topup

public protocol FinanceHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var topupBuildable: TopupBuildable { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
    var addPaymentBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }
    
    /// 자식 리블렛의 디펜던시를 충족시켜줘야 함
    override init(
        dependency: FinanceHomeDependency
    ) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        let viewController = FinanceHomeViewController()
        
        // 리블렛이 필요한 객체들을 담는 바구니의 개념 && 자식 리블렛이 필요한 것들도 담는 바구니
        let component = FinanceHomeComponent(
            dependency: dependency
        )
        
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        // 자식 리블렛 생성 및 디펜더시 추가
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuildable: superPayDashboardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: component.addPaymentBuildable,
            topupBuildable: component.topupBuildable
        )
    }
}
