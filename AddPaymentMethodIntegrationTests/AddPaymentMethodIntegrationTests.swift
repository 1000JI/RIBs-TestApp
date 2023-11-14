//
//  AddPaymentMethodIntegrationTests.swift
//  AddPaymentMethodIntegrationTests
//
//  Created by 천지운 on 11/14/23.
//

import XCTest
import Hammer
import FinanceRepository
import FinanceRepositoryTestSupport
import AddPaymentMethodTestSupport
import ModernRIBs
import RIBsUtil
@testable import AddPaymentMethodImp

final class AddPaymentMethodIntegrationTests: XCTestCase {
    
    private var eventGenerator: EventGenerator!
    private var dependency: AddPaymentMethodDependencyMock!
    private var listener: AddPaymentMethodListenerMock!
    private var viewController: UIViewController!
    private var router: Routing!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.dependency = AddPaymentMethodDependencyMock()
        self.listener = AddPaymentMethodListenerMock()
        
        let builder = AddPaymentMethodBuilder(dependency: self.dependency)
        let router = builder.build(withListener: self.listener, closeButtonType: .close)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        self.viewController = router.viewControllable.uiviewController
        
        eventGenerator = try EventGenerator(viewController: navigation.navigationController)
        
        router.load()
        router.interactable.activate()
        
        self.router = router
    }
    
    func testAddPaymentMethod() throws {
        try eventGenerator.wait(3)
    }
    
}

final class AddPaymentMethodDependencyMock: AddPaymentMethodDependency {
    var cardOnFileRepository: CardOnFileRepository = CardOnFileRepositoryMock()
}
