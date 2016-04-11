//
//  CloudKitService.swift
//  Social Hippo
//
//  Created by James Gillin on 3/2/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitService: EventService {
  static let sharedInstance = CloudKitService()
  var delegate: EventServiceDelegate?
  let publicDB = CKContainer.defaultContainer().publicCloudDatabase
  
  private init() {
    //enforce singleton
  }
  
  func getEvents() {
    //this cap should never get hit unless the user is purposefully spamming
    var requestsMadeToday = NSUserDefaults.standardUserDefaults().integerForKey(Const.RequestsTodayKey)
    if requestsMadeToday >= Const.DailyRequestCap {
      let error = NSError(domain: "CloudKit", code: 110, userInfo: [NSLocalizedDescriptionKey : "You have exceeded the daily request cap from this client"])
      self.delegate?.errorUpdating(error)
      return
    }
    else {
      requestsMadeToday += 1
      NSUserDefaults.standardUserDefaults().setInteger(requestsMadeToday, forKey: Const.RequestsTodayKey)
      print("Request quota: \(requestsMadeToday)/\(Const.DailyRequestCap)")
    }
    
    var newEvents = [SHEvent]()
    let predicate = DateServices.predicateForToday() //only grab today's events
    //TODO: to save on requests, we will query say 7 days' worth at once and cache them locally
    let query = CKQuery(recordType: "SHEvent", predicate: predicate)
    let operation = CKQueryOperation(query: query)
    
    operation.recordFetchedBlock = { record in
      guard let event = SHEvent(record: record) else { return }
      newEvents.append(event)
    }
    
    operation.queryCompletionBlock  = { [unowned self] (cursor, error) in
      dispatch_async(dispatch_get_main_queue()) {
        if let errorReturned = error {
          self.delegate?.errorUpdating(errorReturned)
        }
        else
        {
          self.delegate?.eventsRetrieved(newEvents)
        }
      }
    }
    
    publicDB.addOperation(operation) //executes the operation asynchronously
  }

}