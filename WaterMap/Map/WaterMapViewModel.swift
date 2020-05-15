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

class WaterMapViewModel:ObservableObject {
	init() {
		load()
		//		storeCancellable = store()
	}
	
	
	private var fetchCancellable:Cancellable?
	private var storeCancellable:Cancellable?
	@Published var landmarks:[LandmarkAnnotation] = []
	@FetchRequest(entity: Landmark.entity(),
				  sortDescriptors: [])
	var coreDataLandmarks:FetchedResults<Landmark>
	@Environment(\.managedObjectContext) var cd
	
	private func load() {
		fetchCancellable =
			Overpass
				.publisher
				.map{
					let s = $0.elements.compactMap{
						return LandmarkAnnotation(title: $0.description,
                                      subtitle: $0.id.description,
												  lat: $0.lat, lon: $0.lon)
						
					}
					print(s.count, Date())
					return s
			}
			.assertNoFailure()
			.receive(on: RunLoop.main)
			.assign(to: \.landmarks, on: self)
	}
}

