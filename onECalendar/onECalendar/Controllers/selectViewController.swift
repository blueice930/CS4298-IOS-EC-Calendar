//
//  testViewController.swift
//  onECalendar
//
//  Created by Ronnie Li on 4/1/19.
//  Copyright © 2019 Ronnie Li. All rights reserved.
//

import UIKit
import ADDatePicker

class selectViewController: UIViewController {
    
    @IBOutlet weak var datePicker: ADDatePicker!
    
    @IBOutlet weak var btnGetDate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customDatePicker1()
        
    }
    func customDatePicker1(){
        datePicker.yearRange(inBetween: 1950, end: 2050)
        datePicker.selectionType = .roundedsquare
        datePicker.bgColor = #colorLiteral(red: 0.3444891578, green: 0.5954311329, blue: 0.6666666865, alpha: 1)
        datePicker.deselectTextColor = UIColor.init(white: 1.0, alpha: 0.7)
        datePicker.deselectedBgColor = .clear
        datePicker.selectedBgColor = .white
        datePicker.selectedTextColor = .white
        datePicker.intialDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        datePicker.delegate = self
    }
    @IBAction func getDate(_ sender: UIButton) {
        let date = datePicker.getSelectedDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        btnGetDate.setTitle(dateformatter.string(from: date) , for: .normal)
    }
   
}
//
extension selectViewController: ADDatePickerDelegate {
    func ADDatePicker(didChange date: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        btnGetDate.setTitle(dateformatter.string(from: date) , for: .normal)
    }
}
