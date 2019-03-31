//
//  TutorialViewController.swift
//  onECalendar
//
//  Created by Ronnie Li on 3/31/19.
//  Copyright © 2019 Ronnie Li. All rights reserved.
//
import UIKit

class WeekdaysView: UIView {
    var isEC = true
    var viewIsEdit = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        var daysArrEC = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        var daysArrGG = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for labels in myStackView.subviews as [UIView] {
            labels.removeFromSuperview()
        }
        for i in 0..<7 {
            let lbl=UILabel()
            if isEC {
                lbl.text=daysArrEC[i]
            }else{
                lbl.text=daysArrGG[i]
            }
            lbl.textAlignment = .center
            lbl.textColor = Style.weekdaysLblColor
            lbl.font=UIFont.boldSystemFont(ofSize: 24)
            lbl.translatesAutoresizingMaskIntoConstraints=false
            myStackView.addArrangedSubview(lbl)
        }
    }
    
    let myStackView: UIStackView = {
        let stackView=UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints=false
        return stackView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

