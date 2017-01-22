//
//  ChatViewController.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 18/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    var conversation: ConversationClass = ConversationClass()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        automaticallyScrollsToMostRecentMessage = true
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    
    
    func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return ChatManager.translateMessageClassToJSQMessage(message: conversation.messages[indexPath.item])
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return conversation.messages[indexPath.item].senderId == self.senderId() ? outgoingBubble : incomingBubble
    }
    
    override func senderId() -> String {
        return conversation.senderUser.id
    }
    
    override func senderDisplayName() -> String {
        return conversation.senderUser.name
    }
    
//    func addMedia(_ media:JSQMediaItem) {
//        let message = JSQMessage(senderId: self.senderId(), displayName: self.senderDisplayName(), media: media)
//        self.conversation.messages.append(message)
//
//        self.finishSendingMessage(animated: true)
//    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
//        let message = conversation.messages[indexPath.item]
        return (conversation.messages[indexPath.item].senderId == self.senderId() ?
            ChatManager.createAvatar(initials: String(describing: conversation.senderUser.name.characters.first!),
                                     backgroundColor: ChatManager.createSenderAvatarColor()) :
            ChatManager.createAvatar(initials: String(describing: conversation.recieverUser.name.characters.first!),
                                     backgroundColor: ChatManager.createRecieverAvatarColor()))
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        ApiManager.sendMessage(token: ApiManager.myToken,
                               user_id: conversation.recieverUser.id,
                               text: text, callback: {resultCode in
                                if resultCode == "0"{
                                    self.conversation.messages.append(ChatManager.translateJSQMessageToMessageClass(message: message))
                                    self.finishSendingMessage(animated: true)
                                }
        })
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .actionSheet)
        
//        let photoAction = UIAlertAction(title: "Send photo", style: .default) { (action) in
//            let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate"))
//            self.addMedia(photoItem)
//        }
//        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
//        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }


}
