//
//  IBackgroundColor.swift
//  iPhoto
//
//  Created by ngodacdu on 5/20/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IBackgroundColor: UIView {

    class func loadFromNib() -> IBackgroundColor? {
        let objects = NSBundle.mainBundle().loadNibNamed("IBackgroundColor", owner: self, options: nil)
        return objects.first as? IBackgroundColor
    }

}
