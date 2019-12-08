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

class WaterMapViewModel {
	static let shared = WaterMapViewModel()
	private init() {
		load()
		//		storeCancellable = store()
	}
	
	
	private var fetchCancellable:Cancellable?
	private var storeCancellable:Cancellable?
	var landmarks:[LandmarkAnnotation] = [] {
		didSet {
			DispatchQueue.main.async {
				self.view?.removeAnnotations(self.view?.annotations ?? [])
				self.view?.addAnnotations(self.landmarks)
			}
		}
	}
	@FetchRequest(entity: Landmark.entity(),
				  sortDescriptors: [])
	var coreDataLandmarks:FetchedResults<Landmark>
	@Environment(\.managedObjectContext) var cd
	unowned var view:MKMapView?
	
	private func load() {
		fetchCancellable = Overpass
			.publisher
			.map{
				let s = $0.elements.compactMap{
					return LandmarkAnnotation(title: $0.id.description,
											  subtitle: $0.description,
											  lat: $0.lat, lon: $0.lon)
					
				}
				return s
		}
		.assertNoFailure()
			//		.receive(on: RunLoop.main)
			.assign(to: \.landmarks, on: self)
	}
	//	private func store()->Cancellable {
	//		$landmarks.sink{_ in}
	//
	//	}
}

