//
//  SignInVC.swift
//  SocialNetwork
//
//  Created by Radu Dominte on 28/01/17.
//  Copyright © 2017 Radu Dominte. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper



class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: CustomField!
    @IBOutlet weak var passwordField: CustomField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("RADU: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                
                print("RADU: User cancelled Facebook authentication")
            } else {
                
                print("RADU: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user,error) in
        
            if error != nil {
                
                print("RADU: Unable to authenticate with Firebase")
            } else {
                
                print("RADU: Successfully authenticated with Firebase")
                
                if let user = user {
                    
                    self.completeSignIn(id: user.uid)
                    
                }
            }
        })
    }
    
    
    @IBAction func signInTapped(_ sender: UIButton) {
        
        if let email = emailField.text, let password = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
                if error == nil {
                    
                    print("RADU: Email user authenticated with Firebase")
                    
                    if let user = user {
                        
                        self.completeSignIn(id: (user.uid))
                    }
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error == nil {
                            
                            print("RADU: Email user authenticated with Firebase using email")
                        } else {
                            
                            print("RADU: Successfully authenticated with Firebase")
                            
                            if let user = user {
                                
                                self.completeSignIn(id: (user.uid))
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func completeSignIn(id: String) {
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        print("Radu: Data saved to Keychain \(keychainResult)")
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }


}

