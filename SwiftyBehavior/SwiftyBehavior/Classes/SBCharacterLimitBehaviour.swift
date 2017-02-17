//
//  SBCharacterLimitBehaviour.swift
//  Pods
//
//  Created by Arkadi Yoskovitz on 13/02/2017.
//
//

import UIKit

//! Generates UIControlEventValueChanged when character limit is updated
class SBCharacterLimitBehaviour : SBRootBehavior
{
    
    //! used text view
    @IBOutlet weak var textView : UITextView! {
        didSet { updateCharacterLimit(for: textView.text) }
    }
    
    //! label used to display number of remaining characters
    @IBOutlet weak var counterLabel : UILabel! {
        didSet { updateCharacterLimit(for: textView.text) }
    }
    
    //! max count of characters allowed
    @IBInspectable var maxCount : Int = 0
    @IBInspectable var hideKeyboardOnReturn : Bool = true
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //AssertTrueOrReturn(self.maxCount != 0);
    }
    
    func updateCharacterLimit(for text: String!)
    {
        guard let text = text else { return }
        counterLabel.text = "\(maxCount - text.characters.count)"
        sendActionsForControlEvents(.ValueChanged)
    }
}
extension SBCharacterLimitBehaviour : UITextViewDelegate
{
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if let newlineRange = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet()) where hideKeyboardOnReturn {
            textView.resignFirstResponder()
            return false
        }
        
        let modifiedText = textView.text.stringByReplacingCharactersInRange(range.toRange(textView.text), withString: text)
        
        let willModifyText = modifiedText.characters.count <= maxCount
        if willModifyText {
            updateCharacterLimit(for: modifiedText)
        }
        return willModifyText;
    }
    public func textViewDidChange(textView: UITextView)
    {
        updateCharacterLimit(for: textView.text)
    }
}
private extension NSRange
{
    func toRange(string: String) -> Range<String.Index>
    {
        let startIndex = string.startIndex.advancedBy(location)
        let endIndex = startIndex.advancedBy(length)
        return startIndex..<endIndex
    }
}
