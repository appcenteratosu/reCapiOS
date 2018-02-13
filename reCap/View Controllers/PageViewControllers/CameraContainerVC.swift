//
//  CameraContainerVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/6/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SwiftLocation

class CameraContainerVC: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var logoText: UIImageView!
    
    @IBOutlet weak var previewView: UIView!
    
    var portraitTopShadow: EdgeShadowLayer? = nil
    var portraitBotShadow: EdgeShadowLayer? = nil
    var landscapeTopShadow: EdgeShadowLayer? = nil
    var landscapeBotShadow: EdgeShadowLayer? = nil
    
    
    
    var imageToPass: UIImage?
    
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var photoSetting = AVCapturePhotoSettings()
    
    var captureDevice: AVCaptureDevice?
    
    let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        stillImageOutput?.capturePhoto(with: photoSetting, delegate: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupCamera()
        initializeShadow()
        configureButton()
        setupLocation()
        
        self.viewDidAppear(false)
        
        // Do any additional setup after loading the view.
    }
    
    
    public func setupCamera() {
        
        photoSetting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSetting.isAutoStillImageStabilizationEnabled = true
        photoSetting.flashMode = .off
        
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.high
        
        
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        try! backCamera?.lockForConfiguration()
        backCamera?.focusMode = .continuousAutoFocus
        backCamera?.isSmoothAutoFocusEnabled = true
        backCamera?.whiteBalanceMode = .continuousAutoWhiteBalance
//        backCamera?.automaticallyEnablesLowLightBoostWhenAvailable = true
        backCamera?.unlockForConfiguration()
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input) {
            
            session!.addInput(input)
            // ...
            // The remainder of the session setup will go here...
            stillImageOutput = AVCapturePhotoOutput()
            stillImageOutput?.photoSettingsForSceneMonitoring?.livePhotoVideoCodecType = .jpeg
            
            
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                // Configure the Live Preview here...
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                
                if UIDevice.current.orientation == .portrait {
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                }
                else if UIDevice.current.orientation == .landscapeLeft {
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                }
                else if UIDevice.current.orientation == .landscapeRight {
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                }
                
                
                
                previewView.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
                
                
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureButton() {
        
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 2
        cameraButton.layer.cornerRadius = 40
        
    }
    
    
    func initializeShadow() {
        
        let shadowRadius = self.logoText.layer.frame.maxY + 8
        
        if UIDevice.current.orientation.isLandscape {
            self.landscapeTopShadow = EdgeShadowLayer(forView: view, edge: .Top, shadowRadius: shadowRadius, toColor: .clear, fromColor: blackColor)
            self.view.layer.insertSublayer(landscapeTopShadow!, at: 1)
            
            self.landscapeBotShadow = EdgeShadowLayer(forView: view, edge: .Bottom, shadowRadius: self.locationOutlet.frame.minY - 8, toColor: .clear, fromColor: blackColor)
            self.view.layer.insertSublayer(landscapeBotShadow!, at: 1)
        }
        else {
            self.portraitTopShadow = EdgeShadowLayer(forView: view, edge: .Top, shadowRadius: shadowRadius, toColor: .clear, fromColor: blackColor)
            self.view.layer.insertSublayer(portraitTopShadow!, at: 1)
            
            
            self.portraitBotShadow = EdgeShadowLayer(forView: view, edge: .Bottom, shadowRadius: self.locationOutlet.frame.minY - 8, toColor: .clear, fromColor: blackColor)
            self.view.layer.insertSublayer(portraitBotShadow!, at: 1)
        }
    }
    
    func updateShadows() {
        
        
        
        if UIDevice.current.orientation.isLandscape {
            
            if self.portraitTopShadow != nil {
                
                if (self.view.layer.sublayers?.contains(self.portraitTopShadow!))! {
                    self.portraitTopShadow?.removeFromSuperlayer()
                    self.portraitBotShadow?.removeFromSuperlayer()
                }
                
                let shadowRadius = self.logoText.layer.frame.maxY + 8
                self.landscapeTopShadow = EdgeShadowLayer(forView: self.view, edge: .Top, shadowRadius: shadowRadius, toColor: .clear, fromColor: self.blackColor)
                self.view.layer.insertSublayer(self.landscapeTopShadow!, at: 1)
                
                
            }
  
        }
        else {
            if self.landscapeTopShadow != nil {
                
                if (self.view.layer.sublayers?.contains(self.landscapeTopShadow!))! {
                    self.landscapeTopShadow?.removeFromSuperlayer()
                    self.landscapeBotShadow?.removeFromSuperlayer()
                }
                
                
                let shadowRadius = self.logoText.layer.frame.maxY + 8
                
                self.portraitTopShadow = EdgeShadowLayer(forView: self.view, edge: .Top, shadowRadius: shadowRadius, toColor: .clear, fromColor: self.blackColor)
                self.view.layer.insertSublayer(self.portraitTopShadow!, at: 1)
                
            }
            
            
            
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let when = DispatchTime.now() + 0.15 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.viewDidAppear(false)
            

        }
        
    }
    
    
    func setupLocation() {
        
        Locator.requestAuthorizationIfNeeded(.always)
        
        Locator.subscribePosition(accuracy: .room,
                                    onUpdate: { location in

                                        let lat = location.coordinate.latitude.truncate(places: 6)
                                        var latString: String
                                        let long = location.coordinate.longitude.truncate(places: 6)
                                        var longString: String
                                        
                                        if lat > 0 {
                                            latString = "\(lat)°N"
                                        } else {
                                            latString = "\(lat)°S"
                                        }
                                        
                                        if long > 0 {
                                            longString = "\(long)°E"
                                        }
                                        else {
                                            longString = "\(long)°W"
                                        }
                                        
                                        
                                        self.locationOutlet.text = latString + " , " + longString
                                    
                                    },
                                    onFail: { (error, last) in
                                    
                                        print(error)
                                    }
        )
        
    }
    
    
    func setupOrientation() {
        
        if UIDevice.current.orientation == .portrait {
            
            self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        }
        else if UIDevice.current.orientation == .landscapeLeft {
            self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        }
        else if UIDevice.current.orientation == .landscapeRight {
            self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
        }
        
        
        videoPreviewLayer!.frame = previewView.bounds
        
        updateShadows()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let when = DispatchTime.now() + 0.15 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.setupOrientation()
            
            
        }
        
        
        
    }
    
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error == nil {
            let imageData = photo.fileDataRepresentation()
            
            var orientation: UIImageOrientation?
            
            if UIDevice.current.orientation == .portrait {
                print("Picture taken in Portrait")
                orientation = UIImageOrientation.right
            }
            else if UIDevice.current.orientation == .landscapeLeft {
                print("Picture taken in left")
                orientation = UIImageOrientation.up
            }
            else if UIDevice.current.orientation == .landscapeRight {
                print("Picture taken in right")
                orientation = UIImageOrientation.down
            }
            else if UIDevice.current.orientation == .portraitUpsideDown {
                print("Picture taken in down")
                orientation = UIImageOrientation.left
            }
            else if UIDevice.current.orientation == .faceDown {
                print("Picture taken in down")
                orientation = UIImageOrientation.down
            }
            else if UIDevice.current.orientation == .faceUp {
                print("Picture taken in down")
                orientation = UIImageOrientation.up
            }
            
            let newImage = UIImage(data: imageData!)!
            
            let orientedImage = UIImage(cgImage: newImage.cgImage!, scale: newImage.scale, orientation: orientation!)
            
            self.imageToPass = orientedImage
            
            self.performSegue(withIdentifier: "confirmPictureSegue", sender: self)
        }
        
        session?.stopRunning()
        
        
    }
    
    
    
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "confirmPictureSegue" {
            let vc = segue.destination as! ImageConfirmVC
            vc.image = self.imageToPass
        }
        
    }
 
    
    

    
    
    
}


