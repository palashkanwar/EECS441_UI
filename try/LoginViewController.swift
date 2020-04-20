//
//  LoginViewController.swift
//  try
//
//  Created by Zhenyang gong on 4/20/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // constants
    let userDefault = UserDefaults.standard
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            email.text = "leongong@umich.edu"
            print(error.localizedDescription)
            return
        } else {
            email.text = "leongong@umich.edu"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if userDefault.bool(forKey: "usersignedin") {
//            performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
//        }
//    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("user created!")
                self.signInUser(email: email, password: password)
            } else {
                print(error?.localizedDescription)
            }
            
        }
    }
    
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("user signed in!")
                
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                //self.performSegue(withIdentifier: "Segue_To_Sig", sender: <#T##Any?#>)
            } else if (error?._code == AuthErrorCode.userNotFound.rawValue) {
                self.createUser(email: email, password: password)
            } else {
                print(error?.localizedDescription)
            }
            
        }
    }


}
