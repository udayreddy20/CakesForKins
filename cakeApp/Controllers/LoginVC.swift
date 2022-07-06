//
//  LoginVC.swift


import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: BlueThemeButton!
    @IBOutlet weak var lblSignUp: UILabel!
    
    var flag: Bool = true
    var socialData : SocialLoginDataModel!
    
    
    func validation() -> String {
        if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if (self.txtPassword.text?.trim().count)! < 8 {
            return "Please enter 8 character for password"
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.lblSignUp.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.lblSignUp.addGestureRecognizer(tap)
        
        
        self.lblWelcome.font = UIFont(name: "bold", size: 16.0)
        self.lblWelcome.textColor = UIColor.hexStringToUIColor(hex: "#EC2956")
        self.txtPassword.isSecureTextEntry = true
        
       // self.txtEmail.text = ""
       // self.txtPassword.text = ""
        if socialData != nil {
            self.txtEmail.text = socialData.email
            self.txtEmail.isUserInteractionEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation()
        if error == "" {
            self.loginUser(email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "")
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
}



//MARK:- Extension for Login Function
extension LoginVC {
    
    
    func loginUser(email:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(cUser).whereField(cEmail, isEqualTo: email).whereField(cPassword, isEqualTo: password).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let name : String = data1[cName] as? String, let address: String = data1[cAddress] as? String, let phone: String = data1[cPhone] as? String, let email: String = data1[cEmail] as? String, let password: String = data1[cPassword] as? String {
                    GFunction.user = UserModel(docID: docId, name: name, mobile: phone, email: email, password: password, address: address)
                }
                GFunction.shared.firebaseRegister(data: email)
                UIApplication.shared.setTab()
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}
