//
//  AddPaymentMethodRouter.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import ModernRIBs
import AddPaymentMethod

protocol AddPaymentMethodInteractable: Interactable {
    var router: AddPaymentMethodRouting? { get set }
    var listener: AddPaymentMethodListener? { get set }
}

protocol AddPaymentMethodViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AddPaymentMethodRouter: ViewableRouter<AddPaymentMethodInteractable, AddPaymentMethodViewControllable>, AddPaymentMethodRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AddPaymentMethodInteractable, viewController: AddPaymentMethodViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
