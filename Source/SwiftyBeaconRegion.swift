//
//  BeaconRegion.swift
//  iBeaconDemo
//
//  Created by Fedya Skitsko on 11/21/14.
//  Copyright (c) 2014 LabWerk. All rights reserved.
//

import Foundation
import CoreLocation

public extension CLRegionState {
    func toString() -> String {
        switch self {
            case .inside:
                return "Inside"
            case .outside:
                return "Outside"
            case .unknown:
                return "Unknown"
        }
    }
}

public extension CLBeaconRegion {
    static func identifier(proximityUUID proximityUUID: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) -> String {
        return "\(proximityUUID.uuidString)_\(major)_\(minor)"
    }
}

public extension CLBeacon {
    static func identifier(proximityUUID proximityUUID: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) -> String {
        return "\(proximityUUID.uuidString)_\(major)_\(minor)"
    }
}

public typealias RegionRangeHandler = ([CLBeacon]) -> Void
public typealias RegionStateHandler = (CLRegionState) -> Void

public typealias BeaconHandler = (CLBeacon) -> Void

public class SwiftyBeaconRegion: CLBeaconRegion {
    
    public var rangeHandler: RegionRangeHandler?
    public var stateHandler: RegionStateHandler?
    
    public var rangeBeaconHandler: BeaconHandler?
    public var unrangeBeaconHandler: BeaconHandler?
    
    public internal (set) var rangedBeacons = [CLBeacon]()
    
    public override var description: String {
        return "\(proximityUUID.uuidString)-\(major)-\(minor)"
    }
    
    public override var debugDescription: String {
        return description
    }
    
    override private init(proximityUUID: UUID, identifier: String) {
        super.init(proximityUUID: proximityUUID, identifier: identifier)
        defaultValues()
    }
    
    override private init(proximityUUID: UUID, major: CLBeaconMajorValue, identifier: String) {
        super.init(proximityUUID: proximityUUID, major: major, identifier: identifier)
        defaultValues()
    }
    
    override private init(proximityUUID: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        super.init(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
        defaultValues()
    }
    
    public convenience init(proximityUUID: UUID, major: CLBeaconMajorValue? = nil, minor: CLBeaconMinorValue? = nil) {
        let identifier = CLBeaconRegion.identifier(proximityUUID: proximityUUID, major: major ?? 0, minor: minor ?? 0)
        
        if let minor = minor {
            self.init(proximityUUID: proximityUUID, major: major!, minor: minor, identifier: identifier)
        } else if let major = major {
            self.init(proximityUUID: proximityUUID, major: major, identifier: identifier)
        } else {
            self.init(proximityUUID: proximityUUID, identifier: identifier)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultValues()
    }
    
    func defaultValues() {
        notifyEntryStateOnDisplay = true
        notifyOnEntry = true
        notifyOnExit = true
    }
}
