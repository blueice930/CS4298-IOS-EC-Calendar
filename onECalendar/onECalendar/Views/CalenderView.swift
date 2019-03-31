//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

struct Colors {
    static var darkGray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.white
    static var monthViewBtnLeftColor = UIColor.white
    static var activeCellLblColor = UIColor.white
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.white
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    var numOfDaysInMonthEC = [31,29,31,30,31,30,31,30,30,31,30,31]
    var numOfDaysInMonthGG = [31,28,31,30,31,30,31,31,30,31,30,31]
    var isEC = true
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    func changeTheme() {
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func initializeView() {
        
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make august month of 31 days
        if isEC{
            if currentMonthIndex == 8 && currentYear % 4 == 0 && currentYear % 400 != 0 { //changed to correct formula - rohit
            numOfDaysInMonthEC[currentMonthIndex-1] = 31
            }
        }else{
            if currentMonthIndex == 2 && currentYear % 4 == 0 && currentYear % 400 != 0 { //changed to correct formula - rohit
                numOfDaysInMonthGG[currentMonthIndex-1] = 29
            }
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEC{
            return numOfDaysInMonthEC[currentMonthIndex-1] + firstWeekDayOfMonth - 1
        }else {
            return numOfDaysInMonthGG[currentMonthIndex-1] + firstWeekDayOfMonth - 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            
            //today
            if(calcDate == todaysDate && currentMonthIndex == presentMonthIndex && currentYear == presentYear)
            {
                cell.lbl.textColor = UIColor.white
                cell.backgroundColor = UIColor.red
            }
                //leap days
            else if(calcDate == 1 && currentMonthIndex == 12) || (currentMonthIndex == 8 && currentYear % 4 == 0 && currentYear % 400 != 0 && calcDate == 31)
            {
                if isEC{
                cell.backgroundColor=UIColor.orange
                    cell.lbl.text = "Extra Sat"
                    
                }
            }
                //past dates
            else if (calcDate < todaysDate && currentMonthIndex == presentMonthIndex) || (currentMonthIndex < presentMonthIndex && currentYear <= presentYear) || (currentYear < presentYear ){
                cell.isUserInteractionEnabled=true //changed from false - rohit
                cell.lbl.textColor = UIColor.lightGray
            }
                //normal dates in the future
            else {
                cell.isUserInteractionEnabled=true
                cell.lbl.textColor = Style.activeCellLblColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor=UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        if (calcDate < todaysDate && currentMonthIndex == presentMonthIndex) || (currentMonthIndex < presentMonthIndex && currentYear <= presentYear) || (currentYear < presentYear ){
            lbl.textColor = UIColor.lightGray
        }
        else if(calcDate == 1 && currentMonthIndex == 12) || (currentMonthIndex == 8 && currentYear % 4 == 0 && currentYear % 400 != 0 && calcDate == 31){
            if isEC{
                lbl.backgroundColor=UIColor.orange
                lbl.text = "Extra Sat"
            }
        }
        else if(calcDate == todaysDate && currentMonthIndex == presentMonthIndex && currentYear == presentYear)
        {
            cell?.backgroundColor=UIColor.red
        }
        else{
            lbl.backgroundColor = UIColor.clear
            lbl.textColor = Style.activeCellLblColor
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        if isEC{
            var firstWeekday : Int
            switch currentMonthIndex {
            case 1,4,7,10:
                firstWeekday = 1
            case 2,8,11:
                firstWeekday = 4
            case 3, 12:
                firstWeekday = 5
            case 6, 9:
                firstWeekday = 6
            case 5:
                firstWeekday = 3
            default:
                firstWeekday = 1
            }
            return firstWeekday
        }
        else{
            let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
            return day
        }
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        if isEC{
        //for leap year, make february month of 31 days
            if monthIndex == 7 {
                if currentYear % 4 == 0 && currentYear % 400 != 0 { //changed to correct formula - rohit
                    numOfDaysInMonthEC[monthIndex] = 31
                } else {
                    numOfDaysInMonthEC[monthIndex] = 30
                }
            }
            //end
            
            firstWeekDayOfMonth=getFirstWeekDay()
        }else{
            if monthIndex == 1 {
                if currentYear % 4 == 0 && currentYear % 400 != 0 { //changed to correct formula - rohit
                    numOfDaysInMonthGG[monthIndex] = 29
                } else {
                    numOfDaysInMonthGG[monthIndex] = 28
                }
            }
            //end
            
            firstWeekDayOfMonth=getFirstWeekDay()
        }
        myCollectionView.reloadData()
        
        monthView.btnLeft.isEnabled = true
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 75).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 60).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
    }
    
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v=WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
//    let tutorialBtn: UIView = {
//        let btn = UIView()
//        btn.backgroundColor = UIColor.red
////        btn.titleLabel?.textColor = UIColor.red
//        btn.frame = CGRect(x: 200, y: 600, width: 100, height: 50)
//        return btn
//    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 24)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}













