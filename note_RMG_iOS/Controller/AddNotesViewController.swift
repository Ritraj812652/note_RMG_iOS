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
    
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
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
            self.locationImg.isHidden = false
            self.locationButton.isHidden = false
        }
        
        startLocationManager()
        // Do any additional setup after loading the view.
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
        self.stopLocationManager()
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
        openMaps()
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
    
    @IBAction func addAudio(_ sender: Any) {
        if audioRecorder == nil
        {
            startRecording()
            recordAudioImg.image = UIImage.init(named: "stopRecording")
        } else
        {
            finishRecording(success: true)
            recordAudioImg.image = UIImage.init(named: "audio")
        }
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
    
    @IBAction func playRecording(_ sender: Any) {
        playAudio()
    }
    
    @IBAction func imageTapped(_ sender: UIButton) {
        let imageView = addedImage!
        if imageView.image == nil {
            return
        }
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func openMaps() {
        if latitude == 0.0 {
            self.showAlert(title: "", message: kNoLocation, buttonTitle: kGlobalOK)
            return
        }

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude!, longitude!)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Note saved location"
        mapItem.openInMaps(launchOptions: options)
}
}


// MARK: - UIImagePicker Delegate
extension AddNotesViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.fixOrientation()
            
            self.image = (image?.jpegData(compressionQuality: 1.0))!
            self.addedImage.image = UIImage.init(data: self.image)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: delegate for audio recording
extension AddNotesViewController: AVAudioRecorderDelegate
{
    func setupRecording()
    {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //                        self.loadRecordingUI()
                    } else {
                        print("not allowed")
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func startRecording() {
        mAudioFileName = randomString(length: 10) + ".m4a"
        let audioFilename = getDocumentsDirectory().appendingPathComponent(mAudioFileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        
        if success {
            print("success")
            playAudioImage.isHidden = false
            playAudioButton.isHidden = false
            
        } else {
            print("not success")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

//MARK: delegate for audio playing
extension AddNotesViewController: AVAudioPlayerDelegate
{
    func playAudio()
    {
        dump(audioRecorder)
        var error : NSError?
        do
        {
            var url: URL
//            if recordingIsAvailable
//            {
                url = getDocumentsDirectory().appendingPathComponent(mAudioFileName)
//            }
//            else
//            {
//                url = audioRecorder.url
//            }
            print(url)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            if let err = error{
                print("audioPlayer error: \(err.localizedDescription)")
            }else{
                audioPlayer.play()
            }
            audioPlayer.delegate = self
        }
        catch
        {
            print(error)
            
        }
        
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        print("Audio Play Decode Error")
    }
    
    
}

// MARK: delegate methods to handle user lcoation
extension AddNotesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            longitude = locations.last?.coordinate.longitude
            latitude = locations.last?.coordinate.latitude
    }
    
    func startLocationManager() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}


