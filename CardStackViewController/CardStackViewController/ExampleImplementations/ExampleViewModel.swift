//
//  ExampleViewModel.swift
//  UI Elements
//
//  Created by Daniel Scanlon on 11/3/14.
//  Copyright (c) 2014 Present. All rights reserved.
//

import UIKit

class ExampleViewModel: NSObject {

    // MARK: - Background Color
    var backgroundColor: UIColor!
    
    // MARK: - Initialization
    override init() {
        super.init()
        initialize()
    }
    
    private func initialize() {
        let red: CGFloat = CGFloat(drand48())
        let green: CGFloat = CGFloat(drand48())
        let blue: CGFloat = CGFloat(drand48())
        backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}
