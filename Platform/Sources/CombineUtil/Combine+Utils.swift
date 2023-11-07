//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import Combine
import CombineExt
import Foundation

/*
 Subscriber들이 가장 최신 값을 접근할 수 있게 해주되 직접 값을 샌드를 할 수 없게 하는 메커니즘 필요
 */

public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
    
    public typealias Output = Element
    public typealias Failure = Never
    
    public var value: Element {
        currentValueRelay.value
    }
    
    fileprivate let currentValueRelay: CurrentValueRelay<Output>
    
    fileprivate init(_ initialValue: Element) {
        currentValueRelay = CurrentValueRelay(initialValue)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
        currentValueRelay.receive(subscriber: subscriber)
    }
    
}

/// 잔액을 관리하는 객체 + 잔액을 사용하는 객체들은 부모 객체인 Read-Only 타입으로 받아서 값을 샌드를 할 수 없지만 value를 통해 값을 받아 올 수 있도록 함
public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
    
    typealias Output = Element
    typealias Failure = Never
    
    public override init(_ initialValue: Element) {
        super.init(initialValue)
    }
    
    public func send(_ value: Element) {
        currentValueRelay.accept(value)
    }
    
}
