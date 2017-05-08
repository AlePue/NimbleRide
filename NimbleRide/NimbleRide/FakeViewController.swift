//
//  FakeViewController.swift
//  NimbleRide
//
//  Created by Nicholas Randhawa on 5/7/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import UIKit

class FakeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "feed", sender: (Any).self)
    }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


