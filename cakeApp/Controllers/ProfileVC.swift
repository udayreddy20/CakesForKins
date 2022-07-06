//
//  ProfileVC.swift

import UIKit
import OpalImagePicker
import Photos

class ProfileVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtNAme: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnSave: BlueThemeButton!
    @IBOutlet weak var btnLogout: BlueThemeButton!
    
    
    var imgPicker = UIImagePickerController()
    var imageData = UIImage()
    var imgPicker1 = OpalImagePickerController()
    var isImageSelected = false
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.openPicker()
        }

        if !GFunction.user.email.isEmpty{
            self.txtEmail.text = GFunction.user.email
            self.txtPhone.text = GFunction.user.mobile
            self.txtNAme.text = GFunction.user.name
            self.txtAddress.text = GFunction.user.address
            self.txtEmail.isUserInteractionEnabled = false
        }
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

    
    
    func validation() -> String {
        if self.txtNAme.text?.trim() == ""{
            return "Please enter name"
        }else if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPhone.text?.trim() == "" {
            return "Please enter phone number"
        }else if self.txtPhone.text?.trim().count != 10 {
            return "Please enter 10 digit phone number"
        }else if self.txtAddress.text?.trim() == "" {
            return "Please enter address"
        }
        return ""
    }
    
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        if sender == btnSave {
            let error = self.validation()
            if error == "" {
                self.updateProfile(docID: GFunction.user.docID, name: self.txtNAme.text ?? "", phoneNumber: self.txtPhone.text ?? "", address: self.txtAddress.text ?? "")
                Alert.shared.showAlert(message: "Your profile has been updated !!!", completion: nil)
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }else if sender == btnLogout {
            Alert.shared.showAlert("CakeApp", actionOkTitle: "Logout", actionCancelTitle: "Cancel", message: "Are you sure you want to logout?") { (true) in
                if true {
                    UIApplication.shared.setStart()
                }
            }
        }
        
    }
    
    func openPicker(){
        
        
        let actionSheet = UIAlertController(title: nil, message: "Select Image", preferredStyle: .actionSheet)
        
        let cameraPhoto = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return Alert.shared.showAlert(message: "Camera not Found", completion: nil)
            }
            GFunction.shared.isGiveCameraPermissionAlert(self) { (isGiven) in
                if isGiven {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.imgPicker.mediaTypes = ["public.image"]
                        self.imgPicker.sourceType = .camera
                        self.imgPicker.cameraDevice = .rear
                        self.imgPicker.allowsEditing = true
                        self.imgPicker.delegate = self
                        self.present(self.imgPicker, animated: true)
                    }
                }
            }
        })
        
        let PhotoLibrary = UIAlertAction(title: "Gallary", style: .default, handler:
                                            { [self]
            (alert: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos == .denied || photos == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized {
                            DispatchQueue.main.async {
                                self.imgPicker1 = OpalImagePickerController()
                                self.imgPicker1.imagePickerDelegate = self
                                self.imgPicker1.isEditing = true
                                present(self.imgPicker1, animated: true, completion: nil)
                            }
                        }
                    })
                }else if photos == .authorized {
                    DispatchQueue.main.async {
                        self.imgPicker1 = OpalImagePickerController()
                        self.imgPicker1.imagePickerDelegate = self
                        self.imgPicker1.isEditing = true
                        present(self.imgPicker1, animated: true, completion: nil)
                    }
                    
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            
        })
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        actionSheet.addAction(cameraPhoto)
        actionSheet.addAction(PhotoLibrary)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }

}


//MARK:- UIImagePickerController Delegate Methods
extension ProfileVC: UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        if let image = info[.editedImage] as? UIImage {
            self.imgProfile.image = image
            self.isImageSelected = true
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        do { picker.dismiss(animated: true) }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]){
        for image in assets {
            if let image = getAssetThumbnail(asset: image) as? UIImage {
                self.imgProfile.image = image
                self.isImageSelected = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: (asset.pixelWidth), height: ( asset.pixelHeight)), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC {
    func updateProfile(docID: String,name:String,phoneNumber:String, address:String) {
        let ref = AppDelegate.shared.db.collection(cUser).document(docID)
        ref.updateData([
            cName : name,
            cPhone : phoneNumber,
            cAddress : address,
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                GFunction.user.name = name
                GFunction.user.address = address
                GFunction.user.mobile = phoneNumber
                Alert.shared.showAlert(message: "Your Profile has been Updated !!!", completion: nil)
            }
        }
    }
}
