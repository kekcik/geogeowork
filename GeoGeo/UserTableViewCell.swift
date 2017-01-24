//
//  UserTableViewCell.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 19/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var gotoChatButton: UIButton!
    
    enum status{
        case following
        case follower
        case request
        case find
    }
    
    var user = UserClass()
    var statusOfCell: status!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setHaveFriend(){
        statusButton.setBackgroundImage(#imageLiteral(resourceName: "haveFriend"), for: .normal)
    }
    
    func setAddFriend(){
        statusButton.setBackgroundImage(#imageLiteral(resourceName: "plusRound"), for: .normal)
    }
    
    
    @IBAction func statusButtonPressed(_ sender: Any) {
        if statusButton.currentBackgroundImage == #imageLiteral(resourceName: "haveFriend"){
            ApiManager.unfollowRequest(token: ApiManager.myToken,
                                       user_id: user.id, callback: {resultCode in
                                        if resultCode == "0"{
                                            self.setAddFriend()
                                        }
            })
        }else{
            if statusOfCell == status.following ||
                statusOfCell == status.follower ||
                statusOfCell == status.find{
                ApiManager.followRequest(token: ApiManager.myToken,
                                         user_id: user.id, callback: {resultCode in
                                            if resultCode == "0"{
                                                self.setHaveFriend()
                                            }
                })
            }else if statusOfCell == status.request{
                ApiManager.acceptRequest(token: ApiManager.myToken,
                                         user_id: user.id, callback: { resultCode in
                                            if resultCode == "0"{
                                                self.setHaveFriend()
                                            }
                })
            }
        }
    }
    
    @IBAction func gotoChatButtonPressed(_ sender: Any) {
        
    }
}
