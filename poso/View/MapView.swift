//
//  MapView.swift
//  POSO
//
//  Created by 박희경 on 2023/11/15.
//

import SwiftUI
import MapKit

/// The custom object I am referring to
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

/// The delegate I am referring to
class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapViewController: MapView
    
    init(_ control: MapView) {
        self.mapViewController = control
    }
    
    func mapView(_ mapView: MKMapView, viewFor
                    annotation: MKAnnotation) -> MKAnnotationView?{
        // 마커 색상 설정
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        annotationView.markerTintColor = .black
        annotationView.glyphImage = UIImage(systemName: "car")
        annotationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100) // 설정하려는 크기로 조절
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.1) // Set the fill color of the circle
            circleRenderer.strokeColor = UIColor.red // Set the border color of the circle
            circleRenderer.lineWidth = 1 // Set the border width
            return circleRenderer
            }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    /// This is where the delegate gets the object for the selected annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedAnnotation = view.annotation as? LandmarkAnnotation {
//            self.selectedAnnotation = selectedAnnotation
//            isModalPresented = true
        }
    }
}


struct MapView: UIViewRepresentable {

    
    @ObservedObject var carStore: CarStore
    @ObservedObject var locationManager: LocationManager
    

//    init() {
//        convertedMarkers = cordToMark(locations: self.markers)
//    }
    
    func makeUIView(context: Context) -> MKMapView{
        let mapView = MKMapView(frame: .zero)
        return mapView
    }
    
    func cordToMark(locations: [CLLocationCoordinate2D]) -> [LandmarkAnnotation] {
        var marks: [LandmarkAnnotation] = []
        for cord in locations {
            let mark = LandmarkAnnotation(title: "MyCar", subtitle: "Sub", coordinate: cord)
            marks.append(mark)
        }
        return marks
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
        let latitude = carStore.latitude
        let longitude = carStore.longitude
        
        print("updateUIView lat: \(latitude), long: \(longitude)")
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude)
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = coordinate
        mapCamera.pitch = 10
        mapCamera.altitude = 3000
        view.camera = mapCamera
        view.mapType = .mutedStandard
        view.delegate = context.coordinator
        view.addAnnotations(carStore.convertedMarkers)
        
        // 기존의 overlay를 제거
        view.removeOverlays(view.overlays)
      
        // 새로운 overlay 추가
        let radiusCircle = MKCircle(center: CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude), radius: 300 as CLLocationDistance)
        view.addOverlay(radiusCircle)
        let locationCircle = MKCircle(center: CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude), radius: 3 as CLLocationDistance)
        view.addOverlay(locationCircle)
        
    }
    
    
}
