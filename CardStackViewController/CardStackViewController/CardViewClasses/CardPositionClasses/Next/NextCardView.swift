//
//  NextCardView.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/28/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

// Animate
// Embed Embedded View Controller Into Current View Controller When Necessary

import UIKit

class NextCardView: CardView {
    // MARK: - Setup Methods
    func setup() {
        reset()
    }
    
    // MARK: - Pan Gesture Handler
    func pan(recognizer: UIPanGestureRecognizer) {
        switch (recognizer.state) {
        case .Began, .Changed:
            if (cardStackViewController.nextViewController != nil) || cardStackViewController.setNextViewController() {
                animateScaling()
            } else {
                println("No next view controller... show that the bottom was hit!")
            }
        default:
            break
        }
    }
    
    // MARK: - Display Methods
    func reset() {
        alpha = 1
        transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.92, 0.92), CGAffineTransformMakeRotation(0))
        layer.cornerRadius = 10
        
        center = superview!.center
    }
    
    func displayAs(view: CardView) {
        layer.cornerRadius = view.layer.cornerRadius
        
        // UIDynamicItem Properties
        frame = view.frame
        bounds = view.bounds
        center = view.center
        transform = view.transform
    }
    
    func peekScrollPrev() {
        // Center, and Scale
        //alpha = 1
        center = superview!.center
        transform = CGAffineTransformMakeScale(1, 1)
    }
}


// MARK: - Animated Interactions
extension NextCardView {
    func animateScaling() {
        if embeddedViewController == nil {
            return
        }
        
        // Scale Size/Scale Down with Gesture X-Translation
        let transformScaleIncrementPerTranslationUnit = -(0.08/(frame.width * 0.92)) as CGFloat
        let scale = 0.92 + (transformScaleIncrementPerTranslationUnit * panGestureTranslation.x)
        transform = CGAffineTransformMakeScale(scale, scale)
    }
}


// MARK: - Animated Actions
extension NextCardView {
    func animateReset() {
        let scrollingToTop: Bool = cardStackViewController.scrollingToTop
        let scrollToTopAnimationDuration = cardStackViewController.scrollToTopAnimationDuration
        let animationDuration: NSTimeInterval = (scrollingToTop ? scrollToTopAnimationDuration : 2)
        
        // Animate Reset Display
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { _ in
            self.reset()
            if scrollingToTop {
                self.transform = CGAffineTransformMakeScale(1, 1)
            }
            }, completion: nil)
    }
}