//
//  SwiftyBeaconManagerTests.swift
//  SwiftyBeacon
//
//  Created by Fedya Skitsko on 11/25/14.
//  Copyright (c) 2014 Skitsko. All rights reserved.
//

import Quick
import Nimble
import SwiftyBeacon

class SwiftyBeaconManagerTests: QuickSpec {
    override func spec() {
        var manager: SwiftyBeaconManager?
        beforeEach {
            manager = SwiftyBeaconManager()
        }
        
        it("should init location manager delegate") {
            expect(manager?.locationManager.delegate).notTo(beNil())
        }
        
        it("should init bluetooth manager delegate") {
            expect(manager?.bluetoothManager.delegate).notTo(beNil())
        }
        
        it("") {
            
        }
    }
}
