//
//  LocationManager.swift
//  WashingMachine
//
//  Created by zzh on 16/11/11.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import CoreLocation

//MARK: plist 需要加的东西
// NSLocationWhenInUseUsageDescription
// NSLocationAlwaysUsageDescription

typealias ComplainLocationClourse = ((LocationManager ,LocationResult) -> ())

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shareClient = LocationManager()
    
    fileprivate var locationManager: CLLocationManager!
    fileprivate var complainLocationClourse:ComplainLocationClourse?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if iPhoneSystem() >= 8.0 {
            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestAlwaysAuthorization()
        }
        
        // 设置每隔多少米定位一次
        locationManager.distanceFilter = 100
        // 设置定位精度
        locationManager.desiredAccuracy = 10
    }
    
    class func startUpdatingLocation(_ complainHandle: @escaping ComplainLocationClourse) {
        LocationManager.shareClient.startUpdatingLocation(complainHandle)
    }
    
    func startUpdatingLocation(_ complainHandle: @escaping ComplainLocationClourse) {
        self.complainLocationClourse = complainHandle
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("定位成功了")
        locationResult.isSuccess = true
        locationResult.location = locations.first
        callBack()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
        locationResult.isSuccess = false
        locationResult.location = nil
        callBack()
    }
    
    fileprivate func callBack() {
        if self.complainLocationClourse != nil {
            self.complainLocationClourse!(self ,locationResult)
        }
    }
    
    var locationResult:LocationResult = {
        return LocationResult()
    }()
    
    // 是否开启定位权限
    class func locationPermission() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            return false
        }
        return true
    }

}
