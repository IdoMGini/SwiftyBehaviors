//
//  SBBecomeFirstResponderBehaviour.swift
//  Pods
//
//  Created by Arkadi Yoskovitz on 13/02/2017.
//
//

import UIKit

class SBBecomeFirstResponderBehaviour : SBRootBehavior
{
    //! object which should become first responder
    @IBOutlet weak var firstResponderTarget : UIResponder!
    {
        didSet
        {
            firstResponderTarget.becomeFirstResponder()
        }
    }
}
