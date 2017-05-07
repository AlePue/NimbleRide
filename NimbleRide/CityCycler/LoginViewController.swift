//
//  LoginViewController.swift
//  CityCycler
//
//  Created by AlexZavala on 12/5/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var credentialsLabel: UILabel!

    @IBOutlet weak var passwordCredentials: UILabel!
    
    @IBAction func LoginButton(_ sender: UIButton) {
        self.Username.resignFirstResponder()
        self.Password.resignFirstResponder()
        
        let usr = Username.text
        let password = Password.text
        let usrEmailStored = UserDefaults.standard.string(forKey: "email");
        let passwordStored = UserDefaults.standard.string(forKey: "password");
        
        if(usrEmailStored == usr){
            if(passwordStored == password){
                //login sucessful
                UserDefaults.standard.set(true, forKey:"isUserLogin")
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true, completion: nil)
            }
            else{
                displayMyaAlertMessage(userMessage: "Unsucessful Login")
            }
        }
        
        //create a case if userEmailStored != usr
        if(usrEmailStored != usr){
            if(passwordStored != password){
            displayMyaAlertMessage(userMessage: "Unsucessful Login")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func displayMyaAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title: "Error", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        
        //LoginButton(UIButton)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
