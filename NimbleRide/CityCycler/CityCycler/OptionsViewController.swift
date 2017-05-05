//
//  OptionsViewController.swift
//  CityCycler
//
//  Created by AlexZavala on 12/5/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var difficultyLabel: UITextField!
    
    
    @IBAction func goPlay(_ sender: Any) {
//        let difficultySpeed = UserDefaults.standard.integer(forKey: "difficulty")
        self.difficultyLabel.resignFirstResponder()
        
        let difficulty = difficultyLabel.text
        
        if Int(difficulty!)! > 3 || Int(difficulty!)! < 1{
            //UserDefaults.standard.set(true, forKey: "isUserLogin")
            displayMyaAlertMessage(userMessage: "Need to select 1-3")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController : GameViewController = segue.destination as! GameViewController
        
        
        DestViewController.gameSpeed1 = Int(difficultyLabel.text!)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}



