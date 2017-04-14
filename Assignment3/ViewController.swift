//
//  ViewController.swift
//  Assignment3
//
//  Created by Sagar Kumar on 4/14/17.
//  Copyright © 2017 PurpleHawlk. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x:16, y: 50, width: view.frame.width - 32, height: 50)
        // Do any additional setup after loading the view, typically from a nib.
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if error != nil{
            print(error)
            return
            
        } else{
            print("SuccessFully logged in with facebook...")
            showEmailAddress()
        }
    }
    
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print("loged out")
    }
    
    @IBAction func faceBookLogin(_ sender: UIButton) {
        print("working dine")
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile","email" ], from: self) { (result, error) in
            if error != nil{
                    print("Failed", error)
                    return
                }
            self.showEmailAddress()
        }
        
    }
    
    func showEmailAddress(){
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else{return}
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                print("Something went wrong with our FB user: ", error ?? "")
                return
            } else{
                print("Successfully logged in with our user: ", user ?? "")
            }
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) in
            if error != nil{
                print("Failed to start graph request:", error)
                return
            }
            print(result!)
            

        })
    }
    
    
    
    @IBAction func checkIn(_ sender: UIButton) {
        performSegue(withIdentifier: "moveSegue", sender: nil)
    }
    
}




