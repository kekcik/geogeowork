//
//  MapViewController.swift
//  GeoGeo
//
//  Created by Иван Трофимов on 19.10.16.
//  Copyright © 2016 Иван Трофимов. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomPointAnntotation: MKPointAnnotation {
    
}


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet weak var map: MKMapView!
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var MoreView: UIView!
    @IBOutlet weak var customC: NSLayoutConstraint!
    @IBOutlet weak var MVRight: NSLayoutConstraint!
    @IBOutlet weak var MVLeft: NSLayoutConstraint!
    @IBOutlet weak var MVUp: NSLayoutConstraint!
    @IBOutlet weak var UpperSwitcher: UISegmentedControl!
    @IBOutlet weak var buttonHideDetailMode: UIButton!
    @IBOutlet weak var UpSwitcher: NSLayoutConstraint!
    @IBOutlet weak var UpButtonHide: NSLayoutConstraint!
    @IBOutlet weak var UpperButton: UIButton!
    @IBOutlet weak var Button: UIButton!
    
    
    private var showMore = false
    private var detailMod = false
    private var locationManager: CLLocationManager = CLLocationManager()
    fileprivate var lastLocations = [LocationClass]()
    private var isFirstEnter: Bool = true
    //private var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerMap()
        registerLocationManager()
        addSomeUsers()
//        ApiManager.getLastLocations(token: ApiManager.myToken,
//                                    user_id: ApiManager.myUserId,
//                                    callback: {resultCode, locations in
//        
//        })
    }
    
    
    private func registerLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func registerMap(){
        self.map.delegate = self
        map.showsUserLocation = true
    }


    @IBAction func SwipeShowMore(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.up && !showMore {
            ShowMoreAction()
        } else if sender.direction == UISwipeGestureRecognizerDirection.down && showMore {
            ShowMoreAction()
        }
    }
    
    @IBAction func HideView(_ sender: Any) {
        ShowMoreAction()
    }
    
    
    @IBAction func DetailMod(_ sender: Any) {
        detailMod = true
        UIView.animate(withDuration: Double(0.333), animations: {
            self.UpperSwitcher.alpha = 1
            // equals disable. for test use 0.2
            self.buttonHideDetailMode.alpha = 1
            // equals disable. for test use 0.2
        })
        ShowMoreAction()
    }
    
    @IBAction func HideDetailMod(_ sender: Any) {
        detailMod = false
        UIView.animate(withDuration: Double(0.333), animations: {
            self.UpperSwitcher.alpha = 0
            // equals disable. for test use 0.2
            self.buttonHideDetailMode.alpha = 0
            // equals disable. for test use 0.2
        })
    }
    
    func ShowMoreAction () {
        UIView.animate(withDuration: Double(0.333), animations: {
            if self.showMore {
                
                self.UpSwitcher.constant = 25;
                self.UpButtonHide.constant = 25;
                
                self.customC.constant = -260
                self.map.alpha = 1
                self.MVRight.constant = 10
                self.MVLeft.constant = 10
                self.MVUp.constant = -40
            } else {
                self.UpSwitcher.constant = -50;
                self.UpButtonHide.constant = -50;
                self.customC.constant = 0
                self.map.alpha = 0.5
                self.MVRight.constant = 0
                self.MVLeft.constant = 0
                self.MVUp.constant = 0
            }
            self.view.layoutIfNeeded()
        })
        map.isZoomEnabled = !map.isZoomEnabled
        map.isScrollEnabled = !map.isScrollEnabled
        showMore = !showMore
    }
    
    
    internal func locationManager(_ manager: CLLocationManager,
                                  didFailWithError error: Error) {
        print("error: ", error)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        if isFirstEnter{
            isFirstEnter = false
            firstLocation(location: mostRecentLocation)
        }
        lastLocations.append(LocationClass(lat: "\(mostRecentLocation.coordinate.latitude)",
                                   lon: "\(mostRecentLocation.coordinate.longitude)",
                                   accuracy: "3.0", createdAt: nil))
        ApiManager.setLocationPoint(token: ApiManager.myToken, location: lastLocations.last!,
                                    callback: {resultCode in
//                                        print(resultCode)
                                        if resultCode != "0"{
                                            self.showAlert(title: "Error", message: "Something went wrong with sending data")
                                        }})
    }
    
    private func firstLocation(location: CLLocation){
        let span = MKCoordinateSpanMake(100, 100)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        map.setRegion(region, animated: true)
    }

    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func gotoChatButtonPressed(_ sender: Any) {
        let chatView = ChatViewController()
//        ApiManager.getDialogWithUser(token: ApiManager.myToken,
//                                     user_id: "1006",
//                                     count: "100",
//                                     offset: "0",
//                                     callback: {resultCode, messages in})
        let chatNavigationController = UINavigationController(rootViewController: chatView)
        present(chatNavigationController, animated: true, completion: nil)
    }
    
    func addSomeUsers() {
        let an : MKPointAnnotation = MKPointAnnotation.init()
        let name = NSLocalizedString("ivan.trofimov", comment: "it's my name")
        an.title = name
        an.subtitle = "kokoko?"
        an.coordinate.latitude = 59.95672917
        an.coordinate.longitude = 30.31162262
        map.addAnnotation(an)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let view = MKPinAnnotationView()
//        view.annotation = annotation
//        return view
//    }
    
    
    internal func mapView(_ mapView: MKMapView,
                          didSelect view: MKAnnotationView){
        if view.annotation is MKUserLocation{
            return
        }
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func setRegionAndSpan(){
        map.showAnnotations(map.annotations, animated: true)
    }


}

