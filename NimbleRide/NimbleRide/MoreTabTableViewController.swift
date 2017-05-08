//
//  MoreTabTableViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 4/23/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//


import UIKit
import FBSDKCoreKit

class MoreTabTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let list = ["Profile", "Settings", "Invite More Friends", "Pair to E-Bike"]
    var myIndex = 0
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreTabViewControllerViewCell
        cell.myLabel.text = list[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return (cell)

    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myIndex = indexPath.row
        debugPrint("\(myIndex)")
        if(myIndex == 0){
        performSegue(withIdentifier: "Profile", sender: self)
        } else if (myIndex == 1) {
        performSegue(withIdentifier: "Settings", sender: self)
        } else if (myIndex == 2) {
        performSegue(withIdentifier: "InviteFriends", sender: self)
        } else if (myIndex == 3) {
        performSegue(withIdentifier: "Pair", sender: self)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
