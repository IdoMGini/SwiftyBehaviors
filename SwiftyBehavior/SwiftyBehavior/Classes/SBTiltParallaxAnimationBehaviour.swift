//
//  SBTiltParallaxAnimationBehaviour.swift
//  Pods
//
//  Created by Arkadi Yoskovitz on 14/02/2017.
//
//

import UIKit

public class SBTiltParallaxAnimationBehaviour : SBRootBehavior
{
    /// view position to adjust
    @IBOutlet public weak var targetView : UIView! {
        didSet { adjustMotionEffect() }
    }
    
    /// The parallax motion minimum relative value
    @IBInspectable public var minimumRelative : CGFloat
    
    /// The parallax motion maximum relative value
    @IBInspectable public var maximumRelative : CGFloat
    
    /// Indicate if the parallax motion effect should apply horizontally
    @IBInspectable public var applyHorizontal : Bool
    
    /// Indicate if the parallax motion effect should apply vertically
    @IBInspectable public var applyVertical   : Bool
    
    private var parallaxMotionEffect : UIMotionEffectGroup

    // MARK: - Initialization
    private enum InitMethod
    {
        case coder(NSCoder)
        case frame(CGRect)
    }
    public convenience override init(frame: CGRect)
    {
        self.init(.frame(frame))
    }
    public convenience required init(coder aDecoder: NSCoder)
    {
        self.init(.coder(aDecoder))
        
        if let view = aDecoder.decodeObjectForKey(CodingKeys.targetView.description) as? UIView {
            targetView = view
        }
        minimumRelative = CGFloat(aDecoder.decodeDoubleForKey(CodingKeys.minimumRelative.description))
        maximumRelative = CGFloat(aDecoder.decodeDoubleForKey(CodingKeys.maximumRelative.description))

        applyHorizontal = aDecoder.decodeBoolForKey(CodingKeys.applyHorizontal.description)
        applyVertical   = aDecoder.decodeBoolForKey(CodingKeys.applyVertical  .description)

        if let motionEffectGroup = aDecoder.decodeObjectForKey(CodingKeys.parallaxMotionEffect.description) as? UIMotionEffectGroup {
            parallaxMotionEffect = motionEffectGroup
        }
    }
    private init(_ initMethod: InitMethod)
    {
        minimumRelative = CGFloat(-30)
        maximumRelative = CGFloat( 30)
        applyHorizontal = true
        applyVertical   = true
        parallaxMotionEffect = UIMotionEffectGroup()
        
        switch initMethod
        {
        case .coder(let aDecoder): super.init(coder: aDecoder)!
        case .frame(let aFrame): super.init(frame: aFrame)
        }
    }
    // MARK: - NSCoding support
    private enum CodingKeys : String , CustomStringConvertible
    {
        case targetView
        case minimumRelative
        case maximumRelative
        case applyHorizontal
        case applyVertical
        case parallaxMotionEffect
        
        private var description: String { return rawValue }
    }
    public override func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(targetView, forKey: CodingKeys.targetView.description)
        aCoder.encodeDouble(Double(minimumRelative), forKey: CodingKeys.minimumRelative.description)
        aCoder.encodeDouble(Double(maximumRelative), forKey: CodingKeys.maximumRelative.description)
        aCoder.encodeBool(applyHorizontal, forKey: CodingKeys.applyHorizontal.description)
        aCoder.encodeBool(applyVertical  , forKey: CodingKeys.applyVertical  .description)
        aCoder.encodeObject(parallaxMotionEffect, forKey: CodingKeys.parallaxMotionEffect.description)
        super.encodeWithCoder(aCoder)
    }

    private func adjustMotionEffect()
    {
        guard let targetView = targetView else { return }
        removeMotionEffect()
        parallaxMotionEffect.motionEffects = setupMotionEffects()
        targetView.addMotionEffect(parallaxMotionEffect)
    }
    
    private func setupMotionEffects() -> [UIInterpolatingMotionEffect]
    {
        var effects = [UIInterpolatingMotionEffect]()
        
        if applyHorizontal {
            let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .TiltAlongHorizontalAxis)
            xMotion.minimumRelativeValue = minimumRelative
            xMotion.maximumRelativeValue = maximumRelative
            effects.append(xMotion)
        }
        if applyVertical   {
            let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .TiltAlongVerticalAxis)
            yMotion.minimumRelativeValue = minimumRelative
            yMotion.maximumRelativeValue = maximumRelative
            effects.append(yMotion)
        }
        return effects
    }
    
    private func removeMotionEffect()
    {
        targetView.removeMotionEffect(parallaxMotionEffect)
        parallaxMotionEffect.motionEffects?.removeAll()
    }
}
