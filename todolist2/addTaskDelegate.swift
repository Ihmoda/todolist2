//
//  addTaskDelegate.swift
//  todolist2
//
//  Created by Omar Ihmoda on 1/24/18.
//  Copyright © 2018 Omar Ihmoda. All rights reserved.
//

import Foundation

protocol AddTaskDelegate: class {
    func addTask(by: AddTaskViewController, data: [String: Any])
}
