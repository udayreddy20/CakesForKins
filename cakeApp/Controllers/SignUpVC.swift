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
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation()
        if error == "" {
            UIApplication.shared.setTab()
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }

}
