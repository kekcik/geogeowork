//
//  AddNewFriendViewController.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 21/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import UIKit

class AddNewFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var requestsTableView: UITableView!
    var requests = [UserClass]()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestsTableView.rowHeight = 80
        requestsTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    @IBAction func searchTextFieldDidChange(_ sender: Any) {
        if searchTextField.text! != ""{
            search()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return requests.count
    }
    
    func reloadUI(){
        requestsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requestsTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        cell.nameLabel.text = requests[indexPath.row].name
        cell.phoneLabel.text = requests[indexPath.row].phone
        cell.user = requests[indexPath.row]
        cell.setAddFriend()
        cell.statusOfCell = UserTableViewCell.status.find
        ApiManager.getUserPermissions(token: ApiManager.myToken,
                                      user_id: requests[indexPath.row].id, callback: {
                                        resultCode, inAns, outAns in
                                        if resultCode == "0" && outAns{
                                            cell.setHaveFriend()
                                        }
        })
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        requestsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        search()
    }
    
    
    func search(){
        let message = searchTextField.text!
        var variants = [UserClass]()
        ApiManager.searchUserByName(token: ApiManager.myToken,
                                    name: message,
                                    callback: {resultCode, users in
                                        if resultCode == "0"{
                                            variants.append(contentsOf: users)
                                            ApiManager.searchUserByPhone(token: ApiManager.myToken,
                                                                         phone: message,
                                                                         callback: {resultCode, users in
                                                                            if resultCode == "0"{
                                                                                variants.append(contentsOf: users)
                                                                                self.requests = variants
                                                                                self.reloadUI()
                                                                            }
                                            })
                                        }
        })

    }
    
}
