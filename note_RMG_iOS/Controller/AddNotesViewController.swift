//
//  AddNotesViewController.swift
//  note_RMG_iOS
//
//  Created by Gurpreet Kaur on 22/09/21.
//

import UIKit
import CoreLocation
import MapKit
import Photos
import MobileCoreServices

class AddNotesViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var addedImage: UIImageView!
    @IBOutlet weak var recordAudioImg: UIImageView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var playAudioImage: UIImageView!
    
    
    var latitude  : Double?
    var longitude : Double?
    var image = Data()
    
    var isEdit = false
    
    var locationManager = CLLocationManager()
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    var mAudioFileName: String = ""
    
    var notes: NotesModel? {
        didSet {
            refreshUI()
        }
    }

    
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
    
    private func refreshUI() {
        loadViewIfNeeded()
        if self.notes != nil {
            self.titleTextField.text = notes?.title
            self.notesTextField.text = notes?.noteDesc
            self.latitude = notes?.latitude
            self.longitude = notes?.longitude
            self.image = notes!.image
            self.addedImage.image = UIImage.init(data: notes!.image)
            self.mAudioFileName = notes!.audioFileLocation
            if notes!.audioFileLocation != "" {
                playAudioImage.isHidden = false
                playAudioButton.isHidden = false
            }
        }
    }
    
    func save() {
        let createdDate = Date().toMillis()
        
        let model = NotesModel.init(title: titleTextField.text!, noteDesc: notesTextField.text!, createdDate: createdDate!, editedDate: Date().toMillis(), latitude: latitude ?? 0.0, longitude: longitude ?? 0.0, primaryKey: CurrentObject.sharedInstance.selectedSubject!.createdDate, image: self.image, audioFileLocation: self.mAudioFileName)
        CoreData().saveNote(entity: model)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func update() {
        let createdDate = notes?.createdDate
        
        let model = NotesModel.init(title: titleTextField.text!, noteDesc: notesTextField.text!, createdDate: createdDate!, editedDate: Date().toMillis(), latitude: latitude ?? 0.0, longitude: longitude ?? 0.0, primaryKey: CurrentObject.sharedInstance.selectedSubject!.createdDate, image: self.image, audioFileLocation: mAudioFileName)
        CoreData().updateNote(entity: model)
        self.stopLocationManager()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    @IBAction func openLocation(_ sender: Any) {
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController.init(title: "", message: "ATTACHMENTS", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction.init(title: "Camera", style: .default) { (alert) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                self.showAlert(title: "", message: kCameraError, buttonTitle: "OK")
                
            }
        }
        let galleryBtn = UIAlertAction.init(title: "Gallery", style: .default) { (alerty) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum)
            {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum;
                imagePicker.mediaTypes = ["public.image"]
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                self.showAlert(title: "", message: kCameraError, buttonTitle: "OK")
                
            }
        }
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cameraBtn)
        alert.addAction(galleryBtn)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func saveAction(_ sender: Any) {
        if titleTextField.text == "" {
            self.showAlert(title: "", message: kAddTitle, buttonTitle: kGlobalOK)
        }
        else if notesTextField.text == "" {
            self.showAlert(title: "", message: kAddNote, buttonTitle: kGlobalOK)
        }
        else {
            if isEdit {
                update()
            }
            else {
                save()
            }
        }
    }

}
