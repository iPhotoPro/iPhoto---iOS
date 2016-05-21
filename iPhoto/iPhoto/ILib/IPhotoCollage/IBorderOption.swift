//
//  IBorderOption.swift
//  iPhoto
//
//  Created by ngodacdu on 5/21/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

enum BorderOption: Int {
    case Normal
    case Dash
    case Dot
}

protocol IBorderOptionDelgate: class {
    func didSelectedBorderType(type: BorderOption)
}

class IBorderOption: UIView {
    
    weak var delegate: IBorderOptionDelgate?

    class func loadFromNib() -> IBorderOption? {
        let objects = NSBundle.mainBundle().loadNibNamed("IBorderOption", owner: self, options: nil)
        return objects.first as? IBorderOption
    }

    @IBAction func closeBorderOption(sender: AnyObject) {
        var currentFrame = frame
        currentFrame.origin.x = frame.width
        UIView.animateWithDuration(0.25, animations: {
            self.frame = currentFrame
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func didTouchUpInsideLineNormal(sender: AnyObject) {
        delegate?.didSelectedBorderType(.Normal)
    }
    
    @IBAction func didTouchUpInsideLineDash(sender: AnyObject) {
        delegate?.didSelectedBorderType(.Dash)
    }
    
    @IBAction func didTouchUpInsideLineDot(sender: AnyObject) {
        delegate?.didSelectedBorderType(.Dot)
    }
    
}
