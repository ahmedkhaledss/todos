//
//  AddViewController.swift
//  Todos
//
//  Created by Ahmed Khaled on 2/2/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

protocol AddViewControllerDelegate {
    func todoAdded(todo : Todo)
}
class AddViewController: UIViewController {
    
    var delegate : AddViewControllerDelegate? = nil
    let jsonServerURL = "https://my-json-server.typicode.com/ahmedkhaledss/jsonrepo/todos"


    @IBOutlet weak var tTitle: UITextField!    
    @IBAction func saveBtn(_ sender: Any) {
        view.endEditing(true)
        SVProgressHUD.show()
        let param : [String : Any] = ["title": tTitle.text!]
        Alamofire.request(jsonServerURL, method: .post, parameters: param, encoding: JSONEncoding.default).responseString {
            response in
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                let todo : Todo = Todo(title : self.tTitle.text!)
                self.delegate?.todoAdded(todo: todo)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()
                let alert : UIAlertController = UIAlertController(title: "Error", message: response.result.error!.localizedDescription, preferredStyle: .alert)
                let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add new todo"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
