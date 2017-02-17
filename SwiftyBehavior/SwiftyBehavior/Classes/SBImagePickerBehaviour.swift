//
//  SBImagePickerBehaviour.swift
//  Pods
//
//  Created by Arkadi Yoskovitz on 11/02/2017.
//
//

import UIKit

/// Generates UIControlEventValueChanged when image is selected
public class SBImagePickerBehaviour : SBRootBehavior
{
    /// image view to assign selected image to
    @IBOutlet weak var targetImageView : UIImageView!
    
    //! obviously NS_OPTIONS would be better, but it's harder to expose that in XIB
    enum ImagePickerBehaviourSource : Int
    {
        case Both
        case Camera
        case Library
    }
    
    //! source type to use
    @IBInspectable var behaviourSource : ImagePickerBehaviourSource
    
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
        
        if let imageView = aDecoder.decodeObjectForKey(CodingKeys.targetImageView.description) as? UIImageView {
            targetImageView = imageView
        }
        let rawBehaviourSource = Int(aDecoder.decodeIntForKey(CodingKeys.behaviourSource.description))
        if let behaviour = ImagePickerBehaviourSource(rawValue: rawBehaviourSource) {
            behaviourSource = behaviour
        }
    }
    private init(_ initMethod: InitMethod)
    {
        behaviourSource = .Both
        
        switch initMethod
        {
        case .coder(let aDecoder): super.init(coder: aDecoder)!
        case .frame(let aFrame): super.init(frame: aFrame)
        }
    }
    // MARK: - NSCoding support
    private enum CodingKeys : String , CustomStringConvertible
    {
        case targetImageView
        case behaviourSource
        
        private var description: String { return rawValue }
    }
    public override func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(targetImageView, forKey: CodingKeys.targetImageView.description)
        aCoder.encodeInt(Int32(behaviourSource.rawValue), forKey: CodingKeys.behaviourSource.description)
        super.encodeWithCoder(aCoder)
    }
    
    @IBAction func pickImage(from sender: AnyObject, forEvent event: UIEvent)
    {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Phone else { return }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        if let image = targetImageView.image
        {
            let actionTitle  = NSLocalizedString("Delete photo", comment: "")
            let actionDelete = UIAlertAction(title: actionTitle, style: .Destructive, handler: { [weak self] _ in
                self?.targetImageView.image = nil;
                })
            actionSheet.addAction(actionDelete)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) && (behaviourSource == .Both || behaviourSource == .Camera)
        {
            let actionTitle  = NSLocalizedString("Take Photo", comment: "")
            let actionCamera = UIAlertAction(title: actionTitle, style: .Default, handler: { [weak self] _ in
                self?.showPicker(with: .Camera)
                })
            actionSheet.addAction(actionCamera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) && (behaviourSource == .Both || behaviourSource == .Library)
        {
            let actionTitle  = NSLocalizedString("Choose Existing", comment: "")
            let actionLibrary = UIAlertAction(title: actionTitle, style: .Default, handler: { [weak self] _ in
                self?.showPicker(with: .PhotoLibrary)
                })
            actionSheet.addAction(actionLibrary)
        }
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        
        if let presentationPopover = actionSheet.popoverPresentationController , let sourceView = sender as? UIView {
            
            presentationPopover.sourceView = sourceView
            presentationPopover.sourceRect = sourceView.frame
        }
        
        guard let ownerController = owner as? UIViewController else { return }
        ownerController.presentViewController(actionSheet, animated: true, completion: nil)
    }
    private func showPicker(with sourceType: UIImagePickerControllerSourceType) -> Void
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .CurrentContext
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        guard let ownerController = owner as? UIViewController else { return }
        ownerController.presentViewController(imagePickerController, animated: true, completion: nil)
    }
}
extension SBImagePickerBehaviour : UINavigationControllerDelegate , UIImagePickerControllerDelegate
{
    @available(iOS 2.0, *)
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        targetImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    @available(iOS 2.0, *)
    public func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
