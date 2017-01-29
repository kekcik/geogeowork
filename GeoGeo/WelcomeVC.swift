//
//  WelcomeVC.swift
//  GeoGeo
//
//  Created by Иван Трофимов on 16.11.16.
//  Copyright © 2016 Иван Трофимов. All rights reserved.
//

import UIKit
import ChameleonFramework

class WelcomeVC: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 8
        registerButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 8
        loginButton.clipsToBounds = true
//        self.view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: UIScreen.main.bounds, andColors:[UIColor.flatWhite, UIColor.flatGrayDark])
    }
}
