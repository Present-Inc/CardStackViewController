//
//  CardStackViewController.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/28/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

import UIKit

class DeepHitTestView: UIView {
    var cardStackViewController: CardStackViewController!
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return cardStackViewController.currentCardView?.embeddedViewController?.view.hitTest(point, withEvent: event)
    }
}

class CardStackViewController: UIViewController {
    var dataSource: CardStackViewControllerDataSource?
    var delegate: CardStackViewControllerDelegate?
    
    // MARK: - Container View
    var containerView: UIView!
    
    // MARK: - Pan Gesture Recognizer
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    // MARK: - Card Views
    var currentCardView: CurrentCardView!
    var nextCardView: NextCardView!
    var prevCardView: PrevCardView!
    
    // MARK: - Child View Controllers
    var currentViewController: UIViewController? { return currentCardView?.embeddedViewController }
    var nextViewController: UIViewController? { return nextCardView?.embeddedViewController }
    var prevViewController: UIViewController? { return prevCardView?.embeddedViewController }
    
    // MARK: - Animation Durations
    let scrollToTopAnimationDuration: NSTimeInterval = 0.08
    
    // MARK: - State
    var scrollingToTop: Bool = false
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = DeepHitTestView(frame: view.bounds)
        (view as DeepHitTestView).cardStackViewController = self
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup Methods
    func setup() {
        setupContainerView()
        setupCardViews()
        setupPanGestureRecognizer()
    }
    
    func setupContainerView() {
        containerView = UIView(frame: view.bounds)
        containerView.exclusiveTouch = false
        view.insertSubview(containerView, atIndex: 0)
    }
    
    func setupCardViews() {
        // Create Card Views
        currentCardView = CurrentCardView(frame: view.bounds)
        nextCardView = NextCardView(frame: view.bounds)
        prevCardView = PrevCardView(frame: view.bounds)
        
        // Set Card Views' References To Card Navigation Controller
        currentCardView.cardStackViewController = self
        nextCardView.cardStackViewController = self
        prevCardView.cardStackViewController = self
        
        // Setup View Controllers
        setupViewControllers()
        
        // Add Card Views As Subviews
        containerView.addSubview(nextCardView)
        containerView.insertSubview(currentCardView, aboveSubview: nextCardView)
        containerView.insertSubview(prevCardView, aboveSubview: currentCardView)
        
        // Setup Each Card View
        currentCardView.setup()
        nextCardView.setup()
        prevCardView.setup()
    }
    
    func setupViewControllers() {
        if let currentViewController = dataSource?.initialViewControllerForCardStackViewController(self) {
            setCurrentViewController()
            setNextViewController()
            setPrevViewController()
        }
    }
}


// MARK: - Actions
extension CardStackViewController {
    func reloadViewControllers() {
        setupViewControllers()
    }
    
    func animateResetAllCardViews() {
        currentCardView!.animateReset()
        nextCardView!.animateReset()
        prevCardView!.animateReset()
    }
}


// MARK: - Scroll To Top
extension CardStackViewController {
    func scrollToTop() {
        // If there's no prev view controller
        if prevViewController == nil {
            // Finish scrolling to top
            return cancelCommitScroll()
        }
        
        // Begin/continue scrolling to top ...
        scrollingToTop = true
        
        UIView.animateWithDuration(scrollToTopAnimationDuration, delay: 0, options: .CurveEaseIn, animations: { _ in
            self.nextCardView?.peekScrollPrev()
            self.prevCardView?.peekScrollPrev()
            }, completion: { done in
                self.commitScrollPrev()
        })
    }
}


// MARK: - View Controller Setters
extension CardStackViewController {
    func setCurrentViewController() -> Bool {
        if let currentViewController = dataSource?.initialViewControllerForCardStackViewController(self) {
            currentCardView.embedViewController(currentViewController)
            return true
        }
        
        return false
    }
    
    func setNextViewController() -> Bool {
        if let nextViewController = dataSource?.cardStackViewController(self, viewControllerAfterViewController: currentViewController!) {
            nextCardView.embedViewController(nextViewController)
            return true
        }
        
        return false
    }
    
