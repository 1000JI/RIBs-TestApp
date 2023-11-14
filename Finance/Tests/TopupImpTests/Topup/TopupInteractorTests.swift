//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/14/23.
//

@testable import TopupImp
import XCTest
import TopupTestSupport
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport

final class TopupInteractorTests: XCTestCase {
    
    private var sut: TopupInteractor!
    private var dependency: TopupDependencyMock!
    private var listener: TopupListenerMock!
    private var router: TopupRoutingMock!
    
    private var cardOnFileRepository: CardOnFileRepositoryMock {
        dependency.cardOnFileRepository as! CardOnFileRepositoryMock
    }
    
    override func setUp() {
        super.setUp()
        
        self.dependency = TopupDependencyMock()
        self.listener = TopupListenerMock()
        
        let interactor = TopupInteractor(dependency: self.dependency)
        self.router = TopupRoutingMock(interactable: interactor)
        
        interactor.listener = self.listener
        interactor.router = self.router
        self.sut = interactor
    }
    
    // MARK: - Tests
    
    func testActivate() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false
            )
        ]
        cardOnFileRepository.cardOnFileSuject.send(cards)
        
        // when
        sut.activate()
        
        // then
        XCTAssertEqual(router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.name, "Zero")
    }
    
    func testActivateWithoutCard() {
        // given
        cardOnFileRepository.cardOnFileSuject.send([])
        
        // when
        sut.activate()
        
        // then
        XCTAssertEqual(router.attachAddPaymentMethodCallCount, 1)
        XCTAssertEqual(router.attachAddPaymentMethodCloseButtonType, .close)
    }
    
}
