//
//  PickPlaceLocation.swift
//  AnimatedTabBar
//
//  Created by Vasili on 6.06.22.
//

import SwiftUI
import MapKit

class LocationModel: Codable {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
    }
    
}

//class locationViewModel: ObservableObject {
//
//    @Published var location: LocationModel
//
//    @Published var mapLocation: LocationModel
//
//    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
////
////    init(loca) {
////
////    }
//
//}


struct PickPlaceLocation: View {
    
//    init() {
//        MKMapView.appearance().addGestureRecognizer(UIGestureRecognizer()
//    }
    
    @State private var mapRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: 40.83834587046632,
                        longitude: 14.254053016537693),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.03,
                        longitudeDelta: 0.03)
                    )
    
    var body: some View {
        let tap = DragGesture()
            .onChanged { value in
                print(value.location)
            }
            .onEnded { value in
                print("end: \(value.location)")
            }
            
        return Map(coordinateRegion: $mapRegion).ignoresSafeArea()
            .gesture(tap)
    }
}                                            

struct PickPlaceLocation_Previews: PreviewProvider {
    static var previews: some View {
        PickPlaceLocation()
    }
}
