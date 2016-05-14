//
//  IPAnimation.swift
//  Example
//
//  Created by ngodacdu on 5/11/16.
//  Copyright © 2016 Wojtek Lukaszuk. All rights reserved.
//

import QuartzCore

class IPAnimation: CAKeyframeAnimation {
    
    var damping: CGFloat = 10.0
    var mass: CGFloat = 1.0
    var stiffness: CGFloat = 300.0
    var velocity: CGFloat = 0
    var fromValue: CGFloat = 0.0
    var toValue: CGFloat = 0.0
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! IPAnimation
        self.duration = durationForEpsilon(0.01)
        copy.values = interpolatedValues()
        copy.duration = duration
        copy.mass = mass
        copy.stiffness = stiffness
        copy.damping = damping
        copy.velocity = velocity
        copy.fromValue = fromValue
        copy.toValue = toValue
        return copy
    }
    
    func interpolatedValues() -> [CGFloat] {
        var values: [CGFloat] = []
        var value: CGFloat = 0
        let valuesCount: Int = Int(duration * 60)
        let ω0: CGFloat = sqrt(stiffness / mass)  // angular frequency
        let β: CGFloat = damping / (2 * mass)     // amount of damping
        let v0: CGFloat = velocity
        let x0: CGFloat = 1 // substituted initial value
        
        for index in 0 ..< valuesCount {
            
            let t: CGFloat = CGFloat(index)/60.0
            
            if β < ω0 {
                // underdamped
                let ω1: CGFloat = sqrt(ω0 * ω0 - β * β)
                value = exp(-β * t) * (x0 * cos(ω1 * t) + CGFloat((β * x0 + v0) / ω1) * sin(ω1 * t))
            } else if β == ω0  {
                // critically damped
                value = exp(-β * t) * (x0 + (β * x0 + v0) * t)
            }
            else {
                // overdamped
                let ω2: CGFloat = sqrt(β * β - ω0 * ω0)
                let a = exp(-β * t)
                let b = x0 * cosh(CGFloat(ω2 * t))
                let c = ((β * x0 + v0) /  ω2)
                let d = sinh( ω2 * t)
                value = a * (b + c * d)
            }
            values.append(toValue - value * (toValue - fromValue))
        }
        
        return values
    }
    
    func durationForEpsilon(epsilon: CGFloat) -> CFTimeInterval {
        let beta: CGFloat = damping / (2 * mass)
        var duration: CGFloat = 0
        while exp(-beta * duration) >= epsilon {
            duration += 0.1
        }
        return CFTimeInterval(duration)
    }
    
}
