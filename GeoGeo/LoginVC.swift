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
            if resultCode != "0"{
                self.showAlert(title: "Error", message: "Something went wrong")
                print(resultCode)
            }else{
                self.performSegue(withIdentifier: "fromLoginSegue", sender: self)
            }
        })
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension LoginVC{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromLoginSegue"{
        }
    }
}
