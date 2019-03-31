//
//  TutorialViewController.swift
//  onECalendar
//
//  Created by Ronnie Li on 3/31/19.
//  Copyright © 2019 Ronnie Li. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupViews()
        
        btnLeft.isEnabled=true
    }
    
    @objc func btnLeftRightAction(sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizer.Direction.left {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func setupViews() {
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        lblName.widthAnchor.constraint(equalToConstant: 250).isActive=true
        lblName.heightAnchor.constraint(equalToConstant: 100).isActive=true
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        
//        self.addSubview(btnRight)
//        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
//        btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
//        btnRight.widthAnchor.constraint(equalToConstant: 50).isActive=true
//        btnRight.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
//        
//        self.addSubview(btnLeft)
//        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
//        btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
//        btnLeft.widthAnchor.constraint(equalToConstant: 50).isActive=true
//        btnLeft.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
    }
    
    let lblName: UILabel = {
        let lbl=UILabel()
        lbl.text="Default Month Year text"
        lbl.textColor = Style.monthViewLblColor
        lbl.textAlignment = .center
        lbl.font=UIFont.boldSystemFont(ofSize: 28)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnRight: UIButton = {
        let btn=UIButton()
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn=UIButton()
        btn.setTitle("Prev", for: .normal)
        btn.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        return btn
    }()
    
    func setTitle(month: Int, year: Int) {
        currentMonthIndex = month
        currentYear = year
        lblName.text = "\(monthsArr[currentMonthIndex]) \(currentYear)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

