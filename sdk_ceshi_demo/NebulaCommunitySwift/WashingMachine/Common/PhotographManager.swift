//
//  PhotographManager.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class PhotographManager: NSObject {
    
    static let manager = PhotographManager()
    var completedClourse: ((Any?)->())?
    var imagePackerController: UIImagePickerController?
    
    func photograph(_ controller: UIViewController?, _ completed:((Any?)->())?) {
        completedClourse = completed
        windowUserEnabled(false)
        controller?.present(imagePackerController ?? configImagePicker(), animated: true, completion: { 
            windowUserEnabled(true)
        })
    }
    
    fileprivate func configImagePicker() -> UIImagePickerController {
        imagePackerController = UIImagePickerController()
        imagePackerController?.sourceType = UIImagePickerController.SourceType.camera
        imagePackerController?.delegate = self
        imagePackerController?.allowsEditing = true
        return imagePackerController!
    }
}

extension PhotographManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if completedClourse != nil {
//            completedClourse!(info[UIImagePickerController.InfoKey.editedImage])
//        }
//        windowUserEnabled(false)
//        imagePackerController?.dismiss(animated: true, completion: { 
//            windowUserEnabled(true)
//        })
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if completedClourse != nil {
            completedClourse!(info[UIImagePickerController.InfoKey.editedImage])
        }
        windowUserEnabled(false)
        imagePackerController?.dismiss(animated: true, completion: {
            windowUserEnabled(true)
        })
    }

}

