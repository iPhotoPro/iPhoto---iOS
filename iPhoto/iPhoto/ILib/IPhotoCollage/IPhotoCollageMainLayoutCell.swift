//
//  IPhotoCollageMainLayoutCell.swift
//  iPhoto
//
//  Created by ngodacdu on 5/17/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import QuartzCore

let kProcessRadiusImageViewNotificationName = "ProcessRadiusImageViewNotification"
let kProcessBorderImageViewNotificationName = "ProcessBorderImageViewNotification"
let kProcessBorderColorNotificationName = "ProcessBorderColorNotificationName"
let kProcessBorderTypeNotificationName = "ProcessBorderTypeNotificationName"

class IPhotoCollageMainLayoutCell: UICollectionViewCell {
    
    let distance: CGFloat = 5.0
    
    struct Constant {
        static let name = "IPhotoCollageMainLayoutCell"
        static let identifier = "IPhotoCollageMainLayoutCellIdentifier"
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var originPoint: CGPoint = CGPointZero
    private var previousScale: CGFloat = 1.0
    private var previousRadius: CGFloat = 0.0
    private var previousBorderWidth: CGFloat = 0.0
    private var previousBorderColor: UIColor = UIColor.grayColor()
    private var previousBorderType: Int = 0
    
    private var shapeLayer: CAShapeLayer!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(IPhotoCollageMainLayoutCell.gestureRecognizerMethod(_:))
        )
        addGestureRecognizer(panGesture)
        
        /*
         Tempory disable
         */
        /*
        let pinchGesture = UIPinchGestureRecognizer(
            target: self,
            action: #selector(IPhotoCollageMainLayoutCell.scaleImage(_:))
        )
        addGestureRecognizer(pinchGesture)
         */
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(processRadiusImageView(_:)),
            name: kProcessRadiusImageViewNotificationName,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(processBorderImageView(_:)),
            name: kProcessBorderImageViewNotificationName,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(processBorderColor(_:)),
            name: kProcessBorderColorNotificationName,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(processBorderType(_:)),
            name: kProcessBorderTypeNotificationName,
            object: nil
        )
    }
    
    override func layoutSubviews() {
        imageView.bounds = bounds
        updatePositionImage()
        updateRadius()
        updateBorder()
    }
    
    //MARK: Move use UIPanGestureRecognizer
    private func updatePositionImage() {
        if let image = imageView.image {
            let limitX = (image.size.width - imageView.bounds.width) / 2
            let isLeftLimitX = originPoint.x > limitX
            let isRightLimitX = originPoint.x < -limitX
            if isLeftLimitX || isRightLimitX {
                if isLeftLimitX {
                    imageView.frame.origin.x = limitX
                } else {
                    imageView.frame.origin.x = -limitX
                }
            }
            let limitY = (image.size.height - imageView.bounds.height) / 2
            let isTopLimitY = originPoint.y > limitY
            let isBottomLimitY = originPoint.y < -limitY
            if isTopLimitY || isBottomLimitY {
                if isTopLimitY {
                    imageView.frame.origin.y = limitY
                } else {
                    imageView.frame.origin.y = -limitY
                }
            }
        }
    }
    
    func gestureRecognizerMethod(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Began {
            originPoint = imageView.frame.origin
        }
        if gesture.state == .Changed {
            let location = gesture.locationInView(self)
            if !bounds.contains(location) {
                return
            }
            let translate = gesture.translationInView(imageView?.superview)
            if let image = imageView.image {
                let limitX = (image.size.width - imageView.bounds.width) / 2
                let isLeftLimitX = (originPoint.x + translate.x) > limitX
                let isRightLimitX = (originPoint.x + translate.x) < -limitX
                if isLeftLimitX || isRightLimitX {
                    if isLeftLimitX {
                        imageView.frame.origin.x = limitX
                    } else {
                        imageView.frame.origin.x = -limitX
                    }
                } else {
                    imageView.frame.origin.x = originPoint.x + translate.x
                }
                let limitY = (image.size.height - imageView.bounds.height) / 2
                let isTopLimitY = (originPoint.y + translate.y) > limitY
                let isBottomLimitY = (originPoint.y + translate.y) < -limitY
                if isTopLimitY || isBottomLimitY {
                    if isTopLimitY {
                        imageView.frame.origin.y = limitY
                    } else {
                        imageView.frame.origin.y = -limitY
                    }
                } else {
                    imageView.frame.origin.y = originPoint.y + translate.y
                }
            }
        }
        if gesture.state == .Ended {
            originPoint = imageView.frame.origin
        }
    }
    
    //MARK: Zoom use UIPinchGestureRecognizer
    /*
        Tempory disable
     */
    func scaleImage(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Ended {
            previousScale = 1.0
            return
        }
        let newScale = 1.0 - (previousScale - gesture.scale)
        let currentTransformation = imageView.transform
        let newTransform = CGAffineTransformScale(currentTransformation, newScale, newScale)
        imageView.transform = newTransform
        updateOriginImage(newScale)
        
        previousScale = gesture.scale
    }
    
    private func updateOriginImage(scale: CGFloat) {
        var currentOrigin = imageView.frame.origin
        currentOrigin.x = currentOrigin.x * scale
        currentOrigin.y = currentOrigin.y * scale
        imageView.frame.origin = currentOrigin
    }
    
    //MARK: Process corner radius
    func processRadiusImageView(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let radiusValue = userInfo, value = radiusValue["radius-value"] {
            previousRadius = CGFloat(value.floatValue)
            roundView(self, onCorner: .AllCorners, radius: previousRadius)
        }
    }
    
    private func updateRadius() {
        roundView(self, onCorner: .AllCorners, radius: previousRadius)
    }
    
    private func roundView(view: UIView, onCorner: UIRectCorner, radius: CGFloat) {
        let radiusPath = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: onCorner,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        if shapeLayer == nil {
            shapeLayer = CAShapeLayer()
        }
        shapeLayer.frame = view.bounds
        shapeLayer.path = radiusPath.CGPath
        view.layer.mask = shapeLayer
    }
    
    //MARK: Process border
    func processBorderImageView(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let radiusValue = userInfo, value = radiusValue["border-value"] {
            previousBorderWidth = CGFloat(value.floatValue)
            boderView(self, width: previousBorderWidth, color: previousBorderColor, type: previousBorderType)
        }
    }
    
    private func updateBorder() {
        boderView(self, width: previousBorderWidth, color: previousBorderColor, type: previousBorderType)
    }
    
    private func boderView(view: UIView, width: CGFloat, color: UIColor?, type: Int) {
        view.layer.borderWidth = width
        if let color = color {
            view.layer.borderColor = color.CGColor
        }
        switch type {
        case BorderOption.Normal.rawValue:
            break
        case BorderOption.Dash.rawValue:
            
            break
        case BorderOption.Dot.rawValue:
            break
        default:
            break
        }
    }
    
    func processBorderColor(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let radiusValue = userInfo, color = radiusValue["border-color"] as? UIColor {
            previousBorderColor = color
            boderView(self, width: previousBorderWidth, color: previousBorderColor, type: previousBorderType)
        }
    }
    
    func processBorderType(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let radiusValue = userInfo, type = radiusValue["border-type"] {
            previousBorderType = type.integerValue
            //Comming soon
        }
    }

}


