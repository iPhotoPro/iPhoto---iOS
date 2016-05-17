//
//  IPaddingSliderView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/17/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

@objc protocol IPaddingSliderViewDelegate: class {
    optional func didChangeValue(slider: IPSlider, value: Int)
}

class IPaddingSliderView: UIView {
    
    let kPaddingMin: Int = 0
    let kPaddingDefault: Int = 10
    let kPaddingMax: Int = 30
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var slider: IPSlider!
    
    weak var delegate: IPaddingSliderViewDelegate?
    private var currentValue: Int = 0

    class func loadFromNib() -> IPaddingSliderView? {
        let objects = NSBundle.mainBundle().loadNibNamed("IPaddingSliderView", owner: self, options: nil)
        return objects.first as? IPaddingSliderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSilder(kPaddingDefault)
    }
    
    private func defaultSilder(value: Int) {
        slider.value = CGFloat(kPaddingDefault) / CGFloat(kPaddingMax - kPaddingMin)
        valueLabel.text = "\(kPaddingDefault)"
        minValueLabel.text = "\(kPaddingMin)"
        maxValueLabel.text = "\(kPaddingMax)"
        currentValue = kPaddingDefault
    }

    @IBAction func didChangeValue(sender: AnyObject) {
        if let control = sender as? IPSlider {
            let value = Int(ceil(control.value * CGFloat(kPaddingMax - kPaddingMin)))
            if value != kPaddingDefault {
                valueLabel.text = "\(value) | \(kPaddingDefault)"
            } else {
                valueLabel.text = "\(value)"
            }
            if value != currentValue {
                currentValue = value
                delegate?.didChangeValue?(control, value: value)
            }
        }
    }
    
}
