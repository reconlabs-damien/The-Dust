//
//  AqiNavViewController.swift
//  The Dust
//
//  Created by Jun on 2020/11/20.
//

import UIKit

class AqiNavViewController: UINavigationController {

    let orangeGradient = [UIColor(rgb: 0xFC4761), UIColor(rgb: 0xFC5763), UIColor(rgb: 0xFD6C64), UIColor(rgb: 0xFD8667), UIColor(rgb: 0xFD9367)]
    let orangeGradientLocation = [0.0, 0.25, 0.5, 0.75, 1.0]
    lazy var colorView = { () -> UIView in
        let view = UIView()
        view.isUserInteractionEnabled = false
        navigationBar.addSubview(view)
        navigationBar.sendSubviewToBack(view)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationBar()
        changeGradientImage()
    }
    
    func gradientImage(withColours colours: [UIColor], location: [Double], view: UIView) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colours.map{ $0.cgColor }
        gradient.startPoint = (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5)).0
        gradient.endPoint = (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5)).1
        gradient.locations = location as [NSNumber]
        gradient.cornerRadius = view.layer.cornerRadius
        
        return UIImage.image(from: gradient) ?? UIImage()
        
    }
    
    func changeGradientImage() {
        // 1 status bar
        colorView.frame = CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: navigationBar.frame.width, height: UIApplication.shared.statusBarFrame.height)
        colorView.backgroundColor = UIColor(patternImage: gradientImage(withColours: orangeGradient, location: orangeGradientLocation, view: navigationBar).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: navigationBar.frame.size.width/2, bottom: 10, right: navigationBar.frame.size.width/2), resizingMode: .stretch))
        navigationBar.setBackgroundImage(gradientImage(withColours: orangeGradient, location: orangeGradientLocation, view: navigationBar), for: .default)
        navigationBar.layer.backgroundColor = UIColor(patternImage: gradientImage(withColours: orangeGradient, location: orangeGradientLocation, view: navigationBar).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: navigationBar.frame.size.width/2, bottom: 10, right: navigationBar.frame.size.width/2), resizingMode: .stretch)).cgColor
    }
    
    func configNavigationBar() {
        navigationBar.barStyle = .default
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationBar.tintColor = UIColor.white
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    

}
