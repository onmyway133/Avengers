//
//  Constraints.swift
//  Avengers
//
//  Created by Khoa Pham on 03.05.2018.
//  Copyright © 2018 Fantageek. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
  public static func on(constraints: [NSLayoutConstraint]) {
    constraints.forEach {
      ($0.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
      $0.isActive = true
    }
  }
}

