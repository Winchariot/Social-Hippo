//
//  SHEvent.swift
//  Social Hippo
//
//  Created by James Gillin on 2/15/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

struct SHEvent {
  let title: String!
  let eventDescription: String!
  let category: SHCategory!
  var hashtags: [String]?
  var readMore: String? //URL to related site
  var image: UIImage?
  var caption: String?
  
  //Unused
  init(title: String, eventDescription: String, category: Int) {
    self.title = title
    self.eventDescription = eventDescription
    self.category = category <= Const.SHCategory_Max ? SHCategory(rawValue: category)! : SHCategory.Observation
  }
  
  init?(record: CKRecord) {
    //required fields
    guard let title = record["Title"] as? String else { return nil}
    guard let eventDesc = record["Description"] as? String else { return nil }
    guard let category = record["Category"] as? Int else { return nil }
    self.title = title
    self.eventDescription = eventDesc
    self.category = category <= Const.SHCategory_Max ? SHCategory(rawValue: category)! : SHCategory.Observation
    
    //optional fields
    if let hashtags = record["Hashtags"] as? [String] {
      self.hashtags = hashtags
    }
    if let readMore = record["ReadMore"] as? String {
      self.readMore = readMore
    }
  }
}

//IMPORTANT: when new values are added to SHCategory, update Const.SHCategory_Max
enum SHCategory: Int {
  case Holiday = 0, Astronomical, Birthday, Calendar_Event, Celebration, Observation, Religious, Reminder
  var textRep: String {
    switch self {
    case .Holiday: return "Holiday"
    case .Astronomical: return "Astronomical"
    case .Birthday: return "Birthday"
    case .Calendar_Event: return "Calendar Event"
    case .Celebration: return "Celebration"
    case .Observation: return "Observation"
    case .Religious: return "Religious"
    case .Reminder: return "Reminder"
    }
  }
}