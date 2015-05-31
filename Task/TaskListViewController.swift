//
//  TaskListViewController.swift
//  Task
//
//  Created by Yuta Chiba on 2015/05/10.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import UIKit
import Parse
import Bolts

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    // UI関連
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var doingBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    // プロパティ
    var taskList:AnyObject?             // Taskリストのオブジェクト
    var selectedCellRow:Int?            // 現在選択されているrow
    var _indexPath:NSIndexPath?         // 現在選択されているPath
    var isShowStatusChangeBtns = false  // Status変更ボタンの表示フラグ
    var taskStatus : TaskStatus?               // 現在のtaskStatus
    
    let showHeight = UIScreen.mainScreen().bounds.size.height - 170 // button表示時の高さ
    let hideHeight = UIScreen.mainScreen().bounds.size.height + 170 // button非表示時の高さ
    
    // MARK: - Delegate (ViewController)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGestureRecognizer()
    }
    
    /* PageMenuバグ用View修正 */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let superSize   = self.view.superview!.frame.size
        let rect        = self.view.frame
        let size        = self.view.frame.size
        
        self.view.frame.size = CGSizeMake(size.width, superSize.height - rect.origin.y)
    }
    
    override func viewWillAppear(animated: Bool) {
        println(__FUNCTION__)
        
        // データを取得
        // TODO ネットワークが繋がっていない場合は取りに行かない。
        // TODO 基本的に書き込み、取得するDBはローカルのDBにする。
        // 適当なタイミングでリモートと同期
        /*
        var query: PFQuery = PFQuery(className: taskTable)
        query.orderByAscending("createdAt")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in (objects as! [PFObject]) {
                if(error == nil){
                    self.taskList = objects
                    self.tableView.reloadData()
                }
            }
        }
        */
        setTableData()
        
        if tableView != nil {
            tableView.reloadData()
        }
        
        if let undo = undoBtn, doing = doingBtn, done = doneBtn, add = addBtn {
            UIView.animateWithDuration(0.8, // アニメーションの時間
                animations: {() -> Void  in
                    // アニメーションする処理
                    add.frame.origin.y = self.showHeight
                    add.hidden = false
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
    
        if let undo = undoBtn, doing = doingBtn, done = doneBtn, add = addBtn {
            UIView.animateWithDuration(1, // アニメーションの時間
                animations: {() -> Void  in
                    // アニメーションする処理
                    add.frame.origin.y = self.hideHeight
            })
        }
    }
    
    // MARK: - Delegate (TableView)
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // println(__FUNCTION__)
        return taskList!.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(__FUNCTION__)
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = taskList?.objectAtIndex(indexPath.row).objectForKey(taskNameKey) as? String
        
        
        var backView = UIView(frame: cell.frame)
        backView.backgroundColor = UIColor.whiteColor()
        cell.backgroundView = backView
        
        if let backGroundView = cell.backgroundView {
            println("balck!!!!")
            backGroundView.backgroundColor = UIColor.blueColor()
            backGroundView.alpha = 0.1
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 選択されたrowを保持
        selectedCellRow = indexPath.row
        _indexPath = indexPath
        
        switchBtns()
    }
    
    // MARK: - Other Method
    
    func setTableData(){
        
        // TODO 分岐をもっと簡潔に
        if self.title == TaskStatus.Undo.getName() {
            taskStatus = TaskStatus.Undo
        }
        
        if self.title == TaskStatus.Doing.getName() {
            taskStatus = TaskStatus.Doing
        }
        
        if self.title == TaskStatus.Done.getName() {
            taskStatus = TaskStatus.Done
        }
        
        var query: PFQuery = PFQuery(className: taskTable)
        if let status = taskStatus {
            query.whereKey(taskStatusKey, equalTo: status.rawValue)
        }
        
        // データを取得
        query.orderByAscending("createdAt")
        taskList = query.findObjects()
    }
    
    func setGestureRecognizer(){
        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    /* 表示するボタンの切り替え */
    private func switchBtns() {
        
        // TODO いま表示中のステータス変更ボタンを非表示に。
        
        if isShowStatusChangeBtns {
                UIView.animateWithDuration(0.8,
                    animations: {() -> Void  in
                        self.undoBtn.frame.origin.y = self.hideHeight
                        self.doingBtn.frame.origin.y = self.hideHeight
                        self.doneBtn.frame.origin.y = self.hideHeight
                        self.addBtn.frame.origin.y = self.showHeight
                })
        } else {
                UIView.animateWithDuration(0.8,
                    animations: {() -> Void  in
                        self.undoBtn.frame.origin.y = self.showHeight
                        self.doingBtn.frame.origin.y = self.showHeight
                        self.doneBtn.frame.origin.y = self.showHeight
                        self.addBtn.frame.origin.y = self.hideHeight
                })
        }
        self.isShowStatusChangeBtns = !self.isShowStatusChangeBtns
    }

    /* cellを長押した場合の処理 */
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        
        let point = recognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath == nil {
        
        } else if recognizer.state == UIGestureRecognizerState.Began  {
            selectedCellRow = indexPath!.row
            self.performSegueWithIdentifier("editTask", sender: self)
         }
    }
    
    /* Taskのステータス変更 */
    @IBAction func changeStatus(statusBtn: UIButton) {
        
        let taskStatusValue = statusBtn.tag
        let toTaskStatus = TaskStatus(rawValue: taskStatusValue)
        
        if let list: AnyObject = taskList, row = selectedCellRow, taskStatus = toTaskStatus {
            let task = list.objectAtIndex(row) as! PFObject
            task.setValue(taskStatus.rawValue, forKey: taskStatusKey)
            task.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if let err = error {
                    println("error：\(err.description)")
                } else {
                    println("Object has been saved.")
                    self.setTableData()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        println(__FUNCTION__)
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var taskViewController:TaskViewController = segue.destinationViewController as! TaskViewController
        
        if let list: AnyObject = taskList, row = selectedCellRow {
            let task = list.objectAtIndex(row) as! PFObject
            taskViewController.objectId = task.objectId
        }
        taskViewController.taskStatus = taskStatus
    }


}
