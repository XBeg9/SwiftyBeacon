//
//  CustomStringConvertible.swift
//  Pods
//
//  Created by Dmitry Lavlinskyy on 1/5/17.
//
//

import Foundation
import CoreLocation

extension CLAuthorizationStatus: CustomStringConvertible {
    
    public var description: String {

        switch self {
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        }
    }
}

extension CLRegionState: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .inside:
            return "inside"
        case .outside:
            return "outside"
        case .unknown:
            return "unknown"
        }
        
    }
    
}
