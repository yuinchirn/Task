//
//  TaskViewController.swift
//  Task
//
//  Created by Yuta Chiba on 2015/05/10.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import UIKit
import Parse
import Bolts

class TaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    /* checkボタン押下時のイベント */
    @IBAction func checkBtn(sender: AnyObject) {
        
        if !taskNameTextField.text.isEmpty {
            saveTask()
        }
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    /* タスクを保存 */
    func saveTask(){
        let task = PFObject(className: "Task")
        task["taskName"] = taskNameTextField.text
        task.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
        task.pinInBackground()
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
