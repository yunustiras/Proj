//
//  ViewController.swift
//  sensors
//
//  Created by edex on 26.10.2019.
//  Copyright © 2019 ytu. All rights reserved.
//

import UIKit
import Alamofire
import Sensors
import SwiftyJSON


class ViewController: UIViewController, UITextFieldDelegate {
    
  
    let url = "http://192.168.1.38:8888/test.php"

    var timer : Timer? = nil {
       willSet {
           timer?.invalidate()
       }
    }
  
    var sensors = Sensors()
    var sending = false
  
  var enAcc: Bool = true
    var enGyro: Bool  = true
    var enMag: Bool  = true
    var enMotion: Bool  = true
  
  
    override func viewDidLoad() {
      super.viewDidLoad()

      view.backgroundColor = UIColor(red: 8.0/255, green: 102.0/255, blue: 168.0/255, alpha: 1.0)
      self.hideKeyboardWhenTappedAround()

      urlTF.delegate = self
      intervalTF.delegate = self

      view.addSubview(urlTF)
      view.addSubview(intervalTF)
      intervalTF.addSubview(tralingLbl)
      view.addSubview(startButton)
      
      view.addSubview(sw1)
      sw1.addSubview(sw1Label)
      
      view.addSubview(sw2)
      sw2.addSubview(sw2Label)
      
      view.addSubview(sw3)
      sw3.addSubview(sw3Label)
      
      view.addSubview(sw4)
      sw4.addSubview(sw4Label)

      setupLayout()
    }

  
  
    // ---------------- action ----------------
    @objc func buttonAction(sender: UIButton!) {
      if(!sending){
        startButton.backgroundColor = .green
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitle("Stop Sending", for: .normal)
        sending = !sending
        startProcess()
      }else{
        startButton.backgroundColor = .purple
        startButton.setTitleColor(.white, for: .normal)
        startButton.setTitle("Start Sending", for: .normal)
        sending = !sending
        stopProcess()
      }
    }
  
  
    
    //  ----------------   ----------------
    func startProcess(){
      var interval: Double
      if let i = Double(intervalTF.text!){
          interval = i
       } else {interval = 4.0}
      sensors.startAll(interval: interval) // stop
      timer = Timer.scheduledTimer(
        timeInterval: interval,
        target: self,
        selector: #selector(self.getSend),
        userInfo: nil,
        repeats: true
      )
    }
  
  
    //  ----------------   ----------------
    func stopProcess(){
      sensors.stopAll()
      timer = nil
    }
    
  
  
    // ---------------- get fresh values and post ----------------
    @objc func getSend() {
      
      var params: [String: Any] = [:]
      
      params["uuid"] = UIDevice.current.identifierForVendor?.uuidString
      params["timestamp"] = Date.currentTimeStamp
      params["sensors"] = JSON(sensors.getValues(enAcc: enAcc, enGyro: enGyro, enMag: enMag, enMot: enMotion))

      let finalUrl = urlTF.text ?? url
     
      Alamofire.request(finalUrl,  method: .post, parameters: params).responseString { response in
        if let res = response.result.value {
          print(res)
        }
      }
    }
  
  
  
  
  @objc func switchStateDidChangeAcc(_ sender:UISwitch){
    enAcc = sender.isOn
    print("ACC is \(enAcc)")
  }
  
  @objc func switchStateDidChangeGyro(_ sender:UISwitch){
    enGyro = sender.isOn
    print("GYRO is \(enGyro)")
  }
  
  @objc func switchStateDidChangeMag(_ sender:UISwitch){
    enMag = sender.isOn
    print("MAG is \(enMag)")
  }
  
  @objc func switchStateDidChangeMot(_ sender:UISwitch){
    enMotion = sender.isOn
    print("MOTION is \(enMotion)")
  }
  
  
 

    
    // --------------------- setup auto layout ------------------------
    func setupLayout(){
      urlTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      urlTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
      urlTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
      urlTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
      urlTF.heightAnchor.constraint(equalToConstant: 50).isActive = true

      intervalTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      intervalTF.topAnchor.constraint(equalTo: urlTF.bottomAnchor, constant: 20).isActive = true
      intervalTF.widthAnchor.constraint(equalToConstant: 200).isActive = true
      intervalTF.heightAnchor.constraint(equalToConstant: 50).isActive = true

      tralingLbl.centerYAnchor.constraint(equalTo: intervalTF.centerYAnchor).isActive = true
      tralingLbl.topAnchor.constraint(equalTo: intervalTF.topAnchor).isActive = true
      tralingLbl.bottomAnchor.constraint(equalTo: intervalTF.bottomAnchor).isActive = true
      tralingLbl.trailingAnchor.constraint(equalTo: intervalTF.trailingAnchor, constant: -8).isActive = true

      startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      startButton.topAnchor.constraint(equalTo: intervalTF.bottomAnchor, constant: 20).isActive = true
      startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      startButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
      
      
      // ------------------
      sw1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      sw1.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 30).isActive = true
      sw1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
      
