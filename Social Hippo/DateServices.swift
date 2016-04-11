//
//  DateServices.swift
//  Social Hippo
//
//  Created by James Gillin on 3/21/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import Foundation

class DateServices {
  
  static func predicateForToday() -> NSPredicate {
    let userCalendar = NSCalendar.currentCalendar()
    let date = NSDate()
    let year = userCalendar.component(.Year, fromDate: date)
    let month = userCalendar.component(.Month, fromDate: date)
    let day = userCalendar.component(.Day, fromDate: date)
    return NSPredicate(format: "Date_Year >= %@ && Date_Month == %@ && Date_Day == %@", argumentArray: [year, month, day])
  }
  
  static func stringForToday() -> String {
    let userCalendar = NSCalendar.currentCalendar()
    let date = NSDate()
    let year = userCalendar.component(.Year, fromDate: date)
    let month = userCalendar.component(.Month, fromDate: date)
    let day = userCalendar.component(.Day, fromDate: date)
    return "\(year)\(month)\(day)"
  }
  
  // Resets this client's request quota if this is a new day
  static func checkRequestQuota() {
    let today = DateServices.stringForToday()
    if NSUserDefaults.standardUserDefaults().stringForKey(Const.TodayKey) != today {
      NSUserDefaults.standardUserDefaults().setInteger(0, forKey: Const.RequestsTodayKey)
      NSUserDefaults.standardUserDefaults().setValue(today, forKey: Const.TodayKey)
      print("Set a new 'today' value: "+today)
    }
  }
  
}