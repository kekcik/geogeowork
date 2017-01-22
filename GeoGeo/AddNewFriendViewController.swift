//
//  AddNewFriendViewController.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 21/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import UIKit

class AddNewFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var requestsTableView: UITableView!
    var requests = [UserClass]()

    override func viewDidLoad() {
        super.viewDidLoad()
        requests.append(UserClass(name: "kirill", id: "1005", phone: "+79992033333"))
        requests.append(UserClass(name: "Ivan", id: "243", phone: "+134324232442"))
        requestsTableView.rowHeight = 80
        requestsTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
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
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        requestsTableView.deselectRow(at: indexPath, animated: true)
    }
}
