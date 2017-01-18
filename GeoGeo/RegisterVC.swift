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
        let name = nameTextField.text
        let phone = phoneTextField.text
        let password = passwordTextField.text
        let repeatPassword = repeatPasswordTextField.text
        if name == "" || phone == "" ||
            password == "" || repeatPassword == ""{
            return
        }
        if password != repeatPassword{
            showAlert(title: "Password Incorrect", message: "Passwords are different")
        }else{
            ApiManager.register(phone: phone!, name: name!, password: password!, callback: {resultCode in
                if resultCode != "0"{
                    self.showAlert(title: "Error", message: "Something went wrong")
                    print(resultCode)
                }else{
                    self.performSegue(withIdentifier: "fromRegisterSegue", sender: self)
                }
            })
        }
    }
    
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
    }
    
}

extension RegisterVC{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromRegisterSegue"{
        }
    }
}


