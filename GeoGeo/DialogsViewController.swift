//
//  DialogsViewController.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 19/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import UIKit

class DialogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var chatTableView: UITableView!
    
    var chats = [ConversationClass]()
    let refreshCtrl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            chatTableView.refreshControl = refreshCtrl
        } else {
            chatTableView.addSubview(refreshCtrl)
        }
        refreshCtrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshCtrl.addTarget(self, action: #selector(refreshTableViewByPulling(sender:)), for: .valueChanged)
        chatTableView.rowHeight = 80
        chatTableView.register(UINib(nibName: "DialogTableViewCell", bundle: nil), forCellReuseIdentifier: "DialogCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDialogs()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func reloadUI(){
        chatTableView.reloadData()
    }
    
    func refreshTableViewByPulling(sender: AnyObject){
        loadDialogs()
        refreshCtrl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "DialogCell", for: indexPath) as! DialogTableViewCell
        cell.nameLabel.text = chats[indexPath.row].recieverUser.name
        cell.timeLabel.text = chats[indexPath.row].createdTime!
        cell.lastMessageLabel.text = chats[indexPath.row].latestMessageData
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatTableView.deselectRow(at: indexPath, animated: true)
        ApiManager.createChat(with: chats[indexPath.row].recieverUser,
                              latestMessageId: chats[indexPath.row].latestMessageId,
                              latestMessageData: chats[indexPath.row].latestMessageData,
                              isRead: chats[indexPath.row].isRead,
                              createdTime: chats[indexPath.row].createdTime,
                              callback: {chatView in
                                let chatNavigationController = UINavigationController(rootViewController: chatView)
                                self.present(chatNavigationController, animated: true, completion: nil)
        })
    }

    
    func loadDialogs(){
        ApiManager.getDialogs(token: ApiManager.myToken,
                              callback: {resultCode, dialogs in
                                self.chats = dialogs
                                self.reloadUI()
        })
    }

}
