//
//  StartVC.swift


import UIKit

class StartVC: UIViewController {

    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFaceBook: UIButton!
    @IBOutlet weak var lblLogin: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnEmail.layer.cornerRadius = 12.0
        self.btnGoogle.layer.cornerRadius = 12.0
        self.btnFaceBook.layer.cornerRadius = 12.0
        
        self.lblLogin.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.lblLogin.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnSignUpWithEmailTapped(_ sender: UIButton) {
        if sender == btnEmail {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnGoogle {
            //self.socialLoginManager.performGoogleLogin(vc: self)
        }else if sender == btnFaceBook {
            //self.socialLoginManager.performAppleLogin()
        }
    }

}
