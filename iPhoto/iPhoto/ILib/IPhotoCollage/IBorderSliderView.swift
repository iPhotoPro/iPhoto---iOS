//
//  IBorderSliderView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/19/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import ASValueTrackingSlider

protocol IBorderSliderViewDelegate: class {
    func didChangeValueBorder(slider: ASValueTrackingSlider, value: Float)
    func didSelectedBorderColor(colorView: IBorderColor, color: UIColor)
    func didSelectedBorderType(type: BorderOption)
}

class IBorderSliderView: UIView {

    let kBorderMin: Float = 0
    let kBorderMax: Float = 10
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var slider: ASValueTrackingSlider!
    
    private var borderColorView: IBorderColor!
    private var borderOptionView: IBorderOption!
    
    weak var delegate: IBorderSliderViewDelegate?
    private var currentValue: Float = 0
    
    class func loadFromNib() -> IBorderSliderView? {
        let objects = NSBundle.mainBundle().loadNibNamed("IBorderSliderView", owner: self, options: nil)
        return objects.first as? IBorderSliderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSilder()
    }
    
    func defaultSilder() {
        minValueLabel.text = "\(kBorderMin)"
        maxValueLabel.text = "\(kBorderMax)"
        slider.value = kBorderDefault
        slider.dataSource = self
        slider.minimumValue = kBorderMin
        slider.maximumValue = kBorderMax
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
                delegate?.didChangeValueBorder(control, value: value)
            }
        }
    }
    
    @IBAction func showBorderOption(sender: AnyObject) {
        if borderOptionView == nil {
            borderOptionView = IBorderOption.loadFromNib()
        }
        var borderOptionFrame = bounds
        borderOptionFrame.origin.x = bounds.width
        borderOptionView.frame = borderOptionFrame
        borderOptionView.delegate = self
        addSubview(borderOptionView)
        borderOptionFrame.origin.x = 0
        UIView.animateWithDuration(0.25) {
            self.borderOptionView.frame = borderOptionFrame
        }
    }

    @IBAction func showColorMenu(sender: AnyObject) {
        if borderColorView == nil {
            borderColorView = IBorderColor.loadFromNib()
        }
        var borderColorFrame = bounds
        borderColorFrame.origin.x = bounds.width
        borderColorView.frame = borderColorFrame
        borderColorView.delegate = self
        addSubview(borderColorView)
        borderColorFrame.origin.x = 0
        UIView.animateWithDuration(0.25) { 
            self.borderColorView.frame = borderColorFrame
        }
    }
    
}

extension IBorderSliderView: ASValueTrackingSliderDataSource, IBorderColorDelegate, IBorderOptionDelgate {
    
    func slider(slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        return "\(Int(slider.value)) | \(Int(kBorderDefault))"
    }
    
    func didSelectedColor(color: IBorderColor, code: String) {
        delegate?.didSelectedBorderColor(color, color: UIColor(hexa: code))
    }
    
    func didSelectedBorderType(type: BorderOption) {
        delegate?.didSelectedBorderType(type)
    }
    
}
