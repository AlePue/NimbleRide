import UIKit
import CoreBluetooth

final class SerialViewController: UIViewController, UITextFieldDelegate, BluetoothSerialDelegate {

//MARK: IBOutlets
    
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!

//    var count = 0;
//MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init serial
        serial = BluetoothSerial(delegate: self)
        
        // UI
//        mainTextView.text = ""
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SerialViewController.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
    }
    
    func textViewScrollToBottom() {
        let range = NSMakeRange(NSString(string: mainTextView.text).length - 1, 1)
        mainTextView.scrollRangeToVisible(range)
    }
    

//MARK: BluetoothSerialDelegate
    
    func serialDidReceiveString(_ message: String) {
        // add the received text to the textView, optionally with a line break at the end
        
        //mainTextView.text! += "\(message)\n"
       
        
        let speed = RideViewController()
        let avg = speed.avgSpeed
        let fakeAvg: Double = 20
        let cadence1: Double = (1/60) * (5280/1) * (12/1)
        let cadence: Double = (1/82) * (fakeAvg)
        var cadenceTotal: Double = cadence * cadence1
        cadenceTotal = floor(cadenceTotal)
        var cadenceStringTotal = String(cadenceTotal)
        mainTextView.text! += "Cadence is \(cadenceStringTotal)\n"
        print("Cadence is \(cadenceTotal)")
        //(1 rev / 81.76") x (2000 miles / hour) x (1 hour / 60 minutes) x (5280 feet / 1 mile) x (12" / 1 foot) = 25,831.7 rev/min
//        let controller = RideViewController()
//        controller.cadenceLabel?.text = "hadhhsdifhsda"
//         textViewScrollToBottom()
        
        
        //let controller = PairingViewController()
        //controller.count += 2
        //print("this is count :  \(controller.count)" )
        //controller.checkCount()
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = "Disconnected"
        hud?.hide(true, afterDelay: 1.0)
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.mode = MBProgressHUDMode.text
            hud?.labelText = "Bluetooth turned off"
            hud?.hide(true, afterDelay: 1.0)
        }
}

//MARK: IBActions

    @IBAction func barButtonPressed(_ sender: AnyObject) {
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "ShowScanner", sender: self)
        } else {
            serial.disconnect()
            reloadView()
        }
    }
}
