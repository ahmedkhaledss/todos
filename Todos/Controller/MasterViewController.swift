//
//  MasterViewController.swift
//  Todos
//
//  Created by Ahmed Khaled on 2/1/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import UIKit
import SVProgressHUD


class MasterViewController: UITableViewController, AddViewPresenterDelegate {

    var detailViewController: DetailViewController? = nil
    var presenter : MasterViewPresenter? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MasterViewPresenter()
        presenter?.attachView(view: self)
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToAddTodo))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        presenter?.loadData()
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
    
    func insertNewTodo(indexPath : IndexPath) {
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let todo = presenter?.todos[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.todoDetail = todo
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        else if segue.identifier == "addTodo" {
            let controller = segue.destination as! AddViewController
            controller.presenter?.delegate = self
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter!.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = presenter?.todos[indexPath.row]
        cell.textLabel!.text = todo?.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteTodo(indexPath : indexPath)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    //MARK: - Delegate Method
    func todoAdded(todo: Todo) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        presenter?.todos.append(todo)
        tableView.reloadData()
    }
}

extension MasterViewController : TodosView{
    func present(controller : UIViewController, animated: Bool) {
        self.present(controller: controller, animated: animated)
    }
    
    func startLoading() {
        SVProgressHUD.show()
    }
    func finishLoading() {
        SVProgressHUD.dismiss()
    }

}

extension MasterViewController {
    func deleteRow(indexPath: IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

