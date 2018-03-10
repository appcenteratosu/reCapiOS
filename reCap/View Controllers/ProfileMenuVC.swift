//
//  ProfileMenuVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/18/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Hero
import Firebase

class ProfileMenuVC: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var logoOutlet: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var pointsOutlet: UILabel!
    
    @IBOutlet weak var settingsOutlet: UIButton!
    @IBOutlet weak var aboutOutlet: UIButton!
    @IBOutlet weak var albumOutlet: UIButton!
    
    // MARK: - Properties
    var user: User!
    
    @IBAction func backAction(_ sender: Any) {
        
    }
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            setupHero()
            setupGestures()
            setupOutlets()
            setupBlurEffect(image: image!)
        }
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupHero() {
        
        let duration: TimeInterval = TimeInterval(exactly: 0.5)!
        
        profileImage.hero.modifiers = [.forceNonFade, .duration(duration), .arc(intensity: 1.0)]
        
        logoOutlet.hero.modifiers = [.forceNonFade, .duration(duration), .useScaleBasedSizeChange]
        
        albumOutlet.hero.modifiers = [.duration(duration), .arc(intensity: 1.0)]
        
        settingsOutlet.hero.modifiers = [.fade, .duration(duration), .arc(intensity: 1.0)]
        
        aboutOutlet.hero.modifiers = [.duration(duration), .arc(intensity: 1.0)]
        
        
    }
    
    // MARK: - Outlet Actions

    /*
     Photo library button pressed
    */
    @IBAction func photoLibPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "PhotoLibSegue", sender: self.user)
    }
    
    func setupGestures() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                //self.performSegue(withIdentifier: "toCameraSegue", sender: self)
            default:
                break
            }
        }
    }
    
    func setupOutlets() {
        
        let id = FBDatabase.getSignedInUserID()
        let reference = Database.database().reference()
        
        
        FBDatabase.getUser(with_id: id!, ref: reference) { (user) in
            
            if user != nil {
                
                let name = user!.name
                let points = user!.points.description
                
                self.nameOutlet.text = name
                self.pointsOutlet.text = "Points: \(points)"
            
                
                FBDatabase.getProfilePicture(for_user: user!, with_progress: { (progress, total) in
                }, with_completion: { (image) in
                    if let fetchedImage = image {
                        self.profileImage.layer.cornerRadius = self.profileImage.layer.frame.width / 2
                        self.profileImage.layer.masksToBounds = false
                        self.profileImage.clipsToBounds = true
                        self.profileImage.contentMode = .scaleAspectFill
                        self.profileImage.layer.borderWidth = 1
                        self.profileImage.layer.borderColor = UIColor.white.cgColor
                        self.profileImage.image = fetchedImage
                        self.setupProfileImage()
                    }
                })
            }
            
            
        }
    }
    
    func setupProfileImage() {
        
        //profileImage.image = image
        
    }
    
    func setupBlurEffect(image: UIImage){
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        self.backgroundImage.image = blurredImage
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segueID = segue.identifier
        if segueID == "PhotoLibSegue" {
            let destination = segue.destination as! UINavigationController
            let photoLibVC = destination.topViewController as! PhotoLibChallengeVC
            photoLibVC.user = self.user
            photoLibVC.mode = PhotoLibChallengeVC.PHOTO_LIB_MODE
        }
        else if segueID == "FriendsListSegue" {
            let desination = segue.destination as! UINavigationController
            let friendsVC = desination.topViewController as! LeaderboardsFriendsVC
            friendsVC.user = self.user
            friendsVC.mode = LeaderboardsFriendsVC.FRIENDS_LIST_MODE
        }
    }
    

}
