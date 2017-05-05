//
//  MenuViewController.swift
//  CityCycler
//
//  Created by Alejandro Puente on 12/4/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var nameLabelText = String()
    
    @IBAction func PlayButton(_ sender: AnyObject) {
    
    }
    
    override func viewDidLoad() {
        
        nameLabel.text = nameLabelText
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func viewDidAppera(animated: Bool){
//        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLogin")
//        if(!isUserLoggedIn){
//            self.performSegue(withIdentifier: "loginView", sender: self)
//        }
//    }
    
}
