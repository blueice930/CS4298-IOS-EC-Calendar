//
//  OldCalendarViewController.swift
//  onECalendar
//
//  Created by Ronnie Li on 3/31/19.
//  Copyright © 2019 Ronnie Li. All rights reserved.
//

import UIKit
import JTAppleCalendar

class OldCalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        print("test a")
    }
    
//    func setup() {
//        let a = UIView()
//        a.backgroundColor = UIColor.red
//        print("arrived new vc")
//        self.view.addSubview(a)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OldCalendarViewController: JTAppleCalendarViewDelegate ,JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "MyCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        return cell
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.calendar.firstWeekday = 3

        let s = formatter.date(from: "2019 03 01")!
        let e = formatter.date(from: "2019 04 30")!


        let params = ConfigurationParameters(startDate: s, endDate: e)
        return params
    }
    
    
}
