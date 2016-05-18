//
//  IRadiusSliderView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/19/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IRadiusSliderView: UIView {

    let kPaddingMin: Int = 0
    let kPaddingMax: Int = 10
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var slider: IPSlider!
    
    class func loadFromNib() -> IRadiusSliderView? {
        let objects = NSBundle.mainBundle().loadNibNamed("IRadiusSliderView", owner: self, options: nil)
        return objects.first as? IRadiusSliderView
    }
    
    @IBAction func didChangeValue(sender: AnyObject) {
        if let control = sender as? IPSlider {
            let value = Int(ceil(control.value * CGFloat(kPaddingMax - kPaddingMin)))
            
        }
    }

}
