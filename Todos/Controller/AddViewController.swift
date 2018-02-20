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

class AddViewController: UIViewController {
        let jsonServerURL = "https://my-json-server.typicode.com/ahmedkhaledss/jsonrepo/todos"


    @IBOutlet weak var tTitle: UITextField!    
    @IBAction func saveBtn(_ sender: Any) {
        let param : [String : Any] = ["title": tTitle.text!]
        Alamofire.request(jsonServerURL, method: .post, parameters: param, encoding: JSONEncoding.default).responseString {
            response in
            if response.result.isSuccess {

                print(response)
            }
            else {
                print("Error : \(response.result.error!)")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
