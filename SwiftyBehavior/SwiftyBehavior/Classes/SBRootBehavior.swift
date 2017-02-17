//
//  SBRootBehavior.swift
//  Pods
//
//  Created by Arkadi Yoskovitz on 11/02/2017.
//
//

import UIKit

public class SBRootBehavior : UIControl
{
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private struct AssociatedKeys {
        static var OwnerKey = "SBRootBehavior.OwnerKey"
    }
    
    @IBOutlet public weak var owner: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.OwnerKey)
        }
        set (newOwner) {
            objc_setAssociatedObject(self, &AssociatedKeys.OwnerKey, newOwner, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
