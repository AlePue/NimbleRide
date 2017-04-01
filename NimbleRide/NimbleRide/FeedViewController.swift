//
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        if !(AccountViewController.FBuser.firstName.isEmpty){
            let name = AccountViewController.FBuser.firstName + " " + AccountViewController.FBuser.lastName
            self.nameLabel.text = name + "'s Feed"
        }
    }
    
}

