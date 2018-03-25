//
//  AddViewController.swift
//  Todos
//
//  Created by Ahmed Khaled on 2/2/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import UIKit
import SVProgressHUD


class AddViewController: UIViewController {
    var presenter : AddViewPresenter? = nil



    @IBOutlet weak var tTitle: UITextField!    
    @IBAction func saveBtn(_ sender: Any) {
        view.endEditing(true)
        presenter?.saveTodo(todoName : tTitle.text!)
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
    
    

}


extension AddViewController : AddView{
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
