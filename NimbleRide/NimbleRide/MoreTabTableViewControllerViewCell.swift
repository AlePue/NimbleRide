//
//  MoreTabViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 4/2/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

//import UIKit
//import FBSDKCoreKit
//
//class MoreTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    
//    let list = ["e", "em"]
//    
//    
//    @available(iOS 2.0, *)
//    
//     func tableView(_ tableView: UItableView, numberOfRowsInSection section: Int) -> Int {
//        return(list.count)
//    }
//    
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableView {
//        let cell = UITableViewCell(style: <#T##UITableViewCellStyle#>.default, reuseIdentifier: "cell")
//        cell.textLabel?.text = list[IndexPath.row]
//    }
//    
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            // Do any additional setup after loading the view, typically from a nib.
//        }
//        
//        override func didReceiveMemoryWarning() {
//            super.didReceiveMemoryWarning()
//            // Dispose of any resources that can be recreated.
//        }
//        
//        
//}
//    


import UIKit
import FBSDKCoreKit

class MoreTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let list = ["Milk", "Honey", "Bread", "Tacos", "Tomatoes"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        
        return(cell)
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
