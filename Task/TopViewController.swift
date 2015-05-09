//
//  TopViewController.swift
//  Task
//
//  Created by Yuta Chiba on 2015/05/10.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllerArray : [UIViewController] = []
        
        var controller1 = self.storyboard!.instantiateViewControllerWithIdentifier("TaskList") as! TaskListViewController
        controller1.title = "Undo"
        var controller2 = self.storyboard!.instantiateViewControllerWithIdentifier("TaskList") as! TaskListViewController
        controller2.title = "Doing"
        var controller3 = self.storyboard!.instantiateViewControllerWithIdentifier("TaskList") as! TaskListViewController
        controller3.title = "Done"
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        controllerArray.append(controller3)
        
        var parameters: [String: AnyObject] = ["scrollMenuBackgroundColor": UIColor.grayColor(),
            "viewBackgroundColor": UIColor.blackColor(),
            "selectionIndicatorColor": UIColor.orangeColor(),
            "bottomMenuHairlineColor": UIColor.blackColor(),
            "menuItemFont": UIFont(name: "HelveticaNeue", size: 13.0)!,
            "menuHeight": 80.0,
            "menuItemWidth": 120.0,
            "centerMenuItems": true,
            "menuItemSeparatorWidth": 4.3   ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), options: parameters)
        
        self.view.addSubview(pageMenu!.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
