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

protocol canReceive {
    func passDataBack(data: Double)
}

class MoneySpentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, canReceiveAddress {
    @IBOutlet weak var receiptView: UIImageView!
    @IBOutlet weak var locationTxt: UITextField!
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
        if let spendingValue = Double(spendingTxt.text!) {
            if spendingValue <= 0 {
                warningLabel.text = "Please enter a valid number!"
            } else {
                warningLabel.text = ""
                delegate?.passDataBack(data: spendingValue)
                dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            warningLabel.text = "Please enter a valid number!"
        }
        // push data to database
        let ref = Database.database().reference()
        
        ref.child("claudia").childByAutoId().setValue(["amount":spendingTxt.text, "location":locationTxt.text])
        
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
    //******************************************//
    
    
}
extension MoneySpentViewController:ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        self.receiptView.image = image
    }
}
