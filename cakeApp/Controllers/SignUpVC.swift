//
//  SignUpVC.swift


import UIKit

class SignUpVC: UIViewController {

    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUp: BlueThemeButton!
    @IBOutlet weak var lblSignIn: UILabel!
    
    
    var flag: Bool = true
    var socialData : SocialLoginDataModel!
    
    
    func validation() -> String {
        if self.txtName.text?.trim() == "" {
            return "Please enter name"
        }else if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPhone.text?.trim() == "" {
            return "Please enter phone number"
        }else if (self.txtEmail.text?.trim().count)! < 10 {
            return "Please enter 10 digit number"
        }else if self.txtAddress.text?.trim() == "" {
            return "Please enter address"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if (self.txtPassword.text?.trim().count)! < 8 {
            return "Please enter 8 character for password"
        }else if self.txtConfirmPassword.text?.trim() == "" {
            return "Please enter confirm password"
        }else if self.txtPassword.text?.trim() != self.txtConfirmPassword.text?.trim() {
            return "Password mismatched"
        }
        return ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblWelcome.font = UIFont(name: "bold", size: 22.0)
        self.lblWelcome.textColor = UIColor.hexStringToUIColor(hex: "#EC2956")
        
        if socialData != nil {
            self.txtName.text = "\(socialData.firstName ?? "") \(socialData.lastName ?? "")"
            self.txtEmail.text = socialData.email
            self.txtEmail.isUserInteractionEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation()
        if error == "" {
            self.getExistingUser(name: self.txtName.text ?? "" , email: self.txtEmail.text ?? "", mobile: self.txtPhone.text ?? "", address: self.txtAddress.text ?? "", password: self.txtPassword.text ?? "")
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }

}




//MARK:- Extension for Login Function
extension SignUpVC {

    func createAccount(name: String, email: String, mobile: String, address: String, password: String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(cUser).addDocument(data:
            [
              cPhone: mobile,
              cEmail: email,
              cName: name,
              cPassword : password,
              cAddress: address
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                GFunction.shared.firebaseRegister(data: email)
                GFunction.user = UserModel(docID: "", name: name, mobile: mobile, email: email, password: password, address: address)
                UIApplication.shared.setTab()
                self.flag = true
            }
        }
    }

    func getExistingUser(name: String, email: String, mobile: String, address: String, password: String) {

        _ = AppDelegate.shared.db.collection(cUser).whereField(cEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            if snapshot.documents.count == 0 {
                self.createAccount(name: name, email: email, mobile: mobile, address: address, password: password)
                self.flag = true
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Email is already exist !!!", completion: nil)
                    self.flag = true
                }
            }
        }
    }
}
