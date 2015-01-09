//
//  CurrentCardView.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/28/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

// Animate
// Embed Embedded View Controller Into Next View Controller When Necessary
// Embed Embedded View Controller Into Prev View Controller When Necessary
// Notify Embedded View Controller That It Will & Did Resign Current When Necessary
// Notify View Controller Pending Embed That It Will & Did Become Current When Necessary

import UIKit

class CurrentCardView: CardView {
    // MARK: - UIDynamics
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    
    // MARK: - State
    var isInTransition: Bool { return cardStackViewController.scrollingToTop }
    
    // MARK: - Setup Methods
    func setup() {
        setupAnimator()
        reset()
    }
    
    func setupAnimator() {
        animator = UIDynamicAnimator(referenceView: superview!)
    }
    
    // MARK: - Pan Gesture Handler
    func pan(recognizer: UIPanGestureRecognizer) {
        switch (recognizer.state) {
        case .Began, .Changed:
            let translatingLeft = panGestureTranslation.x < 0
            
            if translatingLeft {
                animateDraggingLeft()
            } else {
                animateScaling()
            }
        default:
            break
        }
    }
    
    // MARK: - Display Methods
    func reset() {
        alpha = 1
        transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeRotation(0))
        layer.cornerRadius = 0
        
        frame = superview!.frame
        center = superview!.center
    }
    
    func displayAs(view: CardView) {
        alpha = 1 // Force alpha to 1
        layer.cornerRadius = view.layer.cornerRadius
        
        // UIDynamicItem Properties
        frame = view.frame
        bounds = view.bounds
        center = view.center
        transform = view.transform
    }
}


// MARK: - View Controller Embedding / Removing
extension CurrentCardView {
    override func embedViewController(pendingViewController: UIViewController) {
        cardStackViewController.delegate?.cardStackViewController(cardStackViewController, willTransitionToViewController: pendingViewController)
        super.embedViewController(pendingViewController)
        
        if let embeddedViewController = embeddedViewController {
            cardStackViewController.delegate?.cardStackViewController(cardStackViewController, didFinishAnimating: true, previousViewController: embeddedViewController, transitionCompleted: true)
        }
    }
}


// MARK: - Animated Interactions
extension CurrentCardView {
    func animateDraggingLeft() {
        // Update / Set Attachment Behavior Anchor Point
        if attachmentBehavior != nil {
            attachmentBehavior.anchorPoint = panGestureLocation
        } else {
            let attachmentBehaviorCenterOffset = UIOffsetMake(
                panGestureLocation.x - CGRectGetMidX(superview!.frame),
                panGestureLocation.y - CGRectGetMidY(superview!.frame)
            )
            attachmentBehavior = UIAttachmentBehavior(item: self, offsetFromCenter: attachmentBehaviorCenterOffset, attachedToAnchor: panGestureLocation)
            attachmentBehavior.frequency = 0
            animator.addBehavior(attachmentBehavior)
        }
        
        // Animate Corner Radius to 10
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { _ in
            self.layer.cornerRadius = 10
            }, completion: nil)
        
        // Scale Alpha Down with Gesture X-Translation
        let alphaIncrementPerTranslationUnit = (0.3/(frame.width * 0.92)) as CGFloat
        alpha = 1 + (alphaIncrementPerTranslationUnit * panGestureTranslation.x)
    }
    
    func animateScaling() {
        // Remove All Behaviors
        animator.removeAllBehaviors()
        attachmentBehavior = nil
        
        // Fade In, And Center
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: { _ in
            self.alpha = 1
            self.center = self.superview!.center
            }, completion: nil)
        
        // Pick Up (Corner Radius = 10)
        layer.cornerRadius = 10
        
        // Scale Size/Scale Down with Gesture X-Translation
        let scaleIncrementPerTranslationUnit = -(0.08/(frame.width * 0.92)) as CGFloat
        let scale = 1 + (scaleIncrementPerTranslationUnit * panGestureTranslation.x)
        transform = CGAffineTransformMakeScale(scale, scale)
    }
}


// MARK: - Animated Actions
extension CurrentCardView {
    func animateReset() {
        // Remove All Behaviors
        animator.removeAllBehaviors()
        attachmentBehavior = nil
        
        // Animate Reset Display
        UIView.animateWithDuration(0.26, delay: 0, options: .CurveEaseOut, animations: { _ in
            self.reset()
            }, completion: nil)
    }
}