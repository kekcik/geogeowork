//
//  SettingVC.swift
//  GeoGeo
//
//  Created by Иван Трофимов on 16.11.16.
//  Copyright © 2016 Иван Трофимов. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var showMore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordView.layer.cornerRadius = 8
        changePasswordView.clipsToBounds = true
//        //667
        heightConstraint.constant = view.frame.height - 60
    }
    
    @IBAction func LocationPermissionButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func NotificationsPermissonButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        showMoreAction()
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if oldPasswordTextField.text == "" &&
            newPasswordTextField.text == "" &&
            repeatPasswordTextField.text == ""{
            showMoreAction()
            return
        }
        if oldPasswordTextField.text == ""{
            showAlert(title: "Error", message: "Old password can't be an empty line")
        }else if newPasswordTextField.text == ""{
            showAlert(title: "Error", message: "New password can't be an empty line")
        }else if newPasswordTextField.text != repeatPasswordTextField.text{
            showAlert(title: "Error", message: "New passwords don't match")
        }else{
            ApiManager.changePassword(token: ApiManager.myToken,
                                      oldPassword: oldPasswordTextField.text!,
                                      newPassword: newPasswordTextField.text!,
                                      callback: {resultCode in
                                        if resultCode == "0"{
                                            self.showMoreAction()
                                        }else if resultCode == "40"{
                                            self.showAlert(title: "Error", message: "Wrong old password")
                                        }else{
                                            self.showAlert(title: "Error", message: "Something went wrong")
                                        }
            })
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func SwipeShowMore(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.up && !showMore {
            showMoreAction()
        } else if sender.direction == UISwipeGestureRecognizerDirection.down && showMore {
            showMoreAction()
        }
    }
    
    func showMoreAction(){
        print(self.view.frame.size.height)
        UIView.animate(withDuration: Double(0.333), animations: {
            if self.showMore{
                self.bottomConstraint.constant = -1 * self.view.frame.size.height //-1 * (self.view.frame.size.height - 110)
                self.leftConstraint.constant = 0
                self.rightConstraint.constant = 0
            }else{
                self.bottomConstraint.constant = 0
                self.leftConstraint.constant = 0
                self.rightConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        })
        showMore = !showMore
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
    }
}
