//
//  FeedVC.swift
//  SocialNetwork
//
//  Created by Radu Dominte on 05/02/17.
//  Copyright © 2017 Radu Dominte. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var captionField: CustomField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    
    var imageSelected = false
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post, img: image)
                return cell
            }else{
                
                // the func declared in PostCell has 2 parameters the image parameter is set = to nil, in that case when you use that function and you
                // do not have a value to pass to the image parameter you need to set just the first parameter like in the fun below, the image parameter
                // can be erased and will be nil by default...  func configureCell(post: Post, img: UIImage? = nil) {
                cell.configureCell(post: post)
                return cell
            }
            
        }else{
            return PostCell()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
            imageSelected = true
        }else{
            print("RADU: A valid image wasn't selected")
        }

        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            
            print("RADU: Cption must be entered")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            
            print("RADU: An image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            
            //sets an unique ID string
            let imgUid = NSUUID().uuidString
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imageData, metadata: metadata) { (metadata, error) in
             
                if error != nil {
                    
                    print("RADU: Unable upload image to Firebase storage")
                }else{
                    
                    print("RADU: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString               
                }
            }
        }
    }

    
    @IBAction func signOutButton(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("RADU: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}