    func setPrevViewController() -> Bool {
        if let prevViewController = dataSource?.cardStackViewController(self, viewControllerBeforeViewController: currentViewController!) {
            prevCardView.embedViewController(prevViewController)
            return true
        }
        
        return false
    }
}


// MARK: - Pan Gesture Recognizer
extension CardStackViewController: UIGestureRecognizerDelegate {
    var panGestureTranslation: CGPoint { return panGestureRecognizer.translationInView(view) }
    var panGestureVelocity: CGPoint { return panGestureRecognizer.velocityInView(view) }
    var panGestureLocation: CGPoint { return panGestureRecognizer.locationInView(view) }
    
    // MARK: Setup
    func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognizerDidRecognizePan:")
        panGestureRecognizer.delegate = self
        panGestureRecognizer.cancelsTouchesInView = false
        panGestureRecognizer.delaysTouchesBegan = false
        panGestureRecognizer.delaysTouchesEnded = false
        
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: UI Gesture Recognizer Delegate
    func panGestureRecognizerDidRecognizePan(panGestureRecognizer: UIPanGestureRecognizer) {
        currentCardView!.pan(panGestureRecognizer)
        nextCardView!.pan(panGestureRecognizer)
        prevCardView!.pan(panGestureRecognizer)
        
        if panGestureRecognizer.state == .Ended {
            if shouldScrollNext {
                commitScrollNext()
            } else if shouldScrollPrev {
                commitScrollPrev()
            } else {
                cancelCommitScroll()
            }
        }
    }
    
    // Allow Pan Gesture Recognizer To Recognize Simultaneously With All Other Gesture Recognizers
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return abs(panGestureVelocity.x) > abs(panGestureVelocity.y)
    }
}


// MARK: - Committing Scrolling
private extension CardStackViewController {
    func commitScrollNext() {
        // Bail if there's no nextViewController to scroll to
        if self.nextViewController == nil {
            return cancelCommitScroll()
        }
        
        let nextCurrentViewController = nextCardView.embeddedViewController
        let nextPrevViewController = currentCardView.embeddedViewController
        
        prevCardView.displayAs(currentCardView)
        prevCardView.embedViewController(nextPrevViewController!)
        
        currentCardView.displayAs(nextCardView)
        currentCardView.embedViewController(nextCurrentViewController!)
        
        nextCardView.removeEmbeddedViewController()
        setNextViewController()
        
        animateResetAllCardViews()
    }
    
    func commitScrollPrev() {
        // Bail if there's no prevViewController to scroll to
        if self.prevViewController == nil {
            return cancelCommitScroll()
        }
        
        let nextCurrentViewController = prevCardView.embeddedViewController
        let nextNextViewController = currentCardView.embeddedViewController
        
        nextCardView.displayAs(currentCardView)
        nextCardView.embedViewController(nextNextViewController!)
        
        currentCardView.displayAs(prevCardView)
        currentCardView.embedViewController(nextCurrentViewController!)
        
        prevCardView.removeEmbeddedViewController()
        setPrevViewController()
        
        animateResetAllCardViews()
    }
    
    func cancelCommitScroll() {
        // If scrolling to top, end scrolling to top and re-embed the current view controller (so that it reads the accurate isInTransition state of its superview)
        if scrollingToTop {
            scrollingToTop = false
            if let currentViewController = currentViewController {
                currentCardView.embedViewController(currentViewController)
            }
        }
        
        animateResetAllCardViews()
    }
}


// MARK: - Gesture Interaction Switches
extension CardStackViewController {
    var scrollNextXTranslationThreshold: CGFloat { return -0.85 * view.center.x }
    var scrollNextXVelocityThreshold: CGFloat { return -800 }
    var scrollPrevXTranslationThreshold: CGFloat { return 0.85 * view.center.x }
    var scrollPrevXVelocityThreshold: CGFloat { return 800 }
    
    var shouldScrollPrev: Bool { return (panGestureTranslation.x > scrollPrevXTranslationThreshold || panGestureVelocity.x > scrollPrevXVelocityThreshold) }
    var shouldScrollNext: Bool { return (panGestureTranslation.x < scrollNextXTranslationThreshold || panGestureVelocity.x < scrollNextXVelocityThreshold) }
}
