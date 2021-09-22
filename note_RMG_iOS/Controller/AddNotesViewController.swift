//
//  AddNotesViewController.swift
//  note_RMG_iOS
//
//  Created by Gurpreet Kaur on 22/09/21.
//

import UIKit
import CoreLocation

class AddNotesViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var addedImage: UIImageView!
    @IBOutlet weak var recordAudioImg: UIImageView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var playAudioImage: UIImageView!
    
    
    var latitude  : Double?
    var longitude : Double?
    
    var isEdit = false
    
    var locationManager: CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isEdit {
            self.title = "Edit note"
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            if let lat = locationManager.location?.coordinate.latitude {
                self.latitude = lat
                self.longitude = locationManager.location?.coordinate.longitude
             
            }
        }
    }
    
    
    
    
    
    
    @IBAction func openLocation(_ sender: Any) {
    }
    


}
