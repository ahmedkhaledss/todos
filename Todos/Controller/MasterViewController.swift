//
//  MasterViewController.swift
//  Todos
//
//  Created by Ahmed Khaled on 2/1/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class MasterViewController: UITableViewController, AddViewControllerDelegate {


    let jsonServerURL = "https://my-json-server.typicode.com/ahmedkhaledss/jsonrepo/todos"
    

    var detailViewController: DetailViewController? = nil
    var todos = [Todo]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToAddTodo))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        SVProgressHUD.show()
        Alamofire.request(jsonServerURL, method: .get, parameters: nil).responseJSON {
            response in
            if(response.result.isSuccess) {
                SVProgressHUD.dismiss()
                let todos : JSON = JSON(response.result.value!)
                //print(todos)
                if let jsonArray : [JSON] = todos.array {
                    for json in jsonArray {
                        let todo = Todo(json : json)
                        
                        self.insertNewTodo(todo)
                    }
                }
                else {

                    let alertController : UIAlertController = UIAlertController(title: "Error", message: "The Application has encountered a problem", preferredStyle: .alert)
                    let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true)
                }
            }
            else {
                SVProgressHUD.dismiss()
                let alertController : UIAlertController = UIAlertController(title: "Error", message: response.result.error!.localizedDescription, preferredStyle: .alert)
                let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }
        }
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func segueToAddTodo(){
        performSegue(withIdentifier: "addTodo", sender: self)
    }
    
    func insertNewTodo(_ todo: Todo) {
        todos.append(todo)
        let indexPath = IndexPath(row: self.todos.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let todo = todos[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.todoDetail = todo
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        else if segue.identifier == "addTodo" {
            let controller = segue.destination as! AddViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel!.text = todo.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let param : [String : Any] = ["title" : todos[indexPath.row].title]
            SVProgressHUD.show()
            Alamofire.request(jsonServerURL, method: .delete, parameters: param, encoding: JSONEncoding.default).responseString {
                response in
                if response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    self.todos.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                else {
                    SVProgressHUD.dismiss()
                    let alertController : UIAlertController = UIAlertController(title: "Error", message: response.result.error!.localizedDescription, preferredStyle: .alert)
                    let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


    //MARK: - Delegate Method
    func todoAdded(todo: Todo) {
        todos.append(todo)
        tableView.reloadData()
    }
}

