//
//  WaterMapViewModel.swift
//  WaterMap
//
//  Created by 游宗諭 on 2019/12/8.
//  Copyright © 2019 游宗諭. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import MapKit
import CoreData

class WaterMapViewModel:ObservableObject {
    init() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Water")

        // 依 id 由小到大排序
        request.sortDescriptors =
          []//NSSortDescriptor(key: "id", ascending: true)]

        
            let results =
                try? AppDelegate.app.persistentContainer.viewContext.fetch(request) as! [Water]
        if let results = results,!results.isEmpty {
            viewInfo = results.map(\.viewInfo)
            return
        }
        load()
    }
    
    
    private var fetchCancellable:Cancellable?
    private var storeCancellable:Cancellable?
    @Published var viewInfo:[ViewInfo] = [] {
        didSet {
            for info in viewInfo {
                let water = Water(context: AppDelegate.app.persistentContainer.viewContext)
                water.set(i: info)
                try! AppDelegate.app.persistentContainer.viewContext.save()
            }
        }
    }
//    @Published var landmarks:[LandmarkAnnotation] = [] {
//        didSet {
//            print(#function)
//        }
//    }
    @FetchRequest(entity: Landmark.entity(),
                  sortDescriptors: [])
    var coreDataLandmarks:FetchedResults<Landmark>
    @Environment(\.managedObjectContext) var cd
    
    private func load() {
        fetchCancellable =
            Overpass
                .publisher
                .map(\.elements)
                .compactMap(ViewInfo.get)
            .assertNoFailure()
            .receive(on: RunLoop.main)
            .assign(to: \.viewInfo, on: self)
    }
}


extension Water {
    func set(i:ViewInfo) {
        self.brand = i.brand
        self.descriptions = i.description
        self.lat = i.lat
        self.lon = i.lon
        self.level = i.levelString
        self.name = i.name
        self.operators = i.operator
        self.waterStatus = i.waterStatus
    }
    var viewInfo:ViewInfo {
        ViewInfo(self)
    }
}

extension ViewInfo {
    init(_ i:Water) {
        self.brand = i.brand!
        self.description = i.descriptions!
        self.lat = i.lat
        self.lon = i.lon
        self.levelString = i.level!
        self.name = i.name!
        self.operator = i.operators!
        self.waterStatus = i.waterStatus!
    }
}
