//
//  OpinionViewController.swift
//  The Dust
//
//  Created by Jun on 2020/11/18.
//

import UIKit
import MessageUI
import Foundation

class OpinionViewController: UIViewController, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var opinionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        self.opinionTextField.layer.borderWidth = 1
        self.opinionTextField.layer.borderColor = UIColor.gray.cgColor
        self.opinionTextField.layer.cornerRadius = 5
        
        self.submitButton.layer.cornerRadius = 5
        
        if !MFMailComposeViewController.canSendMail() {
            return
        }
    }
    
    //MARK: tap gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: send Mail
    @IBAction func clickSendMailButton(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        //configure fields
        composeVC.setToRecipients(["eotlr680@naver.com"])
        composeVC.setSubject("customer of The Dust")
        composeVC.setMessageBody(self.opinionTextField.text!, isHTML: false)
        
        let alert = UIAlertController(title: "메일을 성공적으로 보냈습니다.", message: "소중한 의견 감사드립니다. 더 나은 The Dust로 찾아뵙겠습니다.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.opinionTextField.text = ""
        
    }
    

    
}
