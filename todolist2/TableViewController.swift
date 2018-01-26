//
//  TableViewController.swift
//  todolist2
//
//  Created by Omar Ihmoda on 1/24/18.
//  Copyright © 2018 Omar Ihmoda. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, AddTaskDelegate {
    
    var headers = [String]()
    var tasks = [TaskItem]()
    var data: [String: [TaskItem]] = [:]
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAll()
        self.convertTasks()
        print(self.data)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.headers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let header = self.headers[section]
        return self.data[header]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headers[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let header = self.headers[indexPath.section]
        let task_item = self.data[header]![indexPath.row]
        
        if task_item.completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.taskLabel?.text = self.data[header]![indexPath.row].name as! String
        
        cell.descriptionLabel?.text = self.data[header]![indexPath.row].detail as! String
    
    
        //format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let actual_date = self.data[header]![indexPath.row].date as! NSDate
        let date = dateFormatter.string(from: actual_date as Date)
        
        cell.dateLabel?.text = date

        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: CustomTableViewCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
       
        
        let header = self.headers[indexPath.section]
        let task_item = self.data[header]![indexPath.row]
        
        if task_item.completed {
            cell.accessoryType = .none
            task_item.completed = false
        } else {
            cell.accessoryType = .checkmark
            task_item.completed = true
        }
        
        do {
            try context.save()
        } catch {
            print("error")
        }
    
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            let header = self.headers[indexPath.section]
            let task_item = self.data[header]![indexPath.row]
            context.delete(task_item)
            do {
                try context.save()
            } catch {
                print(error)
            }
            
            self.data[header]?.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            self.performSegue(withIdentifier: "addTask", sender: editActionsForRowAt)
            
        }
        
        edit.backgroundColor = .orange
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let header = self.headers[editActionsForRowAt.section]
            let task_item = self.data[header]![editActionsForRowAt.row]
            self.context.delete(task_item)
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            
            self.data[header]?.remove(at: editActionsForRowAt.row)
            self.tableView.reloadData()
        }
        
        delete.backgroundColor = .red
        
        return [edit, delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! AddTaskViewController
        destination.delegate = self
        
//        if sender is NSIndexPath {
//            destination.indexPath = sender as! NSIndexPath
//        }
        
       
        
        
    }
    
    func addTask(by: AddTaskViewController, data: [String : Any]) {
        
        let header = data["taskcategory"] as! String
        if !self.headers.contains(header){
            self.headers.append(header)
        }

        
        let new_data = data as NSDictionary
        
        //save to coredata
        var new_task_item = TaskItem(context: context)
        new_task_item.name = new_data["taskname"] as! String
        new_task_item.detail = new_data["taskdetails"] as? String
        new_task_item.date = new_data["taskdate"] as! Date
        new_task_item.completed = false
        new_task_item.category = new_data["taskcategory"] as! String
        self.tasks.append(new_task_item)
        
        //save to self.data for populating headers
        if !(self.data[header] != nil) {
            self.data[header] = [new_task_item]
        } else {
            var new_arr = self.data[header] as! [TaskItem]
            new_arr.append(new_task_item)
            self.data[header]  = new_arr
        }
        
    
        do {
            try context.save()
            print("successfully saved taskitem to DB")
        } catch {
            print("couldn't save to DB")
        }
        

        self.tableView.reloadData()
        dismiss(animated: true, completion: nil)

    }
    
    func fetchAll(){
     
        let taskItemRequest:NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            self.tasks = try context.fetch(taskItemRequest)
            print("got tasks")
        }
            catch { print(error)
        }
    }
    
    func convertTasks(){
        for task in self.tasks {
            if !self.headers.contains(task.category!) {
                self.headers.append(task.category!)
            }

            if !(self.data[task.category!] != nil) {
                self.data[task.category!] = [task]
            } else {
                var new_arr = self.data[task.category!] as! [TaskItem]
                new_arr.append(task)
                self.data[task.category!]  = new_arr
            }
        }
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

