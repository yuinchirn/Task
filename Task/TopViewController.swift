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

    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageMenu()
    }
    
    /* PageMenuの設定、配置 */
    func setPageMenu(){
        var controllerArray : [UIViewController] = []
        
        var controller1 = self.storyboard!.instantiateViewControllerWithIdentifier(taskListIdentifier) as! TaskListViewController
        controller1.title = TaskStatus.Undo.getName()
        var controller2 = self.storyboard!.instantiateViewControllerWithIdentifier(taskListIdentifier) as! TaskListViewController
        controller2.title = TaskStatus.Doing.getName()
        var controller3 = self.storyboard!.instantiateViewControllerWithIdentifier(taskListIdentifier) as! TaskListViewController
        controller3.title = TaskStatus.Done.getName()
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        controllerArray.append(controller3)
        
        var parameters: [String: AnyObject] = ["scrollMenuBackgroundColor": UIColor.grayColor(),
            "viewBackgroundColor": UIColor.blackColor(),
            "selectionIndicatorColor": UIColor.orangeColor(),
            "bottomMenuHairlineColor": UIColor.blackColor(),
            "menuItemFont": UIFont(name: "HelveticaNeue", size: 16.0)!,
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
}
