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
	@ObservedObject var vm:WaterMapViewModel
	
	func updateUIView(_ view: MKMapView, context: Context){
		print(#function,Date())
    view.showsUserLocation = true
		updateAnnotations(from: view)
    MyLocationManager.global.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    MyLocationManager.global.startUpdatingLocation()
    let location: CLLocationCoordinate2D = MyLocationManager.global.location!.coordinate
    let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
    let region = MKCoordinateRegion(center: location, span: span)
    view.setRegion(region, animated: true)
    
	}
	
  func resetToUserLocation() {
    let location = view.userLocation
    let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
    view.setRegion(region, animated: true)

  }
  
	private func updateAnnotations(from mapView: MKMapView) {
		mapView.removeAnnotations(mapView.annotations)

		let newAnnotations = vm.landmarks
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
    resetToUserLocation()
		return view
		
	}
	
	func makeCoordinator() -> MapViewCoordinator {
		MapViewCoordinator(self)
	}
}
