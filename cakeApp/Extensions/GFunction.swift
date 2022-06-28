//
//  GFunction.swift

import Foundation
import UIKit
import AVFoundation

class GFunction {
    static let shared: GFunction = GFunction()

//    //Permissison for camera check is its not given
    func isGiveCameraPermissionAlert(_ viewController: UIViewController, completion: @escaping ((Bool) -> Void)) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                // Already Authorized
                completion(true)
                
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        completion(true)
                        
                    } else {
                        completion(false)
                        print("Disable")
                        
                        var errorMessage : String = ""
                        errorMessage = "Enable to access your camera roll to upload your photos with the app."
                        
                        let permissionAlert = UIAlertController(title: "SliceOfSpice Would like to access your photos?" , message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                        
                        permissionAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            AppDelegate.shared.openLink()
                        }))
                        
                        permissionAlert.addAction(UIAlertAction(title: "Dont Allow", style: .cancel, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        DispatchQueue.main.async { [weak self] in
                            guard self != nil else { return }
                            viewController.present(permissionAlert, animated: true, completion: nil)
                        }
                    }
                })
            }
        }
}
