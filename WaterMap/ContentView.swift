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
	func updateUIView(_ view: MKMapView, context: Context){
		let coordinate = CLLocationCoordinate2D(latitude: 25.0003133, longitude: 121.5388148)
		let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		landmarks.forEach{view.addAnnotation($0)}
		view.delegate = context.coordinator
		view.setRegion(region, animated: true)
	}
	let landmarks:[LandmarkAnnotation] = [
		.init(title: "蘇澳冷泉",
			  subtitle: "drinking_water",
			  coordinate: .init(latitude: 24.5985687,
								longitude: 121.850049))
	]
	/**
	- Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
	*/
	func makeUIView(context: Context) -> MKMapView{
		MKMapView(frame: .zero)
	}
	
	func makeCoordinator() -> MapViewCoordinator {
		MapViewCoordinator(self)
	}
}

class LandmarkAnnotation: NSObject, MKAnnotation {
	let title: String?
	let subtitle: String?
	let coordinate: CLLocationCoordinate2D
	init(title: String?,
		 subtitle: String?,
		 coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.subtitle = subtitle
		self.coordinate = coordinate
	}
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
	var mapViewController: MapView
	let data = try! Data(contentsOf: URL(string: "https://watermap.teia.tw/waterdrop.png")!)
	init(_ control: MapView) {
		self.mapViewController = control
	}
	
	func mapView(_ mapView: MKMapView,
				 viewFor annotation: MKAnnotation) -> MKAnnotationView?{
		//Custom View for Annotation
		let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
		annotationView.canShowCallout = true
		//Your custom image icon
		annotationView.image = UIImage(data: data)
		return annotationView
	}
}
