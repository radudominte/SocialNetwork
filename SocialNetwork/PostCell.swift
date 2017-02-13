//
//  PostCell.swift
//  SocialNetwork
//
//  Created by Radu Dominte on 06/02/17.
//  Copyright © 2017 Radu Dominte. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
        if img != nil {
            
            self.postImage.image = img
        }else{
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                
                if error != nil {
                    
                    print("RADU: Unable to download image from Firebase storadge")
                }else{
                    
                    print("RADU: Image downloaded from Firebase storage")
                    
                    if let imageData = data {
                        
                        if let img = UIImage(data: imageData) {
                            
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                        
                    }
                }
            })
        }
    }
    
}
