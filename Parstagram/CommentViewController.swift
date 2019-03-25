//
//  CommentViewController.swift
//  Parstagram
//
//  Created by Yash Kakodkar on 3/22/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar
import AlamofireImage

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsTable: UITableView!
    var post: PFObject!
    var comments = [PFObject]()
    let commentBar = MessageInputBar()
    var showsCommentBar = false

    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        print("hi: \(post != nil)")
        
        let user = post["author"] as! PFUser
        authorLabel.text = user.username
        
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar;
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        let comment = PFObject(className: "Comments")
        
        comment["text"] = text
        comment["post"] = post
        comment["author"] = PFUser.current()!
        print(text)
        post.add(comment, forKey: "comments")
        post.saveInBackground{ (success,error) in
            if(success){
                print("Comment saved")
            }else{
                print("Error saving comment")
            }
        }
        
        commentsTable.reloadData()
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row<comments.count){
            let cell = commentsTable.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row]
            
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            let imageFile = user["ProfileImage"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.profileImageView.af_setImage(withURL: url)
            
            
            return cell
        
        } else {
            let cell = commentsTable.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(indexPath.row == comments.count){
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
