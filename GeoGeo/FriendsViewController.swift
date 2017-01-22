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
    
    let refreshCtrl = UIRefreshControl()

    
    var requestsList = [UserClass]()
    var followersList = [UserClass]()
    var followingList = [UserClass]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            friendsTableView.refreshControl = refreshCtrl
        } else {
            friendsTableView.addSubview(refreshCtrl)
        }
        refreshCtrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshCtrl.addTarget(self, action: #selector(refreshTableViewByPulling(sender:)), for: .valueChanged)
        initialProperties()
        friendsTableView.rowHeight = 80
        self.friendsTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        reloadUI()
    }
    
    @IBAction func addFriendButtonPressed(_ sender: Any) {
        
    }
    
    func refreshTableViewByPulling(sender: AnyObject){
        initialProperties()
        refreshCtrl.endRefreshing()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex{
        case 0:
            return followingList.count
        case 1:
            return followersList.count
        case 2:
            return requestsList.count
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
            cell.nameLabel.text = followingList[indexPath.row].name
            cell.phoneLabel.text = followingList[indexPath.row].phone
            cell.user = followingList[indexPath.row]
            cell.statusOfCell = UserTableViewCell.status.following
            cell.setAddFriend()
            ApiManager.getUserPermissions(token: ApiManager.myToken,
                                          user_id: followingList[indexPath.row].id, callback: {
                                            resultCode, inAns, outAns in
                                            if resultCode == "0" && outAns{
                                                cell.setHaveFriend()
                                            }
            })
        case 1:
            cell.nameLabel.text = followersList[indexPath.row].name
            cell.phoneLabel.text = followersList[indexPath.row].phone
            cell.user = followersList[indexPath.row]
            cell.statusOfCell = UserTableViewCell.status.follower
            cell.setAddFriend()
            ApiManager.getUserPermissions(token: ApiManager.myToken,
                                          user_id: followersList[indexPath.row].id, callback: {
                                            resultCode, inAns, outAns in
                                            if resultCode == "0" && outAns{
                                                cell.setHaveFriend()
                                            }
            })
        case 2:
            cell.nameLabel.text = requestsList[indexPath.row].name
            cell.phoneLabel.text = requestsList[indexPath.row].phone
            cell.user = requestsList[indexPath.row]
            cell.statusOfCell = UserTableViewCell.status.request
            cell.setAddFriend()
            if requestsList[indexPath.row].flag{
                cell.setHaveFriend()
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendsTableView.deselectRow(at: indexPath, animated: true)
        let chatView = ChatViewController()
        var user = UserClass()
        switch segmentControl.selectedSegmentIndex{
        case 0:
            user = followingList[indexPath.row]
        case 1:
            user = followersList[indexPath.row]
        case 2:
            user = requestsList[indexPath.row]
        default:
            return
        }
        chatView.conversation = ConversationClass(senderUser: ApiManager.me,
                                                  recieverUser: user,
                                                  latestMessageId: nil,
                                                  latestMessageData: nil,
                                                  latestMessageType: nil,
                                                  isRead: nil,
                                                  createdTime: nil)
        ApiManager.getDialogWithUser(token: ApiManager.myToken,
                                     user_id: user.id,
                                     count: "1000",
                                     offset: "0",
                                     callback: {resultCode, messages in
                                        if resultCode == "0"{
                                            chatView.conversation.messages = messages
                                            chatView.conversation.messages.reverse()
                                        }
                                        let chatNavigationController = UINavigationController(rootViewController: chatView)
                                        self.present(chatNavigationController, animated: true, completion: nil)
        })
    }
    
    func initialProperties(){
        followingList.removeAll()
        followersList.removeAll()
        requestsList.removeAll()
        ApiManager.getFollowed(token: ApiManager.myToken,
                                callback: {resultCode, requests in
                                    var count = 0
                                    for request in requests{
                                        ApiManager.getUserById(token: ApiManager.myToken, id: request, callback: {
                                            resultCode, user in
                                            self.followingList.append(user)
                                            count += 1
                                            if count == requests.count{
                                                self.reloadUI()
                                            }
                                        })
                                    }
                                    
        })
        ApiManager.getFollowers(token: ApiManager.myToken,
                                callback: {resultCode, requests in
                                    var count = 0
                                    for request in requests{
                                        ApiManager.getUserById(token: ApiManager.myToken, id: request, callback: {
                                            resultCode, user in
                                            self.followersList.append(user)
                                            count += 1
                                            if count == requests.count{
                                                self.reloadUI()
                                            }
                                        })
                                    }
        })
        ApiManager.getRequests(token: ApiManager.myToken,
                               callback: {resultCode, requests in
                                var count = 0
                                for request in requests{
                                    var id = request.followerId
                                    var flag = false
                                    if request.followerId == ApiManager.me.id && request.followedId != ApiManager.me.id{ // if follower is me
                                        id = request.followedId
                                        flag = true
                                    }
                                    ApiManager.getUserById(token: ApiManager.myToken, id: id, callback: {
                                        resultCode, user in
                                        self.requestsList.append(user)
                                        self.requestsList.last?.flag = flag
                                        count += 1
                                        if count == requests.count{
                                            self.reloadUI()
                                        }
                                    })
                                }
                                
        })
        
    }
}
