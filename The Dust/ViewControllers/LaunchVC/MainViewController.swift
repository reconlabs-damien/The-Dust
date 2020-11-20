//
//  ViewController.swift
//  The Dust
//
//  Created by Jun on 2020/11/17.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var bellUIImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setSplashGradientBackground(colorTop: UIColor(rgb: 0xFC5763), colorBottom: UIColor(rgb: 0xFD9367))
        self.animateBellImage()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.animateBellImage()
        }
        
        perform(#selector(goMain), with: nil, afterDelay: 2.0)
        
    }

    @objc func goMain() {
        let sb = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "TabBarController") as! TabBarController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: bell image animation
    func animateBellImage() {
        self.bellUIImage.transform = CGAffineTransform(rotationAngle: -0.1)
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            self.bellUIImage.transform = CGAffineTransform(rotationAngle: 0.1)
        }, completion: nil)

    }

}

