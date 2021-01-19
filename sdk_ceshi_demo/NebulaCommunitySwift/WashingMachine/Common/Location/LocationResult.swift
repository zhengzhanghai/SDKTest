//
//  LocationResult.swift
//  WashingMachine
//
//  Created by zzh on 16/11/11.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import CoreLocation

class LocationResult: NSObject {
    var isSuccess: Bool = false
    var location: CLLocation?
    
    func getAddress(_ address: ((CLPlacemark?) -> ())?) {
        
        guard let clLocation = location else {
            address?(nil)
            return
        }
        
        geocoder.reverseGeocodeLocation(clLocation, completionHandler: { (marks, error) in
            guard let placemarks = marks else {
                address?(nil)
                return
            }
            
            address?(placemarks.last)
        })

    }

    var altitude: CLLocationDistance {
        return location?.altitude ?? 0
    }
    
    /// 获取经纬度
    var coordinate2D: CLLocationCoordinate2D {
        return location?.coordinate ?? CLLocationCoordinate2D()
    }
    
    fileprivate lazy var geocoder:CLGeocoder = {
        return CLGeocoder()
    }()
}
