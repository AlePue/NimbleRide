//
//  RideViewController.swift
//  NimbleRide
//
//  Created by Nicholas Randhawa on 11/11/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import ReplayKit
import UIKit

class AccountViewController: UIViewController, RPPreviewViewControllerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    let recorder = RPScreenRecorder.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    @IBAction func record (_ sender: AnyObject){
        if (recorder.isRecording){
            recorder.stopRecording{ (preview, error) in
                
                if preview != nil{
                    preview?.previewControllerDelegate = self
                    self.present(preview!, animated: true, completion: nil)
                }
                else {
                    print("Error" + error!.localizedDescription)
                }
                
            }
            
            recordButton.setTitle("Record", for: .normal)
            recordButton.setTitleColor(UIColor.blue, for: .normal)
            recordButton.sizeToFit()
            recordButton.center.x = self.view.center.x
        }

        else{
            recorder.startRecording{(error) in
                if error != nil {
                    print("Error" + error!.localizedDescription)
                }
                else{
                    self.recordButton.setTitle("Stop Recording", for: .normal)
                    self.recordButton.setTitleColor(UIColor.red, for: .normal)
                    self.recordButton.sizeToFit()
                    self.recordButton.center.x = self.view.center.x
                }
            }
        }
    }

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
    }

}
