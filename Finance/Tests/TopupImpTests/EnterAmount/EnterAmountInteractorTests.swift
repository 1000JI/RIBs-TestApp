//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/14/23.
//

@testable import TopupImp
import XCTest
import FinanceEntity
import FinanceRepositoryTestSupport

final class EnterAmountInteractorTests: XCTestCase {
    
    /// SUT(System Under Test)
    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!
    
    private var repository: SuperPayRepositoryMock! {
        dependency.superPayRepository as? SuperPayRepositoryMock
    }
    
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
    
    func testTopupWithValidAmount() {
        // given
        let paymentMethod = PaymentMethod(
            id: "id_0",
            name: "name_0",
            digits: "9999",
            color: "#13ABE8FF",
            isPrimary: false
        )
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when
        sut.didTapTopup(with: 1_000_000)
        
        // then
        // 비동기로 동작하고 있기 때문에 wait 없이 동작하면 실패가 뜸
        // 1-1. 웨이팅 주는 방법
//        _ = XCTWaiter.wait(for: [expectation(description: "Wait 0.1 second")], timeout: 0.1)
        
        // 1-2. 쓰레드 변경
//         .receive(on: DispatchQueue.main) -> .receive(on: ImmediateScheduler.shared)
        
        // 1-3. 유용한 라이브러리 사용 -> https://github.com/pointfreeco/combine-schedulers
        
        // 1. Presenter의 StartLoading & StopLoading이 잘 불리는지 확인
        // 로딩을 띄우고 내리는 게 쌍으로 잘 이루어지는지 확인하는 게 굉장히 중요한 테스트
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.stopLoadingCallCount, 1)
        
        // 2. Repository의 값을 제대로 Amount와 PaymentMethod 아이디를 잘 주는지 확인
        XCTAssertEqual(repository.topupCallCount, 1)
        XCTAssertEqual(repository.paymentMethodID, "id_0")
        XCTAssertEqual(repository.topupAmount, 1_000_000)
        
        // 3. 충전이 성공하고 나면 리스너의 콜백을 잘 주는지 확인
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 1)
    }
    
    func testTopupWithFailure() {
        // given
        let paymentMethod = PaymentMethod(
            id: "id_0",
            name: "name_0",
            digits: "9999",
            color: "#13ABE8FF",
            isPrimary: false
        )
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        repository.shouldTopupSucceed = false
        
        // when
        sut.didTapTopup(with: 1_000_000)
        
        // then
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.stopLoadingCallCount, 1)
        // 실패했을 경우에는 카운트가 증가하면 안됨
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 0)
    }
    
    func testDidTapClose() {
        // given
        
        // when
        sut.didTapClose()
        
        // then
        XCTAssertEqual(listener.enterAmountDidTapCloseCallCount, 1)
    }
    
    func testDidTapPaymentMethod() {
        // given
        
        // when
        sut.didTapPaymentMethod()
        
        // then
        XCTAssertEqual(listener.enterAmountDidTapPaymentMethodCallCount, 1)
    }
    
}
