    //
//  ViewController.swift
//  iBeaconDemo
//
//  Created by Fedya Skitsko on 11/21/14.
//  Copyright (c) 2014 LabWerk. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel?
    @IBOutlet weak var minorLabel: UILabel?
    
    let beaconManager = SwiftyBeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberLabel?.text = "Unknown"
        
        //@TODO please check also if Bluetooth is enabled

        beaconManager.authorizationStateHandler = { state in
            if state == .AuthorizedAlways || state == .AuthorizedWhenInUse {
                self.view.backgroundColor = UIColor.greenColor()
                
                let beaconRegion = SwiftyBeaconRegion(proximityUUID: NSUUID(UUIDString: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E")!, major: CLBeaconMajorValue(5555))
                
                beaconRegion.rangeHandler = { beacons in
                    let sortedBeacons = beacons.sort { $0.rssi > $1.rssi }.reverse() as [CLBeacon!]

                    for beacon in sortedBeacons {
                        if beacon.proximity != .Unknown {
                            self.minorLabel?.text = "\(beacon.minor)\n \(beacon.rssi)db"
                        }
                    }
                }
                
//                beaconRegion.stateHandler = { state in
//                    self.numberLabel?.text = state.toString()
//                }

                try! self.beaconManager.startMonitoringRegion(beaconRegion)
            } else {
                self.numberLabel?.text = "Disabled"
                self.minorLabel?.text = ""
                
                self.view.backgroundColor = UIColor.redColor()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

