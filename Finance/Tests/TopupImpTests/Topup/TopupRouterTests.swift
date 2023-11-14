//
//  TopupRouterTests.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/14/23.
//

@testable import TopupImp
import XCTest
import RIBsTestSupport
import AddPaymentMethodTestSupport

final class TopupRouterTests: XCTestCase {
    
    private var sut: TopupRouter!
    
    private var interactor: TopupInteractableMock!
    private var viewController: ViewControllableMock!
    private var addPaymentMethodBuildable: AddPaymentMethodBuildableMock!
    private var enterAmountBuildable: EnterAmountBuildableMock!
    private var cardOnFileBuildable: CardOnFileBuildableMock!
    
    override func setUp() {
        super.setUp()
        
        interactor = TopupInteractableMock()
        viewController = ViewControllableMock()
        addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
        enterAmountBuildable = EnterAmountBuildableMock()
        cardOnFileBuildable = CardOnFileBuildableMock()
        
        sut = TopupRouter(
            interactor: interactor,
            viewController: viewController,
            addPaymentMethodBuildable: addPaymentMethodBuildable,
            enterAmountBuildable: enterAmountBuildable,
            cardOnFileBuildable: cardOnFileBuildable
        )
    }
    
    // MARK: - Tests
    
}
