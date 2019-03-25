//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Yash Kakodkar on 3/13/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar

class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate, PostCellDelegate {
    
    @IBOutlet weak var feedTable: UITableView!
    
    var refreshControl: UIRefreshControl!
    var posts = [PFObject]()
    var selectedPost: PFObject!
    var numberOfPosts: Int!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.delegate = self
        feedTable.dataSource = self
        feedTable.keyboardDismissMode = .interactive
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        feedTable.insertSubview(refreshControl, at: 0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        numberOfPosts = 20
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = numberOfPosts
        query.findObjectsInBackground{(posts,error) in
            if(posts != nil){
                self.posts  = posts!
                self.feedTable.reloadData()
            }else {
                print("Error: \(String(describing: error))")
            }
        }
        
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
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground{ (success,error) in
            if(success){
                print("Comment saved")
            }else{
                print("Error saving comment")
            }
        }

        feedTable.reloadData()

        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
        
    }
    
    
    
    // Implement the delay method
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    @objc func onRefresh() {
        run(after: 2) {
            self.refreshControl.endRefreshing()
        }
    }
    
//    func loadMorePosts(){
//        if(self.posts.count>=numberOfPosts){
//            numberOfPosts+=20
//            let query = PFQuery(className:"Posts")
//            query.includeKeys(["author","comments", "comments.author"])
//            query.limit = numberOfPosts
//            query.findObjectsInBackground{(posts,error) in
//                if(posts != nil){
//                    self.posts  = posts!
//                    self.feedTable.reloadData()
//                }else {
//                    print("Error: \(String(describing: error))")
//                }
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
//        if(indexPath.row+1 == posts.count){
//            loadMorePosts()
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        // put in () ?? [] becuase it is an optional vlaue, can be nil
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if (indexPath.row == 0){
            
            let cell = feedTable.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            cell.delegate = self
            cell.setPost(post: post, comments: comments)
            
            return cell
        
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            let profileImageFile = user["ProfileImage"] as! PFFileObject
            let profileUrlString = profileImageFile.url!
            let profileUrl = URL(string: profileUrlString)!
            cell.profileImageView.af_setImage(withURL: profileUrl)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
        
        
        
    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        //self.performSegue(withIdentifier: "feedToComments", sender:dataobject )
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comments  = (post["comments"] as? [PFObject]) ?? []

        if(indexPath.row == comments.count+1){
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()

            selectedPost = post
        }


    }

    
    // MARK: - Navigation

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("loading data")
//
//        if(segue.identifier == "feedToComments"){
//        // Find the selected movie
//        let vc =  segue.destination as! CommentViewController
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)!
//        let movie = movies[indexPath.row]
//
//        detailsViewController.movie = movie
//
//        tableView.deselectRow(at: indexPath, animated: true)
//        }
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
    

    
    }
    

}
