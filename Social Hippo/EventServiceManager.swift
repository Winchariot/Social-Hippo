//
//  EventService.swift
//  Social Hippo
//
//  Created by James Gillin on 3/2/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import Foundation

class EventServiceManager {
  private var services = [EventService]()
  weak private var associatedVC: MasterViewController!
  
  func fetchEvents() {
    //grab events from each of our registered services
    for service in services {
      service.getEvents()
    }
  }
  
  init(viewController: MasterViewController) {
    self.associatedVC = viewController
    let cloudKitService = CloudKitService.sharedInstance
    cloudKitService.delegate = self.associatedVC
    services.append(cloudKitService)
    //services.append(otherApiService) ...
  }
}

//Child services implement this
protocol EventService {
  func getEvents()
}

//VC implements this
protocol EventServiceDelegate {
  func eventsRetrieved(events: [SHEvent])
  func errorUpdating(error: NSError)
}