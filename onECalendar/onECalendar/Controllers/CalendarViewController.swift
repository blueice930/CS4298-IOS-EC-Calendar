//
//  CalendarViewController.swift
//  onECalendar
//
//  Created by Ronnie Li on 3/31/19.
//  Copyright © 2019 Ronnie Li. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
    case dark
}

class CalendarViewController: UIViewController {
    var isEc = true
    var themeIsDark = true
    
    let tutBtn = UIButton(type: .system) as UIButton
    let switchBtn = UIButton(type: .system) as UIButton
    
    var theme = MyTheme.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Calendar"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 1000).isActive=true
        
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        setSwitchBtn()
        setTutBtn()
    }
    
    func setSwitchBtn(){
        switchBtn.frame = CGRect(x:50, y:100, width:150, height:45)
       
        switchBtn.backgroundColor = UIColor.lightGray
        
        if isEc{
            switchBtn.setTitle("EC Calendar", for: .normal)
        }else{
            switchBtn.setTitle("Gregorian Calendar", for: .normal)
        }
        switchBtn.tintColor = UIColor.black
        switchBtn.addTarget(self, action: #selector(switchCalendar), for: .touchUpInside)
        
        self.view.addSubview(switchBtn)
    }
    
    func setTutBtn() {
        tutBtn.frame = CGRect(x: 50, y: 500, width: 150, height: 45)
        tutBtn.layer.cornerRadius = tutBtn.layer.borderWidth/2
        
        tutBtn.backgroundColor = UIColor.red
        tutBtn.setTitle("Go through Tutorials?", for: .normal)
        tutBtn.addTarget(self, action: #selector(handleQuestion), for: .touchDown)
        
        self.view.addSubview(tutBtn)
    }
    
    //Function to Print to console Swipe Direction, and Change the label to show the directions. The @objc before func is a must, since we are using #selector (above). You can add to the function, in my case, I'll add a sound, so when someone flips the page, it plays a page sound.
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            calenderView.monthView.btnLeftRightAction(sender: gesture)
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            calenderView.monthView.btnLeftRightAction(sender: gesture)
        }
    }
    
    @objc func handleQuestion() {
        performSegue(withIdentifier: "tutView", sender: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }
    
    @objc func gotoTodayAction(sender: UIEvent.EventSubtype) {
        let month = Calendar.current.component(.month, from: Date()) - 1
        let year = Calendar.current.component(.year, from: Date())
        calenderView.monthView.setTitle(month: month, year: year)
        calenderView.didChangeMonth(monthIndex: month, year: year)
    }
    
    @objc func switchCalendar(sender: UIButton){
        isEc = !isEc
        
        if isEc{
            switchBtn.setTitle("EC Calendar", for: .normal)
            calenderView.isEC = true
            calenderView.weekdaysView.isEC = true
        }else{
            switchBtn.setTitle("Gregorian Calendar", for: .normal)
            calenderView.isEC = false
            calenderView.weekdaysView.isEC = false
        }
        calenderView.weekdaysView.setupViews()
        calenderView.didChangeMonth(monthIndex: calenderView.currentMonthIndex-1, year: calenderView.currentYear)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            self.gotoTodayAction(sender: .motionShake)
        }
    }
    
    let calenderView: CalenderView = {
        let v=CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
}
