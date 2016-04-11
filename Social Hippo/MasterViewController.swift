//
//  MasterViewController.swift
//  Social Hippo
//
//  Created by James Gillin on 2/15/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import UIKit
import SafariServices

class MasterViewController: UITableViewController {
  
  var detailViewController: DetailViewController? = nil
  var events = [SHEvent]()
  var activityIndicator: UIActivityIndicatorView!
  var eventsLoadedForDate = ""
  var ESM: EventServiceManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let split = self.splitViewController {
      let controllers = split.viewControllers
      self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    
    //Prevent drawing cell separators for empty cells
    tableView.tableFooterView = UIView(frame: CGRectZero)
    
    //Social Hippo logo in nav bar
    let logo = UIImage(named: "logo-s")
    let imageView = UIImageView(image:logo)
    self.navigationItem.titleView = imageView
    
    self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    self.activityIndicator.color = UIColor(red: 32/255, green: 180/255, blue: 76/255, alpha: 1)
    self.activityIndicator.hidesWhenStopped = true
    self.activityIndicator.userInteractionEnabled = false
    tableView.backgroundView = activityIndicator
    
    self.ESM = EventServiceManager(viewController: self)
    populateEventTable()
  }
  
  override func viewWillAppear(animated: Bool) {
    self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
    super.viewWillAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.populateEventTable), name: UIApplicationDidBecomeActiveNotification, object:nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func populateEventTable() {
    //load new events if we haven't yet grabbed today's
    let today = DateServices.stringForToday()
    if self.eventsLoadedForDate != today {
      //wipe out any events from old dates
      self.events = []
      tableView.reloadData()
      
      guard let ESM = self.ESM else { return }
      self.activityIndicator.startAnimating()
      //grab today's events from Event Service Manager
      ESM.fetchEvents()
      self.eventsLoadedForDate = today
    }
  }
  
  // MARK: - Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let event = events[indexPath.row]
        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
        controller.detailItem = event
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
  
  // MARK: - Table View
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier(Const.eventCell, forIndexPath: indexPath) as? EventCell else {
      let cell = EventCell()
      return cell
    }
    cell.event = events[indexPath.row]
    return cell
  }
  
}

//MARK: - EventServiceDelegate

extension MasterViewController: EventServiceDelegate {
  func eventsRetrieved(events: [SHEvent]) {
    
    self.activityIndicator.stopAnimating()
    if events.count > 0 {
      self.events += events
      tableView.reloadData()
    }
  }
  func errorUpdating(error: NSError) {
    self.activityIndicator.stopAnimating()
    print(error.localizedDescription)
  }
}
