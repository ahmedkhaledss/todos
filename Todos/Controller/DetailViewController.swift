//
//  DetailViewController.swift
//  Todos
//
//  Created by Ahmed Khaled on 2/1/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
        
        if let detail = todoDetail {
            if let label = detailDescriptionLabel {
                label.text = detail.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    var detailItem: NSDate? {
//        didSet {
//            // Update the view.
//            configureView()
//        }
//    }
    
    var todoDetail: Todo? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

