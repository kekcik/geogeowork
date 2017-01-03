//
//  LoginVC.swift
//  GeoGeo
//
//  Created by Иван Трофимов on 16.11.16.
//  Copyright © 2016 Иван Трофимов. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        if login == "" || password == ""{
            return
        }
        ApiManager.auth(phone: login!, password: password!, callback: { resultCode, id, token in
            print(resultCode)
            print(id)
            print(token)
        })
    }
}
