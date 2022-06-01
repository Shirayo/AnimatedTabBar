//
//  ViewThree.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI
import MapKit
import CoreLocation
import PhotosUI

struct ViewThree: View {
    @State var openMapView = false
    @State var coordinates: CLLocation? = nil
    @StateObject var manager = LocationManager()
    @State var street = "street sample"
    @State var region = MKCoordinateRegion(
        center:  CLLocationCoordinate2D(
          latitude: 53.838758611097745,
          longitude:27.568495290623083
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.008,
          longitudeDelta: 0.008
       )
    )

    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("GradientTop"), Color("GradientBottom")], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Button {
                openMapView = true
            } label: {
                if let coordinates = coordinates {
                    Text("\(coordinates.coordinate.latitude), \(coordinates.coordinate.longitude)")
                } else {
                    Text("set location")
                }
            }
            .fullScreenCover(isPresented: $openMapView) {
                ZStack {
                    Map(coordinateRegion: $manager.region)
                        .ignoresSafeArea()
                    Image("Vector")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.red)
                        .padding(.bottom, 16)
                    VStack {
                        HStack {
                            Button {
                                openMapView = false
                            } label: {
                                Image(systemName: "arrowshape.turn.up.left.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: .center)
                            }.padding()
                            Spacer()
                        }
                        Spacer()
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "pin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
//                                Text("\(getAddressFromLatLon(pdblLatitude: String(manager.region.center.latitude), withLongitude: String(manager.region.center.longitude)))")
                                Spacer()
                            }
                            .padding(.horizontal)
                        
                            Button {
                                coordinates = .init(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude)
                                openMapView = false
                            } label: {
                                ZStack {
                                    Color("Selected")
                                    Text("Set Location")
                                        .foregroundColor(.white)
                                }.frame(height: 48)
                                    .cornerRadius(24)
                                    .padding(.horizontal)
                            }
                        }
                        .frame(height: 124)
                        .background(Color("PageIndicatorBackground"))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                }
                
            }
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            var streetName = ""

            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        streetName = addressString
                        print(addressString)
                  }
            })
            return streetName
        }
}


class LocationManager: NSObject,CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion()
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locations.last.map {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                )
            }
        }
    
}

struct ViewThree_Previews: PreviewProvider {
    static var previews: some View {
        ViewThree()
    }
}
