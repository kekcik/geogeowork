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

    var conversation: ConversationClass!
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        createConversation()
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

    func createConversation(){
        conversation = ConversationClass(senderUser: UserClass(name: "Kirill", id: "1005", phone: "1234"),
                                         recieverUser: UserClass(name: "Ivan", id: "1006", phone: "4321"),
                                         latestMessageId: "10",
                                         latestMessageData: "Hello",
                                         latestMessageType: "1",
                                         isRead: false,
                                         createdTime: ApiManager.getUnixTime(),
                                         messages: [])
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
        let message = conversation.messages[indexPath.item]
        return (conversation.messages[indexPath.item].senderId == self.senderId() ?
            ChatManager.createAvatar(initials: "ME", backgroundColor: ChatManager.createSenderAvatarColor()) :
            ChatManager.createAvatar(initials: "YU", backgroundColor: ChatManager.createRecieverAvatarColor()))
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.conversation.messages.append(ChatManager.translateJSQMessageToMessageClass(message: message))
        self.finishSendingMessage(animated: true)
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
