//
//  TabBarViewController.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 10/12/2016.
//  Copyright © 2016 Иван Трофимов. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }


}
