//
//  IPSlider.swift
//  Example
//
//  Created by ngodacdu on 5/11/16.
//  Copyright © 2016 Wojtek Lukaszuk. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

@IBDesignable class IPSlider: UIControl {

    private static let valueDefault: CGFloat = 0.5
    private let maxTrackLayerAlpha: CGFloat = 0.5
    
    private let trackLayerHeight: CGFloat = 2.0
    private let maxTiltAngle: CGFloat = CGFloat(M_PI / 36)
    private var thumbLayer: CAShapeLayer = CAShapeLayer()
    private var minTrackLayer: CALayer = CALayer()
    private var maxTrackLayer: CALayer = CALayer()
    private var previousTouchPoint: CGPoint = CGPointZero
    
    private enum Direction {
        case Left
        case Right
    }
    
    private var trackLayerWidth: CGFloat {
        return bounds.width
    }
    
    internal var value: CGFloat = valueDefault {
        didSet {
            thumbLayer.position.x = value * bounds.width
            minTrackLayer.frame.size.width = value * bounds.width
        }
    }
    
    @IBInspectable internal var thumbTintColor: UIColor = UIColor.whiteColor() {
        didSet {
            thumbLayer.fillColor = thumbTintColor.CGColor
        }
    }
    
    @IBInspectable internal var trackTintColor: UIColor = UIColor.whiteColor()  {
        didSet {
            minTrackLayer.backgroundColor = trackTintColor.CGColor
            maxTrackLayer.backgroundColor = trackTintColor.colorWithAlphaComponent(maxTrackLayerAlpha).CGColor
        }
    }
    
