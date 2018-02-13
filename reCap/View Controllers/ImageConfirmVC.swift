//
//  ImageConfirmVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/12/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class ImageConfirmVC: UIViewController {
    
    var image: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func cancelButton(_ sender: Any) {
        
        

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.toolbar.barStyle = .blackTranslucent
        
        //self.navigationController?.setToolbarHidden(false, animated: false)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        imageView.image = image
        self.navigationController?.setToolbarHidden(false, animated: false)

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let when = DispatchTime.now() + 0.15 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if UIDevice.current.orientation == .portrait {
            }
            else if UIDevice.current.orientation == .landscapeLeft {
            }
            else if UIDevice.current.orientation == .landscapeRight {
            }
            
            
        }
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller. createPictureSegue
        
        if segue.identifier == "createPictureSegue" {
            let vc = segue.destination as! ImageCreateVC
            vc.image = self.image
        }
    }
 

}
