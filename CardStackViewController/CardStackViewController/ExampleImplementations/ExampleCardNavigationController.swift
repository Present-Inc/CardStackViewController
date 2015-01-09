//
//  _ExampleCardStackViewController.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/28/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

import UIKit

class ExampleCardStackViewController: CardStackViewController {

    // MARK: - Overrides
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}


// MARK: - Card Navigation Controller Delegate
extension CardStackViewController: CardStackViewControllerDelegate {
    func cardStackViewController(_: CardStackViewController, willTransitionToViewController pendingCardViewController: UIViewController) {}
    func cardStackViewController(_: CardStackViewController, didFinishAnimating finished: Bool, previousViewController: UIViewController, transitionCompleted completed: Bool) {}
}


// MARK: - Card Navigation Controller Data Source
extension CardStackViewController: CardStackViewControllerDataSource {
    func initialViewControllerForCardStackViewController(_: CardStackViewController) -> UIViewController? {
        let viewController: ExampleViewController = ExampleViewController(nibName: nil, bundle: nil)
        let viewModel: ExampleViewModel = ExampleViewModel()
        
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func cardStackViewController(_: CardStackViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let viewController: ExampleViewController = ExampleViewController(nibName: nil, bundle: nil)
        let viewModel: ExampleViewModel = ExampleViewModel()
        
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func cardStackViewController(_: CardStackViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let viewController: ExampleViewController = ExampleViewController(nibName: nil, bundle: nil)
        let viewModel: ExampleViewModel = ExampleViewModel()
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}