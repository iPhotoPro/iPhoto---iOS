//
//  IPaddingSliderView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/17/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import ASValueTrackingSlider

@objc protocol IPaddingSliderViewDelegate: class {
    optional func didChangeValuePadding(slider: ASValueTrackingSlider, value: Float)
}

class IPaddingSliderView: UIView {
    
    let kPaddingMin: Float = 0.0
    let kPaddingMax: Float = 30.0
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var slider: ASValueTrackingSlider!
    
    weak var delegate: IPaddingSliderViewDelegate?
    private var currentValue: Float = 0

    class func loadFromNib() -> IPaddingSliderView? {
        let objects = NSBundle.mainBundle().loadNibNamed("IPaddingSliderView", owner: self, options: nil)
        return objects.first as? IPaddingSliderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSilder()
    }
    
    func defaultSilder() {
        minValueLabel.text = "\(kPaddingMin)"
        maxValueLabel.text = "\(kPaddingMax)"
        slider.value = kPaddingDefault
        slider.dataSource = self
        slider.minimumValue = kPaddingMin
        slider.maximumValue = kPaddingMax
        slider.setThumbImage(UIImage(named: "collage-slider-thumb"), forState: .Normal)
        slider.setThumbImage(UIImage(named: "collage-slider-thumb"), forState: .Highlighted)
        slider.popUpViewCornerRadius = 2.0
        slider.setMaxFractionDigitsDisplayed(0)
        slider.popUpViewColor = UIColor.whiteColor()
        slider.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 13)
        slider.textColor = UIColor(hexa: "1ABC9C")
        slider.popUpViewWidthPaddingFactor = 1.7
        slider.popUpViewHeightPaddingFactor = 1.5
    }

    @IBAction func didChangeValue(sender: AnyObject) {
        if let control = sender as? ASValueTrackingSlider {
            let value = control.value
            if value != currentValue {
                currentValue = value
                delegate?.didChangeValuePadding?(control, value: value)
            }
        }
    }
    
}

extension IPaddingSliderView: ASValueTrackingSliderDataSource {
    
    func slider(slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        return "\(Int(slider.value)) | \(Int(kPaddingDefault))"
    }
    
}
