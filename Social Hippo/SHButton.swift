//
//  SHButton.swift
//  Social Hippo
//
//  Created by James Gillin on 2/15/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import UIKit

class SHButton: UIButton {

  override func awakeFromNib() {
    layer.cornerRadius = 3.0
    self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
  }
}
