//
//  ExampleViewController.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/30/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    var viewModel: ExampleViewModel! {
        didSet {
            if isViewLoaded() {
                configureWithViewModel()
            }
        }
    }
    
    // MARK: - Overrides
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var textField = UITextField(frame: CGRectMake(0, 0, view.frame.width, 40))
        textField.placeholder = "Enter Text"
        view.addSubview(textField)
        
        if viewModel != nil {
            configureWithViewModel()
        }
    }
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        
        // Bail if between embeds
        if parent == nil { return }
        
        // Determine whether to setup full or static (for transition)
        let isCard = view.superview is CardView,
        isCurrentCard = view.superview is CurrentCardView,
        isCurrentCardInTransition = (view.superview as? CurrentCardView)?.isInTransition ?? false,
        isPendingCard = isCard && !isCurrentCard,
        shouldConfigureStatic = isCurrentCardInTransition || isPendingCard
        
        println("isCard: \(isCard)")
        println("isCurrentCard: \(isCurrentCard)")
        println("isCurrentCardInTransition: \(isCurrentCardInTransition)")
        println("isPendingCard: \(isPendingCard)")
        println("shouldConfigureStatic: \(shouldConfigureStatic)")
    }
}


// MARK: - Configuration Methods
extension ExampleViewController {
    func configureWithViewModel() {
        view.backgroundColor = viewModel.backgroundColor
    }
}