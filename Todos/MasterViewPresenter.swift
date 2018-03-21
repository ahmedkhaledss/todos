//
//  MasterViewPresenter.swift
//  Todos
//
//  Created by Ahmed Khaled on 3/21/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol TodosView : NSObjectProtocol {
    
    func startLoading()
    func finishLoading()
    func insertNewTodo(indexPath : IndexPath)
    func present(controller : UIViewController, animated : Bool)
    func deleteRow(indexPath : IndexPath)
}

class MasterViewPresenter {
    let jsonServerURL = "https://my-json-server.typicode.com/ahmedkhaledss/jsonrepo/todos"
    var todosView : TodosView?
    var todos = [Todo]()
    
    
    
    func attachView(view : TodosView) {
        todosView = view
    }
    func loadData() {
        self.todosView?.startLoading()
        Alamofire.request(jsonServerURL, method: .get, parameters: nil).responseJSON {
            response in
            if(response.result.isSuccess) {
                self.todosView?.finishLoading()
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
                    self.todosView?.present(controller: alertController, animated: true)
                }
            }
            else {
                self.todosView?.finishLoading()
                let alertController : UIAlertController = UIAlertController(title: "Error", message: response.result.error!.localizedDescription, preferredStyle: .alert)
                let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(action)
                self.todosView?.present(controller: alertController, animated: true)
            }
        }
    }
    
    func deleteTodo(indexPath : IndexPath) {
        let param : [String : Any] = ["title" : todos[indexPath.row].title]
        todosView?.startLoading()
        Alamofire.request(jsonServerURL, method: .delete, parameters: param, encoding: JSONEncoding.default).responseString {
            response in
            if response.result.isSuccess {
                self.todosView?.finishLoading()
                self.todos.remove(at: indexPath.row)
                self.todosView?.deleteRow(indexPath: indexPath)
            }
            else {
                self.todosView?.finishLoading()
                let alertController : UIAlertController = UIAlertController(title: "Error", message: response.result.error!.localizedDescription, preferredStyle: .alert)
                let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(action)
                self.todosView?.present(controller: alertController, animated: true)
            }
        }
    }
    
    func insertNewTodo(_ todo: Todo) {
        todos.append(todo)
        let indexPath = IndexPath(row: self.todos.count-1, section: 0)
        todosView?.insertNewTodo(indexPath : indexPath)
    }
    
}
