
//
//  UnitsViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 4/23/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import UIKit

class UnitsViewController: UIViewController {

    @IBOutlet weak var units: UILabel!
    
    @IBOutlet weak var unitValue: UISwitch!
    
    @IBAction func UnitSelection(_ sender: Any) {
        if unitValue.isOn {
            units.text = "Metric"
            unitValue.setOn(false, animated: true)
        } else {
            units.text = "Imperial"
            unitValue.setOn(true, animated: true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
