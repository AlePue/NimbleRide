//

//  FeedViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 3/19/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import UIKit
import AWSDynamoDB
import MapKit

class FeedViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var feedMap: MKMapView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//        feedMap.setRegion(<#T##region: MKCoordinateRegion##MKCoordinateRegion#>, animated: <#T##Bool#>)
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