      sw1Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      // sw1Label.topAnchor.constraint(equalTo: startButton.bottomAnchor).isActive = true
      
      
      
      // ------------------
      sw2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      sw2.topAnchor.constraint(equalTo: sw1.bottomAnchor, constant: 30).isActive = true
      sw2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
      
      sw2Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      
      
      
      // ------------------
      sw3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      sw3.topAnchor.constraint(equalTo: sw2.bottomAnchor, constant: 30).isActive = true
      sw3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
      
      sw3Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      
      
      
      // ------------------
      sw4.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      sw4.topAnchor.constraint(equalTo: sw3.bottomAnchor, constant: 30).isActive = true
      sw4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
      
      sw4Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  
    }
    
    
    // -------------------- interval textview -------------------------
    let intervalTF: UITextField = {
     let txtField =  UITextField()
     txtField.text = "4"
     txtField.font = UIFont.boldSystemFont(ofSize: 18)
     txtField.borderStyle = UITextField.BorderStyle.roundedRect
     txtField.autocorrectionType = UITextAutocorrectionType.no
     txtField.keyboardType = UIKeyboardType.default
     txtField.textAlignment = .center
     txtField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
     txtField.translatesAutoresizingMaskIntoConstraints = false
     return txtField
    }()
  
  
    // -------------------- url textview -------------------------
    let urlTF: UITextField = {
      let txtField =  UITextField()
      txtField.text = "http://192.168.1.39:8888/test.php"
      txtField.font = UIFont.boldSystemFont(ofSize: 18)
      txtField.borderStyle = UITextField.BorderStyle.roundedRect
      txtField.autocorrectionType = UITextAutocorrectionType.no
      txtField.keyboardType = UIKeyboardType.default
      txtField.textAlignment = .center
      txtField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
      txtField.translatesAutoresizingMaskIntoConstraints = false
      return txtField
    }()
  
    // -------------------- trailing -------------------------
    let tralingLbl: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Seconds"
      label.textColor = .gray
      return label
    }()
       
     
    // -------------------- start button -------------------------
    let startButton: UIButton = {
      let button = UIButton()
      button.backgroundColor = .purple
      button.setTitle("Start Sending", for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
      button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false // enabling auto layout
      return button
    }()
    

    // -------------------- ACC Switch -------------------------
    let sw1: UISwitch = {
      let sw = UISwitch()
      sw.isOn = true
      sw.addTarget(self, action: #selector(ViewController.switchStateDidChangeAcc(_:)), for: .valueChanged)
      sw.setOn(true, animated: false)
      sw.translatesAutoresizingMaskIntoConstraints = false
      return sw
    }()
  
    // -------------------- GYRO Switch -------------------------
    let sw2: UISwitch = {
      let sw = UISwitch()
      sw.isOn = true
      sw.addTarget(self, action: #selector(ViewController.switchStateDidChangeGyro(_:)), for: .valueChanged)
      sw.setOn(true, animated: false)
      sw.translatesAutoresizingMaskIntoConstraints = false
      return sw
    }()
  
    // -------------------- MAG Switch -------------------------
    let sw3: UISwitch = {
      let sw = UISwitch()
      sw.isOn = true
      sw.addTarget(self, action: #selector(ViewController.switchStateDidChangeMag(_:)), for: .valueChanged)
      sw.setOn(true, animated: false)
      sw.translatesAutoresizingMaskIntoConstraints = false
      return sw
    }()
  
    // -------------------- MOTION Switch -------------------------
    let sw4: UISwitch = {
      let sw = UISwitch()
      sw.isOn = true
      sw.addTarget(self, action: #selector(ViewController.switchStateDidChangeMot(_:)), for: .valueChanged)
      sw.setOn(true, animated: false)
      sw.translatesAutoresizingMaskIntoConstraints = false
      return sw
    }()
  
   
    // --------------------  -------------------------
     let sw1Label: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.text = "Accelerometer"
       label.textColor = .black
       return label
     }()
  
  
    // --------------------  -------------------------
    let sw2Label: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Gyroscope"
      return label
    }()
    
    // --------------------  -------------------------
    let sw3Label: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Magnetometer"
      return label
    }()
    
    // --------------------  -------------------------
    let sw4Label: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Motion Data"
      return label
    }()
}



// -------------------- an helper extension to hide keyboard when touched on empty space --------------------
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}


extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}






