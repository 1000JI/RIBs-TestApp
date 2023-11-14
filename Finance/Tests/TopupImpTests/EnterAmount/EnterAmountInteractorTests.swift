//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/14/23.
//

@testable import TopupImp
import XCTest
import FinanceEntity

final class EnterAmountInteractorTests: XCTestCase {
    
    /// SUT(System Under Test)
    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!
    
    // TODO: declare other objects and mocks you need as private vars
    
    override func setUp() {
        super.setUp()
        
        self.presenter = EnterAmountPresentableMock()
        self.dependency = EnterAmountDependencyMock()
        self.listener = EnterAmountListenerMock()
        
        // 1. Enter Amount Interacter Setup.
        // Unit Test에서는 Interacter의 동작을 검증하기 위해 Mock 객체를 주입.
        sut = EnterAmountInteractor(
            presenter: self.presenter,
            dependency: self.dependency
        )
        sut.listener = self.listener
    }
    
    // MARK: - Tests
    
    func testActivate() {
        /*
         EnterAmountInteractor -> DidBecomeActive -> SelectedPaymentMethod Stream에서 데이터를 읽어와
         ViewModel로 전환하고 + Presenter에서 Update가 제대로 동작하는지 테스트
         */
        
        // given: 테스트 수행에 앞서서 환경을 Setup 해주는 작업
        // SelectedPaymentMethod Stream에 특정 개체 준비
        let paymentMethod = PaymentMethod(
            id: "id_0",
            name: "name_0",
            digits: "9999",
            color: "#13ABE8FF",
            isPrimary: false
        )
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when: 우리가 검증하고자 하는 행위, 그 메소드를 호출
        sut.activate()
        
        // then: 우리가 예상하는 행동을 했는지 검증
        // Presenter의 UpdateMethod를 호출하는 것
        XCTAssertEqual(presenter.updateSelectedPaymentMethodCallCount, 1)
        XCTAssertEqual(presenter.updateSelectedPaymentMethodViewModel?.name, "name_0 9999")
        XCTAssertNotEqual(presenter.updateSelectedPaymentMethodViewModel?.image, nil)
    }
}
