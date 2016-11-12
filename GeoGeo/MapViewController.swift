//
//  MapViewController.swift
//  GeoGeo
//
//  Created by Иван Трофимов on 19.10.16.
//  Copyright © 2016 Иван Трофимов. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    var showMore = false;
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var MoreView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSomeUsers()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var Button: UIButton!
    
    @IBAction func SwipeShowMore(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.up && !showMore {
            ShowMoreAction()
        } else if sender.direction == UISwipeGestureRecognizerDirection.down && showMore {
            ShowMoreAction()
        }
    }
    
    @IBAction func HideView(_ sender: Any) {
        ShowMoreAction();
    }
    
    func ShowMoreAction () {
        for constraint in MainView.constraints {
            if (constraint.identifier == "bottonCon"){
                UIView.animate(withDuration: Double(0.3), animations: {
                    if self.showMore {
                        constraint.constant = -315
                        self.map.alpha = 1
                    } else {
                        constraint.constant = 0
                        self.map.alpha = 0.5
                    }
                    self.view.layoutIfNeeded()
                })
            }
        }
        self.map.isZoomEnabled = !self.map.isZoomEnabled
        self.map.isScrollEnabled = !self.map.isScrollEnabled
        showMore = !showMore
    }
    
    func addSomeUsers() {
        
//        let annotationView = MKAnnotationView()
//        let detailButton = UIButton.init(type: UIButtonType.detailDisclosure) as UIButton
//        annotationView.rightCalloutAccessoryView = detailButton

        let an : MKPointAnnotation = MKPointAnnotation.init()
        an.title = "ivan.trofimov"
        an.subtitle = "kokoko?"
        an.coordinate.latitude = 59.95672917
        an.coordinate.longitude = 30.31162262
        
        map.addAnnotation(an)
        map.region = .init(center: an.coordinate, span: .init(latitudeDelta: 1, longitudeDelta: 1))
    }
}

