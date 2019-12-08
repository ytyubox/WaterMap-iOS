//
//  ContentView.swift
//  WaterMap
//
//  Created by 游宗諭 on 2019/12/6.
//  Copyright © 2019 游宗諭. All rights reserved.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
	let view = MKMapView(frame: .zero)
	func updateUIView(_ view: MKMapView, context: Context){
		print(#function)
		updateAnnotations(from: view)
	}
	
	private func updateAnnotations(from mapView: MKMapView) {
		mapView.removeAnnotations(mapView.annotations)

		let newAnnotations = WaterMapViewModel.shared.landmarks
		mapView.addAnnotations(newAnnotations)
		
	}
	/**
	- Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
	*/
	func makeUIView(context: Context) -> MKMapView{
		let coordinate = CLLocationCoordinate2D(latitude: 25.0003133, longitude: 121.5388148)
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		view.delegate = context.coordinator
		view.setRegion(region, animated: true)
		WaterMapViewModel.shared.view = view
		return view
		
	}
	
	func makeCoordinator() -> MapViewCoordinator {
		MapViewCoordinator(self)
	}
}
