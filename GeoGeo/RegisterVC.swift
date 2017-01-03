//
//  RegisterVC.swift
//  GeoGeo
//
//  Created by Иван Трофимов on 16.11.16.
//  Copyright © 2016 Иван Трофимов. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
    }
}

