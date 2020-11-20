//
//  MenuViewController.swift
//  The Dust
//
//  Created by Jun on 2020/11/18.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.layer.borderWidth = 1
        self.loginButton.layer.borderColor = UIColor.gray.cgColor
        self.loginButton.layer.cornerRadius = 12
    }
    
    //MARK: 로그인
    @IBAction func goLogin(_ sender: Any) {
        let alert = UIAlertController(title: "서비스 준비중입니다.", message: "조금만 기다려주세요!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: 공지사항
    @IBAction func goNotice(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoticeViewController") as! NoticeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: 앱 정보
    @IBAction func goAppInfo(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoViewController") as! AppInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: 고객지원
    @IBAction func goCustomer(_ sender: Any) {
    }
    
    //MARK: 이용의견
    @IBAction func goOpinion(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpinionViewController") as! OpinionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
