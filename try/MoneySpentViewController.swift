//
//  MoneySpentViewController.swift
//  try
//
//  Created by Junyi Zhang on 3/11/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import CoreLocation
import MapKit
import FirebaseDatabase
import FirebaseStorage

protocol canReceive {
    func passDataBack(data: Double)
}

class MoneySpentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, canReceiveAddress {
    @IBOutlet weak var receiptView: UIImageView!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var warningLabel2: UILabel!
    var imagePicker:ImagePicker!
    func passDataBack(data: String) {
        locationTxt.text = "\(data)"
    }
    var delegate:canReceive?
    @IBOutlet weak var spendingTxt: UITextField!
    var spendingValueFinal = 0.00
    @IBOutlet weak var warningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapScreen" {
            let vc = segue.destination as! MapScreen
            vc.delegate = self
        }
        
    }
   
    // send data
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubmitClicked(_ sender: Any) {
        var pass = true
        if let spendingValue = Double(spendingTxt.text!) {
            if spendingValue <= 0 {
                warningLabel.text = "Please enter a valid number!"
                pass = false
            }
        }
        else {
            warningLabel.text = "Please enter a number."
            pass = false
        }
        if let text = locationTxt.text, text.isEmpty {
            warningLabel2.text = "Please enter a valid address!"
            pass = false
        }
        
        if pass {
            var spendingValue = Double(spendingTxt.text!) ?? 0
            warningLabel.text = ""
            warningLabel2.text = ""
            delegate?.passDataBack(data: spendingValue)
            
            // push data to database
            if receiptView.image == nil {
                let ref = Database.database().reference()
                ref.child("claudia").childByAutoId().setValue(["amount":self.spendingTxt.text, "location":self.locationTxt.text, "receipt_url":"", "attribute":"-"] as [String:Any])
            }
            else {
                // push image to storage
                var img_url = ""
                var file_name = randomString(length: 6)
                file_name = "claudia/" + file_name + ".png"
                let storageRef = Storage.storage().reference().child(file_name)
                let imgData = receiptView.image?.pngData()
                let metaData = StorageMetadata()
                metaData.contentType = "imge/png"
                storageRef.putData(imgData!, metadata: metaData) { (metadata, err) in
                    if err == nil{
                        print("error in save img")
                        storageRef.downloadURL(completion: { (url, error) in
                            if error != nil{
                                print("Failed to download url:", error!)
                                return
                            } else {
                                //Do something with url
                                print("success download url")
                                img_url = url?.absoluteString ?? ""
                                print(url!)
                                print(img_url)
                                // push data to database
                                let ref = Database.database().reference()
                                ref.child("claudia").childByAutoId().setValue(["amount":self.spendingTxt.text, "location":self.locationTxt.text, "receipt_url":img_url, "attribute":"-"] as [String:Any])
                            }
                        })
                    } else {
                        print("error in save image")
                    }
                }
            }
            // dismiss current window
            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func importImage(_ sender: UIButton) {
        self.imagePicker.present(from:sender)
    }
    

    //******************************************//
    
    // record number
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    var audioPlayer: AVAudioPlayer!
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
    }
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                if let path = Bundle.main.url(forResource: "test", withExtension: "m4a") {
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                    } catch {
                        print("Error!")
                    }
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request) {(result, error) in
                        if let error = error {
                            print("There was an error:\(error)")
                        } else {
                            self.spendingTxt.text = result?.bestTranscription.formattedString ?? "0"
                        }
                    }
                }
            }
        }
    }
    @IBAction func recordingBtn(_ sender: Any) {
        // show the spinner
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        
        requestSpeechAuth()
    }
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    //******************************************//
    
    
}
extension MoneySpentViewController:ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        self.receiptView.image = image
    }
}
