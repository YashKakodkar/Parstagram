//
//  PostCell.swift
//  
//
//  Created by Yash Kakodkar on 3/13/19.
//

import UIKit
import Parse
import AlamofireImage

protocol PostCellDelegate {
    func callSegueFromCell(myData dataobject: AnyObject)
}

class PostCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    var postItem: PFObject!
    var commentsItem: [PFObject]!
    var delegate: PostCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setPost(post: PFObject, comments: [PFObject]){
        postItem = post
        commentsItem = comments
        
        let user = post["author"] as! PFUser
        usernameLabel.text = user.username
        profileNameLabel.text = user.username
        
        //change
        let profileImageFile = user["ProfileImage"] as! PFFileObject
        let profileUrlString = profileImageFile.url!
        let profileUrl = URL(string: profileUrlString)!
        profilePicView.af_setImage(withURL: profileUrl)
        
        
        captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        photoView.af_setImage(withURL: url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onViewComments(_ sender: Any) {
        
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callSegueFromCell(myData: commentsItem as AnyObject)
        }
        let vc = CommentViewController(nibName: "CommentViewController", bundle: nil)
        print("hello: \(postItem != nil)")
        vc.comments = commentsItem
        vc.post = postItem
    
    }
    
}
