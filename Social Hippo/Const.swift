//
//  Const.swift
//  Social Hippo
//
//  Created by James Gillin on 2/15/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import Foundation

struct Const {
  static let eventCell = "EventCell"
  static let SHCategory_Max = 7
  static let instaURL = NSURL(string: "instagram://camera")!
  //CloudKit
  static let DailyRequestCap = 20 //number of times we allow 1 client to poll CloudKit
  static let RequestsTodayKey = "requestsMadeToday"
  static let TodayKey = "keyForToday"
}