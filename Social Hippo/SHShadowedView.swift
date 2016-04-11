//
//  SHShadowedView.swift
//  Social Hippo
//
//  Created by James Gillin on 2/15/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import UIKit

class SHShadowedView: UIView {

  override func awakeFromNib() {
    layer.cornerRadius = 3.0
    layer.shadowColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1.0).CGColor
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 5.0
    layer.shadowOffset = CGSizeMake(0.0, 3.0)
  }
}
