//
//  EventCell.swift
//  Social Hippo
//
//  Created by James Gillin on 2/15/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
  
  @IBOutlet weak var eventTitle: UILabel!
  @IBOutlet weak var eventDesc: UILabel!
  @IBOutlet weak var eventImage: UIImageView!
  
  
  internal var event: SHEvent! {
    didSet {
      updateUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func updateUI() {
    self.eventTitle.text = event.title
    self.eventDesc.text = event.eventDescription
    //icon filenames correspond to event category string representations
    let filename = event.category.textRep.lowercaseString
    if let image = UIImage(named: filename) {
      self.eventImage.image = image
    }
    else {
      print("Error finding "+filename)
    }
  }
  
}
