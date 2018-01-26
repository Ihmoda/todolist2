//
//  AddTaskViewController.swift
//  todolist2
//
//  Created by Omar Ihmoda on 1/24/18.
//  Copyright © 2018 Omar Ihmoda. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    var delegate: AddTaskDelegate?
    var indexPath: NSIndexPath?

    var data: [String: Any] =
        [
            "taskname": "",
            "taskdetails": "",
            "taskdate": NSDate(),
            "taskcategory": "",
            "complete": false
        ]
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    @IBAction func addItemButtonPressed(_ sender: UIButton) {
        
        if let name = self.taskTextField.text {
            self.data["taskname"] = name as! String
        }
        
        if let details = self.detailsTextView.text {
            self.data["taskdetails"] = details as! String
        }
        
        
        if let category = self.categoryTextField.text {
            self.data["taskcategory"] = category
        }
        
        
        self.data["taskdate"] = self.datePicker.date
        self.delegate?.addTask(by: self, data: data)
        
    }
    
    
}

// Put this piece of code anywhere you like
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
