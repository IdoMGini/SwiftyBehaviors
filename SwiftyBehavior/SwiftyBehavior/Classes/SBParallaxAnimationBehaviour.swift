//
//  SBParallaxAnimationBehaviour.swift
//  Pods
//
//  Created by Arkadi Yoskovitz on 13/02/2017.
//
//

import UIKit

class SBParallaxAnimationBehaviour : SBRootBehavior
{
    /// view position to adjust
    @IBOutlet weak var targetView : UIView!
    
    /// scroll view to follow
    @IBOutlet weak var leadingScrollView : UIScrollView!
    
    /// offset for parallax, if set to zero it will grab initial position from targetView
    @IBInspectable var parallaxOffset : CGPoint
    
    /// parallax speed multiplier in regards to leading scrollView contentOffset
    @IBInspectable var parallaxSpeed  : CGPoint

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
        
//        minimumRelative = CGFloat(aDecoder.decodeDoubleForKey(CodingKeys.minimumRelative.description))
//        maximumRelative = CGFloat(aDecoder.decodeDoubleForKey(CodingKeys.maximumRelative.description))
//        
//        applyHorizontal = aDecoder.decodeBoolForKey(CodingKeys.applyHorizontal.description)
//        applyVertical   = aDecoder.decodeBoolForKey(CodingKeys.applyVertical  .description)
//        
//        if let motionEffectGroup = aDecoder.decodeObjectForKey(CodingKeys.parallaxMotionEffect.description) as? UIMotionEffectGroup {
//            parallaxMotionEffect = motionEffectGroup
//        }
    }
    private init(_ initMethod: InitMethod)
    {
        parallaxOffset = CGPoint.zero
        parallaxSpeed  = CGPoint.zero
        
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
        case leadingScrollView
        case parallaxOffset
        case parallaxSpeed
        
        private var description: String { return rawValue }
    }
    public override func encodeWithCoder(aCoder: NSCoder)
    {
//        aCoder.encodeDouble(Double(minimumRelative), forKey: CodingKeys.minimumRelative.description)
//        aCoder.encodeDouble(Double(maximumRelative), forKey: CodingKeys.maximumRelative.description)
//        aCoder.encodeBool(applyHorizontal, forKey: CodingKeys.applyHorizontal.description)
//        aCoder.encodeBool(applyVertical  , forKey: CodingKeys.applyVertical  .description)
//        aCoder.encodeObject(parallaxMotionEffect, forKey: CodingKeys.parallaxMotionEffect.description)
        super.encodeWithCoder(aCoder)
    }
    
    
    private func adjustParallaxPosition()
    {
        //        BOOL initialized = NO;
        //        if(!initialized) {
        //            initialized = YES;
        //            if (CGPointEqualToPoint(self.parallaxOffset, CGPointZero)) {
        //                self.parallaxOffset = self.targetView.center;
        //            }
        //        }
        //
        //        var centerPoint = leadingScrollView.contentOffset;
        //        centerPoint.x = parallaxOffset.x + centerPoint.x * parallaxSpeed.x;
        //        centerPoint.y = parallaxOffset.y + centerPoint.y * parallaxSpeed.y;
        //        targetView.center = centerPoint;
    }
}
extension SBParallaxAnimationBehaviour : UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        adjustParallaxPosition()
    }
}

