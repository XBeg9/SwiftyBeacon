//
//  BeaconManager.swift
//  iBeaconDemo
//
//  Created by Fedya Skitsko on 11/21/14.
//  Copyright (c) 2014 LabWerk. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth

public enum SwiftyBeaconError: Error {
    case monitoringUnavailable
    case locationServiceUnathorized
    case locationServiceDisabled
    case bluetoothPoweredOff
}

public let SwiftyBeaconManagerDomain = "com.swiftybeaconmanager"

public typealias BeaconManagerAutorizationStateHandler = (CLAuthorizationStatus) -> Void
public typealias BeaconManagerBluetoothStateHandler = (CBCentralManagerState) -> Void

open class SwiftyBeaconManager: NSObject {
    // MARK: - Properties
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    lazy var bluetoothManager: CBCentralManager = {
        return CBCentralManager(delegate: self, queue: DispatchQueue.main, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }()
    
    open fileprivate(set) var regions = Set<SwiftyBeaconRegion>()
    
    open var log = defaultLog
    
    open var authorizationStateHandler: BeaconManagerAutorizationStateHandler?
    open var bluetoothStateHandler: BeaconManagerBluetoothStateHandler?
    
    fileprivate var hasAskedToSwitchOnBluetooth = false
    
    // MARK: - Init
    
    override public init() {
        super.init()
        
        if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") == nil { //check NSLocationWhenInUseUsageDescription
            if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") == nil { //if NSLocationAlwaysUsageDescription also nil, then drop fatalError
                fatalError("Please add NSLocationAlwaysUsageDescription OR NSLocationWhenInUseUsageDescription to your Info.plist file")
            }
        }
    }
    
    // MARK: - Public methods
    
    open func startMonitoringRegion(_ region: SwiftyBeaconRegion) throws {
        if !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        if !CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            throw SwiftyBeaconError.monitoringUnavailable
        }
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() != .authorizedAlways {
                throw SwiftyBeaconError.locationServiceUnathorized
            }
        } else {
            throw SwiftyBeaconError.locationServiceDisabled
        }
        
        if bluetoothManager.state != .poweredOn {
            if hasAskedToSwitchOnBluetooth {
                throw SwiftyBeaconError.bluetoothPoweredOff
            } else {
                bluetoothManager.scanForPeripherals(withServices: nil, options: nil)
                
                let delayTime = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.hasAskedToSwitchOnBluetooth = true
                }
            }
            return
        }
        
        if let index = regions.index(of: region) {
            let oldRegion = regions[index]
            oldRegion.stateHandler = region.stateHandler
            oldRegion.rangeHandler = region.rangeHandler
            locationManager.requestState(for: region)
        } else {
            regions.insert(region)
            locationManager.startMonitoring(for: region)
        }
    }
    
    open func stopMonitoringRegion(_ region: SwiftyBeaconRegion) {
        if regions.contains(region) {
            locationManager.stopMonitoring(for: region)
            regions.remove(region)
        }
    }
    
    open func stopMonitoringRegions() {
        for region in regions {
            locationManager.stopMonitoring(for: region)
            regions.remove(region)
        }
    }
    
    // MARK: - Private methods
    
    fileprivate func findBeaconRegion(_ region: CLRegion) -> SwiftyBeaconRegion? {
        for beaconRegion in regions {
            if beaconRegion.identifier == region.identifier {
                return beaconRegion
            }
        }
        
        return nil
    }
}

// MARK: - CBCentralManagerDelegate

extension SwiftyBeaconManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch bluetoothManager.state {
        case .poweredOn:
            for region in regions {
                locationManager.requestState(for: region)
            }
        default:
            for region in regions {
                locationManager.stopRangingBeacons(in: region)
            }
        }
        
        bluetoothStateHandler?(CBCentralManagerState(rawValue: bluetoothManager.state.rawValue)!)
    }
}

// MARK: - CLLocationManagerDelegate

extension SwiftyBeaconManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            for region in regions {
                locationManager.requestState(for: region)
            }
        }
        log(.debug) { "didChangeAuthorization: [\n\t\(status)\n]"}
        authorizationStateHandler?(status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        if let beaconRegion = findBeaconRegion(region) {
            
            log(.debug) { "didStartMonitoringFor: [\n\t\(beaconRegion)\n]"}
            locationManager.requestState(for: beaconRegion)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconRegion = findBeaconRegion(region) {
            log(.debug) { "didEnterRegion: [\n\t\(beaconRegion)\n]"}
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = findBeaconRegion(region) {
            log(.debug) { "didExitRegion: [\n\t\(beaconRegion)\n]"}
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if let beaconRegion = findBeaconRegion(region) {

            log(.debug) { "didDetermineState: [\n\t\(region) \n\tstate: \(state)\n]" }
            switch state {
            case .inside:
                locationManager.startRangingBeacons(in: beaconRegion)
                beaconRegion.stateHandler?(.inside)
            case .outside:
                locationManager.stopRangingBeacons(in: beaconRegion)
                beaconRegion.stateHandler?(.outside)
            case .unknown:
                beaconRegion.stateHandler?(.unknown)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beaconRegion = findBeaconRegion(region) {

            beaconRegion.rangeHandler?(beacons)
            handleBeaconsStatusChanges(beacons, forRegion: beaconRegion)
            log(.verbose) { "didRangeBeacons: [\n\t\(beacons)\n]" }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        if let region = region as? CLBeaconRegion, let beaconRegion = findBeaconRegion(region) {
            log(.error) { "monitoringDidFailFor: [\n\t\(beaconRegion) \n\terror: \(error)\n]" }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        if let beaconRegion = findBeaconRegion(region) {
            log(.error) { "rangingBeaconsDidFailFor: [\n\t\(beaconRegion) \n\terror: \(error)\n]" }
        }
    }
}

extension SwiftyBeaconManager {
    
    fileprivate func handleBeaconsStatusChanges(_ beacons: [CLBeacon], forRegion region: SwiftyBeaconRegion) {
        
        if region.rangedBeacons.count == 0
            && beacons.count == 0
            && region.unrangeBeaconHandler == nil
            && region.rangeBeaconHandler == nil { return }
        
        let currentlyRangedBeacons = beacons
        let handledBeacons = region.rangedBeacons
        
        let unrangedBeacons = handledBeacons.filter { !currentlyRangedBeacons.containsBeacon($0) }
        let newRangedBeacons = currentlyRangedBeacons.filter { !handledBeacons.containsBeacon($0) }
        
        if unrangedBeacons.count > 0 {
            
            unrangedBeacons.forEach { (beacon) in
                region.unrangeBeaconHandler?(beacon)
            }
            log(.info) { "Did unrange beacons: [\n" + "\(unrangedBeacons)" + "\n]" }
        }
        
        if newRangedBeacons.count > 0 {
            
            newRangedBeacons.forEach { (beacon) in
                region.rangeBeaconHandler?(beacon)
            }
            log(.info) { "Did unrange beacons: [\n" + "\(newRangedBeacons)" + "\n]" }
        }
        region.rangedBeacons = beacons
    }
}

extension Array where Element: CLBeacon {
    
    fileprivate func containsBeacon(_ beacon: CLBeacon) -> Bool {
        return filter { $0 == beacon }.first != nil
    }
}

func == (lhs: CLBeacon, rhs: CLBeacon) -> Bool {
    
    return lhs.proximityUUID == rhs.proximityUUID && lhs.major == rhs.major && lhs.minor == rhs.minor
}
