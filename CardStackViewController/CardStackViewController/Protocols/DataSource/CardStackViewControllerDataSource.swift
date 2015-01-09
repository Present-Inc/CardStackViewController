//
//  CardStackViewControllerDataSource.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 10/30/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

import UIKit

protocol CardStackViewControllerDataSource {
    func initialViewControllerForCardStackViewController(_: CardStackViewController) -> UIViewController?
    func cardStackViewController(_: CardStackViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    func cardStackViewController(_: CardStackViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
}
