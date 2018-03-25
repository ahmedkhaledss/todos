//
//  AddViewPresenter.swift
//  Todos
//
//  Created by Ahmed Khaled on 3/21/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AddView : NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func present(controller: UIViewController, animated: Bool)
}

protocol AddViewPresenterDelegate {
    func todoAdded(todo : Todo)
}

class AddViewPresenter {
    let jsonServerURL = "https://my-json-server.typicode.com/ahmedkhaledss/jsonrepo/todos"
    var addView : AddView?
    var delegate : AddViewPresenterDelegate? = nil
    
    func attachView(view : AddView) {
        addView = view
    }
    
    func saveTodo(todoName : String) {
        addView?.startLoading()
        let param : [String : Any] = ["title": todoName]
        Alamofire.request(jsonServerURL, method: .post, parameters: param, encoding: JSONEncoding.default).responseString {
            response in
            if response.result.isSuccess {
                self.addView?.finishLoading()
                let todo : Todo = Todo(title : todoName)
                self.delegate?.todoAdded(todo: todo)

            }
            else {
                self.addView?.finishLoading()
                let alert : UIAlertController = UIAlertController(title: "Error", message: response.result.error!.localizedDescription, preferredStyle: .alert)
                let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.addView?.present(controller: alert, animated: true)
            }
            
        }
    }
}



