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
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var lastUpdateTimeLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    
    
    private var showMore = false
    private var detailMod = false
    private var locationManager: CLLocationManager = CLLocationManager()
    fileprivate var lastLocations = [LocationClass]()
    private var isFirstEnter: Bool = true
    var lastCheckedUser: UserClass? = nil
    let geocoder = CLGeocoder()
    var locationArray = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerMap()
        registerLocationManager()
        setDefaultSliderInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showFriendsOnMap()
    }
    
    
    private func registerLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func registerMap(){
        self.map.delegate = self
        map.showsUserLocation = true
    }
    
    func showFriendsOnMap(){
        getFollowers(callback: {users in
            for user in users{
                self.addUserOnMap(user: user)
            }
        })
    }
    
    func updateSliderInfo(user: UserClass){
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        lastUpdateTimeLabel.text = ApiManager.makeUnixTimeReadble(time: Int(ApiManager.getUnixTime())!)
        lastCheckedUser = user
        if user.id == ApiManager.me.id{
            chatButton.isEnabled = false
            followButton.isEnabled = false
        }else{
            chatButton.isEnabled = true
            followButton.isEnabled = true
        }
    }
    
    func setDefaultSliderInfo(){
        updateSliderInfo(user: ApiManager.me)
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
    
    @IBAction func unfollowButtonPressed(_ sender: Any) {
        ApiManager.unfollowRequest(token: ApiManager.myToken, user_id: lastCheckedUser!.id, callback: {
            resultCode in
            if resultCode == "0"{
                self.map.removeAnnotations(self.map.annotations)
                self.showFriendsOnMap()
                self.setDefaultSliderInfo()
            }
        })
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
        UpperSwitcher.sendActions(for: .valueChanged)
    }
    
    @IBAction func HideDetailMod(_ sender: Any) {
        detailMod = false
        UIView.animate(withDuration: Double(0.333), animations: {
            self.UpperSwitcher.alpha = 0
            // equals disable. for test use 0.2
            self.buttonHideDetailMode.alpha = 0
            // equals disable. for test use 0.2
        })
        map.removeOverlays(map.overlays)
    }
    
    @IBAction func upperSwitcherValueChanged(_ sender: Any) {
        let timeBegin = "200000000000"
        let timeEnd = "2000000000000"
        let step = "10000"
        map.removeOverlays(map.overlays)
        switch UpperSwitcher.selectedSegmentIndex{
        case 0:
            ApiManager.getLocationHistoryOfUser(token: ApiManager.myToken,
                                                user_id: lastCheckedUser!.id,
                                                timeFrom: timeBegin,
                                                timeTo: timeEnd,
                                                step: step,
                                                callback: {resultCode, locations in
                                                    self.reloadRouteOnMap(locations: locations)
            })
        case 1:
            ApiManager.getLocationHistoryOfUser(token: ApiManager.myToken,
                                                user_id: lastCheckedUser!.id,
                                                timeFrom: timeBegin,
                                                timeTo: timeEnd,
                                                step: step,
                                                callback: {resultCode, locations in
                                                    self.reloadRouteOnMap(locations: locations)
            })
        case 2:
            ApiManager.getLocationHistoryOfUser(token: ApiManager.myToken,
                                                user_id: lastCheckedUser!.id,
                                                timeFrom: timeBegin,
                                                timeTo: timeEnd,
                                                step: step,
                                                callback: {resultCode, locations in
                                                    self.reloadRouteOnMap(locations: locations)
            })
        default:
            return
        }
    }
    
    
    func reloadRouteOnMap(locations: [LocationClass]){
        for loc in 0 ..< (locations.count - 1){
            let location1 = CLLocationCoordinate2D(latitude: Double(locations[loc].lat!)!, longitude: Double(locations[loc].lon!)!)
            let location2 = CLLocationCoordinate2D(latitude: Double(locations[loc + 1].lat!)!, longitude: Double(locations[loc + 1].lon!)!)
            let area = [location1, location2]
            let polyline = MKPolyline(coordinates: area, count: area.count)
            map.add(polyline)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer  {
        if overlay is MKPolyline{
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            if (overlay is MKPolyline) {
                    polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.5)
                polylineRenderer.lineWidth = 5
            }
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }

    
    func ShowMoreAction () {
        UIView.animate(withDuration: Double(0.333), animations: {
            if self.showMore {
                self.UpperButton.setTitle("Choose the user", for: .normal)
                self.UpSwitcher.constant = 25;
                self.UpButtonHide.constant = 25;
                self.customC.constant = -260
                self.map.alpha = 1
                self.MVRight.constant = 10
                self.MVLeft.constant = 10
                self.MVUp.constant = -40
            } else {
                self.UpperButton.setTitle("Hide", for: .normal)
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
        ApiManager.createChat(with: lastCheckedUser!, callback: {chatView in
            let chatNavigationController = UINavigationController(rootViewController: chatView)
            self.present(chatNavigationController, animated: true, completion: nil)

        })
    }
    
    func addUserOnMap(user: UserClass){
        map.addAnnotation(UserAnnotation(user: user))
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
        
        if let an = view.annotation as? UserAnnotation{
            updateSliderInfo(user: an.user)
            self.UpperButton.sendActions(for: .touchUpInside)
        }
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func setRegionAndSpan(){
        map.showAnnotations(map.annotations, animated: true)
    }

    func getFollowers(callback: @escaping (_ followers: [UserClass]) -> Void){
        ApiManager.getFollowed(token: ApiManager.myToken,
                                callback: {resultCode, requests in
                                    var followers = [UserClass]()
                                    for request in requests{
                                        ApiManager.getUserById(token: ApiManager.myToken, id: request, callback: {
                                            resultCode, user in
                                            if resultCode == "0"{
                                                //followers.append(user)
                                                ApiManager.getLastLocationOfUser(token: ApiManager.myToken,
                                                                                 user_id: request, callback: {
                                                                                    resultCode, location in
                                                                                    if resultCode == "0"{
                                                                                        user.lat = (location?.lat)!
                                                                                        user.lon = (location?.lon)!
                                                                                        followers.append(user)
                                                                                        if followers.count == requests.count{
                                                                                            callback(followers)
                                                                                        }
                                                                                    }
                                                })
                                            }
                                        })
                                        
                                    }
        })
    }

}

