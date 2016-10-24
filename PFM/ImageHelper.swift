//
//  ImageHelper.swift
//  hero2
//
//  Created by Bence Pattogató on 2016. 09. 23..
//  Copyright © 2016. Inceptech. All rights reserved.
//

import UIKit

enum ImagePickerActions: String {
    case Camera
    case Gallery
    case Delete
}

final class ImageHelper: NSObject {
    
    struct Constants {
        static let maxImageWidth: CGFloat = 1280
        static let compressionQuality: CGFloat = 0.9
        static let animationSpeed = 0.5
    }

    typealias PickerCancelled = (() -> Void)
    typealias PickerImageSelected = ((UIImage) -> Void)
    
    private lazy var imagePickerController: UIImagePickerController = self.initImagePicker()
    
    static var placeholderImage: UIImage = {
        return HeroImage.placeholder
    }()
    
    static var imageError404: UIImage = {
       return HeroImage.imageError404
    }()
    
    var pickerCancelledAction: PickerCancelled?
    var pickerImageSelectedAction: PickerImageSelected!
    
    private func initImagePicker() -> UIImagePickerController {
        imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        
        return imagePickerController
    }
    
    /**
     Shows an image picker with the given source
     - Parameters:
        - sourceType: The preferred sourcetype
        - inViewController: Shows the content in this controller
        - onPickerCancelled: Picker cancelled action
        - onPickerImageSelected: Picker selected image action
     */
    func showImagePicker(sourceType: UIImagePickerControllerSourceType,
                         inViewController viewController: UIViewController,
                         onPickerCancelled: PickerCancelled? = nil,
                         onPickerImageSelected: @escaping PickerImageSelected) {
        pickerCancelledAction = onPickerCancelled
        pickerImageSelectedAction = onPickerImageSelected
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        // If the source type is not available -> Do not enable
        if !isSourceTypeAvailable(type: sourceType) {
            onPickerCancelled?()
            return
        }
        
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    /**
     Shows an actionsheet with the default photo type options
     - Parameters:
        - viewController: Shows the content in this controller
        - onPhotoTypeSelected: Result block of the selected action
     */
    func showImageSourceSelector<T>(viewController: T,
                                 otherActions: [UIAlertAction]? = nil,
                                 cameraTitle: String = "general.camera".localized,
                                 galleryTitle: String = "general.library".localized,
                                 onPickerCancelled: PickerCancelled?,
                                 onPhotoTypeSelected: @escaping ((UIImagePickerControllerSourceType) -> Void)) where T:UIViewController, T:AlertProtocol {
        
        // Add possible actions
        var possibleActions = [UIAlertAction]()
        
        if isSourceTypeAvailable(type: .camera) {
            let action = viewController.createAction(title: cameraTitle, handler: { (alert) in
                onPhotoTypeSelected(.camera)
            })
            possibleActions.append(action)
        }
        
        if isSourceTypeAvailable(type: .photoLibrary) {
            let action = viewController.createAction(title: galleryTitle, handler: { (alert) in
                onPhotoTypeSelected(.photoLibrary)
            })
            
            possibleActions.append(action)
        }
        
        if let extraActions = otherActions {
            possibleActions.append(contentsOf: extraActions)
        }
        
        let cancelAction = viewController.createAction(title: "general.cancel".localized,
                                                       style: .cancel) { (_) in
                                                        onPickerCancelled?()
        }
        
        _ = viewController.showActionsheet(title: "photo.chooser.title".localized,
                                       message: nil,
                                       cancelAction: cancelAction,
                                       otherActions: possibleActions)
    }
    
    /**
     Shows an actionsheet with the default photo type options
     then starts the image picker with the selected type
     - Parameters:
        - viewController: Shows the content in this controller
        - onPickerCancelled: Picker cancelled action
        - onPickerImageSelected: Picker selected image action
     */
    func showImagePickerWithSourceSelector<T>(viewController: T,
                                           onPickerCancelled: PickerCancelled?,
                                           onPickerImageSelected: @escaping PickerImageSelected) where T:UIViewController, T:AlertProtocol {
        showImageSourceSelector(viewController: viewController,
                                onPickerCancelled: onPickerCancelled) { [weak self] (type) in
            self?.showImagePicker(sourceType: type,
                                  inViewController: viewController,
                                  onPickerCancelled: onPickerCancelled,
                                  onPickerImageSelected: onPickerImageSelected)
        }
    }
    
    /**
     Checks whether the given source type is available for the current hardware
      - Parameters:
        - type: The type of the source
    */
    func isSourceTypeAvailable(type: UIImagePickerControllerSourceType) -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(type)
    }
}

// MARK: - Imagepicker delegate
extension ImageHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        pickerCancelledAction?()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
        pickerImageSelectedAction(image)
    }
}

// MARK: - Compressing
extension ImageHelper {
    
    static public func compress(image: UIImage) -> Data? {
        
        // Originally save the image as the new one -> We will make operates on it
        var newImage: UIImage = image
        let originalImageSize = image.size
        
        // If all directions are over the maximum
        if ((originalImageSize.height > originalImageSize.width) && (originalImageSize.height > Constants.maxImageWidth)) {
            let originalImageRatio = Constants.maxImageWidth / originalImageSize.height
            let newSize = CGSize(width: round(originalImageSize.width * originalImageRatio),
                                 height: Constants.maxImageWidth)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            
            if let transformedImage = UIGraphicsGetImageFromCurrentImageContext() {
                newImage = transformedImage
            }
            UIGraphicsEndImageContext()
        } else if (originalImageSize.width > Constants.maxImageWidth) {
            // Otherwise if the image is widen than the max
            let originalImageRatio = Constants.maxImageWidth / originalImageSize.width
            let newSize = CGSize(width: Constants.maxImageWidth,
                                 height: round(originalImageSize.height * originalImageRatio))
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            
            if let transformedImage = UIGraphicsGetImageFromCurrentImageContext() {
                newImage = transformedImage
            }
            UIGraphicsEndImageContext()
        }
        
        // Finally convert he image as jpeg representation
        return UIImageJPEGRepresentation(newImage, Constants.compressionQuality)
    }
}
