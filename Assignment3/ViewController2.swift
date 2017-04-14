//
//  ViewController2.swift
//  Assignment3
//
//  Created by Sagar Kumar on 4/14/17.
//  Copyright © 2017 PurpleHawlk. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController2: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    var array = Array<Model>()

    @IBOutlet weak var discription: UITextField!
    @IBOutlet weak var pickUplocationButton: UILabel!
    let imgPicController = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        imgPicController.delegate = self
        imageView.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2
        self.imageView.clipsToBounds = true
        imageView.isHidden = false
    }
    
    @IBAction func pickUpLocationButton(_ sender: UIButton) {
        locationManager.requestAlwaysAuthorization()
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined :
            print("notDetermined")
        //locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("restricted")
        //enableLocationHandling()
        case .denied:
            print("denied")
            showDialog(msg: "Enable location and give permission to get the current location.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("??????")
            getLocation()
        }
    }
    func getLocation(){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    print("Status: \(status)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print(locations.description)
        
        var locationValue = ""
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: locValue.latitude,longitude: locValue.longitude), completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                self.showDialog(msg: "Cant get the location.")
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                print(pm.locality!)
                locationValue = pm.locality!
            }else {
                print("Problem with the data received from geocoder")
            }
            
            if(locationValue == ""){
                self.showDialog(msg: "Cant get the location.")
            }else{
                
                manager.stopUpdatingLocation()
                print(locationValue)
                self.pickUplocationButton.text = locationValue
            }
        })
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //showDialog(msg: "Permission is not given.")
    }


    @IBAction func upDateButton(_ sender: UIButton) {
    }
    
    
    @IBAction func pickImage(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Profile Image", message: "Upload the profile image.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction!) in
            self.imgPicController.sourceType = .camera
            self.present(self.imgPicController, animated: true, completion: nil)
            
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action: UIAlertAction!) in
            self.imgPicController.sourceType = .photoLibrary
            self.present(self.imgPicController, animated: true, completion: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        //helps in type casting and same as if
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.imageView.image = selectedImage
        self.dismiss(animated: true, completion: nil)
        saveImageDocumentDirectory()
        
    }
    
    func saveImageDocumentDirectory(){
        let fileManager = FileManager.default
        let imageName = "\(CLong(NSDate().timeIntervalSince1970)).jpg"
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let image = imageView.image
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        let mod = Model()
        mod.location = pickUplocationButton.text!
        mod.image = imageName
        mod.discription = discription.text!
        array.append(mod)
    }
        
    func showDialog(msg: String){
            let alert = UIAlertController(title: "CRS", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
}
