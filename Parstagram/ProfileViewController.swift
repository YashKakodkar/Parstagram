//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Yash Kakodkar on 3/24/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage


class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user = PFUser.current()!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = user["Name"] as? String
        self.title = name
        //nameLabel.text = name
        userNameLabel.text = user.username
        let profileImageFile = user["ProfileImage"] as! PFFileObject
        let profileUrlString = profileImageFile.url!
        let profileUrl = URL(string: profileUrlString)!
        profileImageView.af_setImage(withURL: profileUrl)
        profileImageView.layer.cornerRadius =  profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
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
