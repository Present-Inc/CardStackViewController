//
//  PrevCardView.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/28/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

// Animate
// Embed Embedded View Controller Into Current View Controller When Necessary

import UIKit

class PrevCardView: CardView {
    // MARK: - UIDynamics
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    
    // MARK: - Setup Methods
    func setup() {
        animator = UIDynamicAnimator(referenceView: superview!)
        reset()
    }
    
    // MARK: - Pan Gesture Handler
    func pan(recognizer: UIPanGestureRecognizer) {
        switch (recognizer.state) {
        case .Began, .Changed:
            if (cardStackViewController.prevViewController != nil) || cardStackViewController.setPrevViewController() {
                animateDragging()
            } else {
                println("No prev view controller... show that the top is hit / refresh")
            }
        default:
            break
        }
    }
    
    // MARK: - Display Methods
    func reset() {
        alpha = 0
        transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeRotation(0))
        layer.cornerRadius = 10
        
        frame = CGRectMake(
            -superview!.frame.width,
            superview!.frame.minY,
            superview!.frame.width,
            superview!.frame.height
        )
    }
    
    func displayAs(view: CardView) {
        alpha = view.alpha
        layer.cornerRadius = view.layer.cornerRadius
        
        // UIDynamicItem Properties
        frame = view.frame
        bounds = view.bounds
        //center = view.center
        transform = view.transform
    }
    
    func peekScrollPrev() {
        // Fade In, Center, and Scale
        alpha = 1
        center = CGPointMake(
            superview!.center.x * 0.25,
            superview!.center.y
        )
        transform = CGAffineTransformMakeRotation(0.15)
    }
}


// MARK: - View Controller Embedding / Removing
extension PrevCardView {
    override func removeEmbeddedViewController() {
        alpha = 0
        super.removeEmbeddedViewController()
    }
}


// MARK: - Animated Interactions
extension PrevCardView {
    func animateDragging() {
        if embeddedViewController == nil {
            return
        }
        
        // Update / Set Attachment Anchor Point
        if attachmentBehavior != nil {
            attachmentBehavior.anchorPoint = panGestureLocation
        } else {
            let attachmentBehaviorCenterOffset = UIOffsetMake(
                panGestureLocation.x - (2 * CGRectGetMinX(superview!.frame)),
                panGestureLocation.y - CGRectGetMidY(superview!.frame)
            )
            attachmentBehavior = UIAttachmentBehavior(item: self, offsetFromCenter: attachmentBehaviorCenterOffset, attachedToAnchor: panGestureLocation)
            attachmentBehavior.frequency = 0
            attachmentBehavior.damping = 0
            animator.addBehavior(attachmentBehavior)
        }
        
        // Scale Alpha Up with Gesture X-Translation
        let alphaIncrementPerTranslationUnit = (2/(frame.width * 0.92)) as CGFloat
        alpha = 0 + (alphaIncrementPerTranslationUnit * panGestureTranslation.x)
    }
}


// MARK: - Animated Actions
extension PrevCardView {
    func animateReset() {
        // Remove All Behaviors
        animator.removeAllBehaviors()
        attachmentBehavior = nil
        
        let scrollingToTop: Bool = cardStackViewController.scrollingToTop
        let scrollToTopAnimationDuration = cardStackViewController.scrollToTopAnimationDuration
        let animationDuration: NSTimeInterval = (scrollingToTop ? scrollToTopAnimationDuration : 0.26)
        
        // Animate Reset Display
        UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseOut, animations: { _ in
            self.reset()
            }, completion: { done in
                if scrollingToTop {
                    self.cardStackViewController.scrollToTop()
                }
        })
    }
}