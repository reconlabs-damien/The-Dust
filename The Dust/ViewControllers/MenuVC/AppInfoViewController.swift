//
//  AppInfoViewController.swift
//  The Dust
//
//  Created by Jun on 2020/11/18.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet weak var openButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openButton.layer.borderColor = UIColor.gray.cgColor
        self.openButton.layer.borderWidth = 1
        self.openButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    

    
}
