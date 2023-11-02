//
//  CardOnFileDashboardRouter.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/3/23.
//

import ModernRIBs

protocol CardOnFileDashboardInteractable: Interactable {
    var router: CardOnFileDashboardRouting? { get set }
    var listener: CardOnFileDashboardListener? { get set }
}

protocol CardOnFileDashboardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CardOnFileDashboardRouter: ViewableRouter<CardOnFileDashboardInteractable, CardOnFileDashboardViewControllable>, CardOnFileDashboardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CardOnFileDashboardInteractable, viewController: CardOnFileDashboardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
