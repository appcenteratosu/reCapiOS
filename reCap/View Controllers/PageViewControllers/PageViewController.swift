//
//  PageViewController.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController, PageboyViewControllerDataSource {
    
    // MARK: - Properties
    private var viewControllersArray: [UIViewController]!
    private var mapVC: MapContainerVC!
    private var cameraVC: CameraContainerVC!
    private var leaderboardsVC: LeaderboardsFriendsVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let mapStoryboard = UIStoryboard(name: "Map", bundle: Bundle.main)
        let cameraStoryboard = UIStoryboard(name: "Camera", bundle: Bundle.main)
        let leaderboardsStoryboard = UIStoryboard(name: "LeaderboardsFriends", bundle: Bundle.main)
        
        mapVC = mapStoryboard.instantiateViewController(withIdentifier: "MapContainerVC") as! MapContainerVC
        let cameraNav = cameraStoryboard.instantiateViewController(withIdentifier: "CameraNav") as! UINavigationController
        let leaderboardsNav = leaderboardsStoryboard.instantiateViewController(withIdentifier: "LeaderboardsFriendsNav") as! UINavigationController
        leaderboardsVC = leaderboardsNav.topViewController as! LeaderboardsFriendsVC
        leaderboardsVC.mode = LeaderboardsFriendsVC.LEADERBOARD_MODE
        self.viewControllersArray = [mapVC, cameraNav]
        self.dataSource = self
    }
    
    //Pageboy Datasource Functions
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllersArray.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        pageboyViewController.transition = Transition(style: .fade, duration: 1.0)
        return viewControllersArray[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: 1)
    }
    
    

}
