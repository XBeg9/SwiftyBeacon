//
//  SwiftyBeaconTests.swift
//  SwiftyBeaconTests
//
//  Created by Fedya Skitsko on 11/23/14.
//  Copyright (c) 2014 Skitsko. All rights reserved.
//

import Quick
import Nimble
import SwiftyBeacon

class SwiftyBeaconRegionTests: QuickSpec {
    override func spec() {
        var region: SwiftyBeaconRegion?
        beforeEach {
            region = SwiftyBeaconRegion(proximityUUID: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        }
        
        it("should init defaults") {
            expect(region?.notifyEntryStateOnDisplay).to(beTruthy())
        }
    }
}
