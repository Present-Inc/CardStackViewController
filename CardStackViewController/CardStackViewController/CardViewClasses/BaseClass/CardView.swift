//
//  CardView.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/28/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

import UIKit

class CardView: UIView, UIGestureRecognizerDelegate {
    var embeddedViewController: UIViewController?
    var cardStackViewController: CardStackViewController!
    
    // MARK: - Pan Gesture Value Shorthands
    var panGestureTranslation: CGPoint { return cardStackViewController.panGestureTranslation }
    var panGestureVelocity: CGPoint { return cardStackViewController.panGestureVelocity }
    var panGestureLocation: CGPoint { return cardStackViewController.panGestureLocation }
    
    // MARK: - Gesture Interaction Switch Shorthands
    var shouldScrollPrev: Bool { return cardStackViewController.shouldScrollPrev }
    var shouldScrollNext: Bool { return cardStackViewController.shouldScrollNext }
    
    // MARK: - Initialization
    override init() { super.init(); initialize() }
    required init(coder aDecoder: NSCoder) { super.init(); initialize() }
    override init(frame: CGRect) { super.init(frame: frame); initialize() }
    private func initialize() {
        clipsToBounds = true
    }
    
    // MARK: - View Controller Embedding
    func removeEmbeddedViewController() {
        if let embeddedViewController = self.embeddedViewController {
            embeddedViewController.willMoveToParentViewController(nil)
            embeddedViewController.view.removeFromSuperview()
            embeddedViewController.removeFromParentViewController()
        }
        
        embeddedViewController = nil
    }
    
    func embedViewController(pendingViewController: UIViewController) {
        // Remove pending view controller from the view hierarchy before embedding it
        if let pendingViewControllerCardView = pendingViewController.view.superview as? CardView {
            pendingViewControllerCardView.removeEmbeddedViewController()
        }
        
        // Remove this card's embedded view controller
        removeEmbeddedViewController()
        
        // Embed the pending view controller into this card
        cardStackViewController.addChildViewController(pendingViewController)
        pendingViewController.view.frame = bounds
        addSubview(pendingViewController.view)
        pendingViewController.didMoveToParentViewController(cardStackViewController)
        
        embeddedViewController = pendingViewController
    }
}