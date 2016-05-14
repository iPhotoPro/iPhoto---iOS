//
//  IPhotoSliderView.swift
//  Example
//
//  Created by ngodacdu on 5/12/16.
//  Copyright © 2016 Wojtek Lukaszuk. All rights reserved.
//

import UIKit

@objc protocol IPhotoSliderViewDelegate: class {
    optional func didChangeValue(slider: IPSlider, value: CGFloat)
    optional func didTouchUpInsideCancelButton()
    optional func didTouchUpInsideDoneButton()
}

class IPhotoSliderView: UIView {

    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var slider: IPSlider!
    
    weak var delegate: IPhotoSliderViewDelegate?
    
    class func loadFromNib() -> IPhotoSliderView? {
        let objects = NSBundle.mainBundle().loadNibNamed("IPhotoSliderView", owner: self, options: nil)
        return objects.first as? IPhotoSliderView
    }

    @IBAction func didChangeValue(sender: AnyObject) {
        if let control = sender as? IPSlider {
            valueLabel.text = String(format: "%0.2f", control.value)
            delegate?.didChangeValue?(control, value: control.value)
        }
    }
    
    @IBAction func didTouchUpInsideCancelButton(sender: AnyObject) {
        delegate?.didTouchUpInsideCancelButton?()
    }
    
    @IBAction func didTouchUpInsideDoneButton(sender: AnyObject) {
        delegate?.didTouchUpInsideDoneButton?()
    }
    
}
