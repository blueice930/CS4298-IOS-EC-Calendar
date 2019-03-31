//
//  TutorialViewController.swift
//  onECalendar
//
//  Created by Ronnie Li on 3/31/19.
//  Copyright © 2019 Ronnie Li. All rights reserved.
//

import UIKit
import SwiftyOnboard
import SwiftOverlayShims

class TutorialViewController: UIViewController {
    var swiftyOnboard: SwiftyOnboard!
    let colors:[UIColor] = [#colorLiteral(red: 0.3334529996, green: 0.3025326729, blue: 0.6009013057, alpha: 1),#colorLiteral(red: 0.7112176418, green: 0.7128540874, blue: 0.3770347238, alpha: 1),#colorLiteral(red: 0.5006242394, green: 0.1592580974, blue: 0.2713294625, alpha: 1),#colorLiteral(red: 0.4444106817, green: 0.7408292294, blue: 0.4954127669, alpha: 1)]

    var titleArray: [String] =
        [
            "Welcome to onECalendar!",
            
            "How does EC-Calendar work?",
            
            "Why do we do this?",
            
            "Easy & Convenient"
    ]
    
    //A calendar system with Easier week system and Compatibly uses same month system of the current Gregorian calendar.\n
    var subTitleArray: [String] =
        [
            "ONE Same Calendar For Every Year",
            
            "- Start with Monday and ends with Sunday Every Year -\n- 29 days in February -\n- Annual Extra Saturday on the Dec 1st -\n- Leap day -> Aug 31st -> Extra Saturday",
            
            "Easier week display and Compatibly uses the same month system.\nMake More Sense!",
            
            "Try EC-Calendar and check the difference"
            
    ]
    
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    @objc func handleSkip() {
        performSegue(withIdentifier: "calendarView", sender: self)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    
    @objc func handleTutDone(sender: UIButton) {
        performSegue(withIdentifier: "calendarView", sender: self)
    }
}

extension TutorialViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource{
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 4
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
        view.imageView.image = UIImage(named: "onboard\(index)")
        
        //Set the font and color for the labels:
        view.title.font = UIFont(name: "futura-Bold", size: 36)
        
        view.subTitle.font = UIFont(name: "futura", size: 22)
        view.subTitle.textAlignment = .center
        view.subTitle.numberOfLines = 20
        
        //Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray[index]
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        overlay.continueButton.setBackgroundImage(UIImage(named: "buttonOff")!, for: .normal)
        overlay.continueButton.setBackgroundImage(UIImage(named: "buttonOn")!, for: .highlighted)
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont(name: "futura-Bold", size: 36)
        
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.titleLabel?.font = UIFont(name: "futura-Bold", size: 22)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.continueButton.tag = Int(position)
        
        if currentPage != 3 {
            overlay.continueButton.setTitle("Continue", for: .normal)
            overlay.skipButton.setTitle("Skip", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Get Started!", for: .normal)
            overlay.continueButton.removeTarget(nil, action: nil, for: .allEvents)
            overlay.continueButton.addTarget(self, action: #selector(handleTutDone), for: .touchUpInside)
            overlay.skipButton.isHidden = true
        }
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor?{
            return colors[index]
    }

}
