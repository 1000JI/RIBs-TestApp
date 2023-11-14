//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/14/23.
//

@testable import TopupImp
import XCTest

final class EnterAmountInteractorTests: XCTestCase {
    
    /// SUT(System Under Test)
    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    
    // TODO: declare other objects and mocks you need as private vars
    
    override func setUp() {
        super.setUp()
        
        self.presenter = EnterAmountPresentableMock()
        self.dependency = EnterAmountDependencyMock()
        
        // 1. Enter Amount Interacter Setup.
        // Unit Test에서는 Interacter의 동작을 검증하기 위해 Mock 객체를 주입.
        sut = EnterAmountInteractor(
            presenter: self.presenter,
            dependency: self.dependency
        )
    }
    
    // MARK: - Tests
    
    func test_exampleObservable_callsRouterOrListener_exampleProtocol() {
        
    }
}
