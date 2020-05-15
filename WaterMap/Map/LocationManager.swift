//
//  LocationManager.swift
//  WaterMap
//
//  Created by 游宗諭 on 2020/5/15.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import Foundation

import CoreLocation

class MyLocationManager: CLLocationManager {
  static let global = MyLocationManager()
}

