//
//  RuleViewController.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/26/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import PageMenu

class RuleViewController : BaseViewController {
    var currentTournament : TournamentModel?
    
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        self.title = currentTournament?.name
        
        self.configureMenu()
    }
    
    func configureMenu() {
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        let ruleViewController : WebViewController = WebViewController(nibName: "WebViewController", bundle: nil)
        ruleViewController.title = "rule_tab".localized
        ruleViewController.htmlString = currentTournament?.competitionMode
        
        let feeViewController : WebViewController = WebViewController(nibName: "WebViewController", bundle: nil)
        feeViewController.title = "fee_tab".localized
        feeViewController.htmlString = currentTournament?.competitionFee
        
        let scheduleViewController : WebViewController = WebViewController(nibName: "WebViewController", bundle: nil)
        scheduleViewController.title = "schedule_tab".localized
        scheduleViewController.htmlString = currentTournament?.competitionSchedule
        
        
        controllerArray.append(ruleViewController)
        controllerArray.append(feeViewController)
        controllerArray.append(scheduleViewController)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.gray),
            .menuItemSeparatorWidth(0),
            .useMenuLikeSegmentedControl(false),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        let pageMenuFrame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.containerView.addSubview(pageMenu!.view)
    }
}


