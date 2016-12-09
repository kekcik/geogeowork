//
//  MapViewController.swift
//  GeoGeo
//
//  Created by Иван Трофимов on 19.10.16.
//  Copyright © 2016 Иван Трофимов. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnntotation: MKPointAnnotation {
    
}
class MapViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    var showMore = false;
    var detailMod = false;
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
    
    func addSomeUsers() {
        let an : MKPointAnnotation = MKPointAnnotation.init()
        let name = NSLocalizedString("ivan.trofimov", comment: "it's my name")
        an.title = name
        an.subtitle = "kokoko?"
        an.coordinate.latitude = 59.95672917
        an.coordinate.longitude = 30.31162262
        map.addAnnotation(an)
        map.region = .init(center: an.coordinate, span: .init(latitudeDelta: 1, longitudeDelta: 1))
    }
}

