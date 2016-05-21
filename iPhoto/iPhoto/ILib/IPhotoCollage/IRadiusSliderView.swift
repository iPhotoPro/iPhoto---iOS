//
//  IRadiusSliderView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/19/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import ASValueTrackingSlider

@objc protocol IRadiusSliderViewDelegate: class {
    optional func didChangeValueRadius(slider: ASValueTrackingSlider, value: Float)
}

class IRadiusSliderView: UIView {

    let kRadiusMin: Float = 0.0
    let kRadiusMax: Float = 50.0
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var slider: ASValueTrackingSlider!
    
    weak var delegate: IRadiusSliderViewDelegate?
    private var currentValue: Float = 0
    
    class func loadFromNib() -> IRadiusSliderView? {
        let objects = NSBundle.mainBundle().loadNibNamed("IRadiusSliderView", owner: self, options: nil)
        return objects.first as? IRadiusSliderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSilder()
    }
    
    func defaultSilder() {
        minValueLabel.text = "\(kRadiusMin)"
        maxValueLabel.text = "\(kRadiusMax)"
        slider.value = kRadiusDefault
        slider.dataSource = self
        slider.minimumValue = kRadiusMin
        slider.maximumValue = kRadiusMax
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
                delegate?.didChangeValueRadius?(control, value: value)
            }
        }
    }

}

extension IRadiusSliderView: ASValueTrackingSliderDataSource {
    
    func slider(slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        return "\(Int(slider.value)) | \(Int(kRadiusDefault))"
    }
    
}