    @IBInspectable internal var thumbImage: UIImage? {
        didSet {
            thumbLayer.contents = thumbImage!.CGImage
            thumbLayer.frame.size = thumbImage!.size
            thumbLayer.position = CGPointMake(value * trackLayerWidth, trackLayerHeight)
            thumbLayer.path = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        maxTrackLayer = CALayer()
        maxTrackLayer.frame = CGRectMake(
            0,
            0,
            trackLayerWidth,
            trackLayerHeight
        )
        maxTrackLayer.backgroundColor = trackTintColor.colorWithAlphaComponent(maxTrackLayerAlpha).CGColor
        layer.addSublayer(maxTrackLayer)
        
        minTrackLayer = CALayer()
        minTrackLayer.frame = CGRectMake(
            0,
            0,
            value * trackLayerWidth,
            trackLayerHeight
        )
        minTrackLayer.backgroundColor = trackTintColor.CGColor
        layer.addSublayer(minTrackLayer)
        
        thumbLayer = CAShapeLayer()
        thumbLayer.frame = CGRectMake(
            0,
            0,
            33,
            33
        )
        thumbLayer.path = defaultThumbMaskPath()
        thumbLayer.fillColor = thumbTintColor.CGColor
        thumbLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
        thumbLayer.position = CGPointMake(value * trackLayerWidth, trackLayerHeight)
        layer.addSublayer(thumbLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        maxTrackLayer.frame = CGRectMake(0, 0, trackLayerWidth, trackLayerHeight)
        minTrackLayer.frame = CGRectMake(0, 0, value * trackLayerWidth, trackLayerHeight)
        thumbLayer.position = CGPointMake(value * trackLayerWidth, trackLayerHeight)
    }
    
    // MARK: tracking behaviour
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousTouchPoint = touch.locationInView(self)
        if CGRectContainsPoint(thumbLayer.frame, previousTouchPoint) {
            if let thumb = thumbLayer.presentationLayer() {
                thumbLayer.transform = thumb.transform
                thumbLayer.removeAllAnimations()
                return true
            }
        }
        return false
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint = touch.locationInView(self)
        let deltaX: CGFloat = touchPoint.x - previousTouchPoint.x
        previousTouchPoint = touchPoint
        let currentTiltAngle: CGFloat = thumbLayer.valueForKeyPath("transform.rotation.z") as! CGFloat
        
        var direction = Direction.Right
        var currentMaxTiltAngle: CGFloat = -maxTiltAngle
        
        if deltaX < 0 {
            direction = Direction.Left
            currentMaxTiltAngle = maxTiltAngle
        }
        
        if !isMaxTitled(direction, angle: currentTiltAngle) {
            var transform: CATransform3D = CATransform3DRotate(thumbLayer.transform, CGFloat(-M_PI / 180) * deltaX, 0, 0, 1)
            let calculatedTitlAngle: CGFloat = atan2(transform.m12, transform.m11)
            if isMaxTitled(direction, angle: calculatedTitlAngle) {
                transform = CATransform3DRotate(CATransform3DIdentity, currentMaxTiltAngle, 0, 0, 1)
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            thumbLayer.transform = transform
            CATransaction.commit()
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let newValue = (thumbLayer.position.x + deltaX) / trackLayerWidth
            value = min(max(newValue, 0.0), 1.0)
            CATransaction.commit()
        }
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
        return true
    }
    
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        thumbSpringAnimation()
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        thumbSpringAnimation()
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(thumbLayer.frame, point) {
            return true
        }
        return super.pointInside(point, withEvent: event)
    }
    
    // MARK: helpers
    private func isMaxTitled(direction : Direction, angle: CGFloat) -> Bool {
        switch(direction) {
        case .Left:
            return angle >= maxTiltAngle
        case .Right:
            return angle <= -maxTiltAngle
        }
    }
    
    private func thumbSpringAnimation() {
        let animation = IPAnimation(keyPath: "transform.rotation.z")
        let rotation = (thumbLayer.valueForKeyPath("transform.rotation.z") as? NSNumber)?.floatValue ?? 0.0
        animation.fromValue = CGFloat(rotation)
        animation.toValue = 0
        thumbLayer.addAnimation(animation, forKey: nil)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        thumbLayer.transform = CATransform3DIdentity
        CATransaction.commit()
    }
    
    private func defaultThumbMaskPath() -> CGPath {
        let bezierPath = UIBezierPath()
        
        let distance: CGFloat = 10.0
        let outRadius: CGFloat = 20.0
        var origin: CGPoint = CGPoint(x: outRadius, y: distance / 2)
        
        bezierPath.moveToPoint(origin)
        bezierPath.addLineToPoint(CGPoint(x: origin.x + distance, y: 2 * origin.y))
        bezierPath.addLineToPoint(CGPoint(x: origin.x, y: origin.y - distance / 2))
        bezierPath.addLineToPoint(CGPoint(x: origin.x - distance, y: 2 * origin.y))
        bezierPath.addLineToPoint(origin)
        
        drawCircle(bezierPath, origin: origin, radius: outRadius, numSegment: 4)
        
        let inRadius: CGFloat = outRadius - 10.0
        origin.y = origin.y + 15.0
        bezierPath.moveToPoint(origin)
        drawCircle(bezierPath, origin: origin, radius: inRadius, numSegment: 4)
        
        return bezierPath.CGPath
    }

    private func drawCircle(currentPath: UIBezierPath, origin: CGPoint, radius: CGFloat, numSegment: Int) {
        let angle: CGFloat = CGFloat(M_PI) / CGFloat(2 * numSegment)
        let optimal: CGFloat = radius * tan(angle) * (4 / 3)
        
        currentPath.addCurveToPoint(
            CGPoint(x: origin.x - radius, y: origin.y + radius),
            controlPoint1: CGPoint(x: origin.x - optimal, y: origin.y),
            controlPoint2: CGPoint(x: origin.x - radius, y: origin.y + radius - optimal)
        )
        currentPath.addCurveToPoint(
            CGPoint(x: origin.x, y: origin.y + 2 * radius),
            controlPoint1: CGPoint(x: origin.x - radius, y: origin.y + radius + optimal),
            controlPoint2: CGPoint(x: origin.x - optimal, y: origin.y + 2 * radius)
        )
        currentPath.addCurveToPoint(
            CGPoint(x: origin.x + radius, y: origin.y + radius),
            controlPoint1: CGPoint(x: origin.x + optimal, y: origin.y + 2 * radius),
            controlPoint2: CGPoint(x: origin.x + radius, y: origin.y + radius + optimal)
        )
        currentPath.addCurveToPoint(
            origin,
            controlPoint1: CGPoint(x: origin.x + radius, y: origin.y + radius - optimal),
            controlPoint2: CGPoint(x: origin.x + optimal, y: origin.y)
        )
        currentPath.closePath()
    }
    
}
