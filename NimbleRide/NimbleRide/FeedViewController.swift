//
<<<<<<< HEAD
//  feedViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 3/19/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import Foundation
import UIKit



class FeedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
=======
//  FeedViewController.swift
//  NimbleRide
//
//  Created by Nicholas Randhawa on 03/22/17.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import UIKit
import AWSDynamoDB

class FeedViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
>>>>>>> f62b6580673ae7711af8f1bf26dc20964d1452f8
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
<<<<<<< HEAD
    
    
}
=======

    override func viewWillAppear(_ animated: Bool) {
        if !(AccountViewController.FBuser.firstName.isEmpty){
            let name = AccountViewController.FBuser.firstName + " " + AccountViewController.FBuser.lastName
            self.nameLabel.text = name + "'s Feed"
        }
    }
    
}

>>>>>>> f62b6580673ae7711af8f1bf26dc20964d1452f8
