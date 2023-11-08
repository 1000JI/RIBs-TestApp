//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/8/23.
//

import Foundation
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import ModernRIBs
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency, AddPaymentMethodDependency {
    var cardOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    
    /// 언젠가 모듈이 빌드가 되어야 하는 곳이 여기! 앱델리게이트와 가장 가까운 앱 최상단!
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    lazy var topupBuildable: TopupBuildable = {
        return TopupBuilder(dependency: self)
    }()
    
    lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
        return AddPaymentMethodBuilder(dependency: self)
    }()
    
    /// 동적으로 가장 위에 있는, 현재 앱에서 가장 위에 있는 뷰컨트롤러를 지정하면 됨
    var topupBaseViewController: ViewControllable { rootViewController.topViewController }
    
    private let rootViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        cardOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository,
        rootViewController: ViewControllable
    ) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}