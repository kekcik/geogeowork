//
//  FriendsViewController.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 19/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendsList = [UserClass]()
    var followersList = [UserClass]()

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsList.append(UserClass(name: "kirill", id: "1005", phone: "+79992033333"))
        followersList.append(UserClass(name: "Ivan", id: "243", phone: "+134324232442"))
        friendsTableView.rowHeight = 75
        self.friendsTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        reloadUI()
    }
    
    @IBAction func addFriendButtonPressed(_ sender: Any) {
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex{
        case 0:
            return friendsList.count
        case 1:
            return followersList.count
        default:
            return 0
        }
    }
    
    func reloadUI(){
        friendsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        switch segmentControl.selectedSegmentIndex{
        case 0:
            cell.nameLabel.text = friendsList[indexPath.row].name
            cell.phoneLabel.text = friendsList[indexPath.row].phone
        case 1:
            cell.nameLabel.text = followersList[indexPath.row].name
            cell.phoneLabel.text = followersList[indexPath.row].phone
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendsTableView.deselectRow(at: indexPath, animated: true)
    }
}
