//
//  SignupViewController.swift
//  Parstagram
//
//  Created by Yash Kakodkar on 3/22/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius =  profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignupButton(_ sender: Any) {
    
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user["Name"] = nameField.text
        
        let imageData: Data!
        if(profileImageView.image != UIImage(named: "ProfilePicEdit")){
            imageData = profileImageView.image!.pngData()
        }else {
            let defaultProfilePic = UIImage(named: "DefaultProfilePic")
            imageData = defaultProfilePic!.pngData()
        }
        let file = PFFileObject(data: imageData!)
        user["ProfileImage"] =  file
        
        user.signUpInBackground {(success, error) in
            if(success){
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
            }else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        
    
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
    
        print("pressed")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width:100, height: 100)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        profileImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
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
