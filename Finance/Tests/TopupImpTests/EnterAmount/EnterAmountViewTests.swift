//
//  File.swift
//  
//
//  Created by 천지운 on 11/14/23.
//

import XCTest
import Foundation
import SnapshotTesting
import FinanceEntity
@testable import TopupImp

final class EnterAmountViewTests: XCTestCase {
    
    func testExample() {
        // given
        let paymentMethod = PaymentMethod(
            id: "0",
            name: "슈퍼은행",
            digits: "**** 8888",
            color: "#51AF80FF",
            isPrimary: false
        )
        let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhoneXsMax))
    }
    
    func testEnterAmountLoading() {
        // given
        let paymentMethod = PaymentMethod(
            id: "0",
            name: "슈퍼은행",
            digits: "**** 8888",
            color: "#51AF80FF",
            isPrimary: false
        )
        let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        sut.startLoading()
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhoneXsMax))
    }
    
    func testEnterAmountStopLoading() {
        // given
        let paymentMethod = PaymentMethod(
            id: "0",
            name: "슈퍼은행",
            digits: "**** 8888",
            color: "#51AF80FF",
            isPrimary: false
        )
        let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        sut.startLoading()
        sut.stopLoading()
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhoneXsMax))
    }
    
}
