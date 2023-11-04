//
//  Swipe Back.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//

import Foundation
import UIKit

//Permet d'avoir le swipe back meme si le back bouton est modifié (NB : Bug sur simu peut etre)
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
