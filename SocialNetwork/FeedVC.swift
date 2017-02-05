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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    @IBAction func signOutButton(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("RADU: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}
