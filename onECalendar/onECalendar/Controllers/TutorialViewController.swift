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
    let colors:[UIColor] = [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.8053434491, green: 0.3954387307, blue: 0.3358164728, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),#colorLiteral(red: 0.4444106817, green: 0.7408292294, blue: 0.4954127669, alpha: 1)]
    var titleArray: [String] =
        [
            "Welcome to onECalendar!",
            
            "What is the EC-Calendar?",
            
            "What is the EC-Calendar?",
            
            "What is onECalendar?"
    ]
    
    var subTitleArray: [String] =
        [
            "The EC Calendar is a perennial calendar system with an easier and more practical week and month system",
            
            "It has 52 consistent weeks per year \nEvery year starts on a Monday and ends on a Sunday\nFebruary always has 29 days",
            
            "An extra Saturday is added on the 1st of December every year\nAnother extra Saturday on the 31st of August every leap year!",
            
            "Pros\t\t\tCons\nNo need for new calendars every year\tDifficult to make the transition\nAll quarters are equal and consistent\nSet dates for festivals and events like Easter\n\nWe’re here to make that transition easier for you!"
            
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
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
        print("continue")
    }
    
    @objc func handleTutDone(sender: UIButton) {
//        let next:OldCalendarViewController = OldCalendarViewController()
//        self.present(next, animated: true, completion: nil)
        print("start")
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
        view.title.textColor = UIColor.red
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
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont(name: "futura-Bold", size: 40)
        
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
