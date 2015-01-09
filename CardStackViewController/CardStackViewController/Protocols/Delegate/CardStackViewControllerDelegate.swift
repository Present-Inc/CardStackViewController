//
//  CardStackViewControllerDelegate.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/30/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

import UIKit

protocol CardStackViewControllerDelegate {
    func cardStackViewController(_: CardStackViewController, willTransitionToViewController pendingCardViewController: UIViewController)
    func cardStackViewController(_: CardStackViewController, didFinishAnimating finished: Bool, previousViewController: UIViewController, transitionCompleted completed: Bool)
}