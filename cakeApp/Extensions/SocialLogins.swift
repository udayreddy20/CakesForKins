////
////  SocialLogins.swift

//
//import Foundation
////import FBSDKCoreKit
////import FBSDKLoginKit
//import AuthenticationServices
import GoogleSignIn

struct SocialLoginDataModel {

    init() {

    }

    var socialId: String!
    var loginType: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var profileImage: String?
}

protocol SocialLoginDelegate: AnyObject {
    func socialLoginData(data: SocialLoginDataModel)
}

class SocialLoginManager: NSObject, GIDSignInDelegate {

    //MARK: Class Variable
//    static let shaared: SocialLoginManager = SocialLoginManager()
    weak var delegate: SocialLoginDelegate? = nil

    //init
    override init() {

    }
}

//MARK: Google Login
extension SocialLoginManager {
    //MARK: Google login methods
    /// Open google login view
    func performGoogleLogin(vc: UIViewController) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = vc
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
}

//MARK: Google login delegate
extension SocialLoginManager {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)

        } else {
            //Call delegate
            if let delegate = self.delegate {

                var dataObj: SocialLoginDataModel = SocialLoginDataModel()
                dataObj.socialId = user.userID
                dataObj.loginType = "G"
                dataObj.firstName = user.profile?.givenName
                dataObj.lastName = user.profile?.familyName
                dataObj.email = user.profile?.email
                //GFunction.shared.firebaseRegister(data: dataObj.email)
                if user.profile!.hasImage {
                    dataObj.profileImage = user.profile?.imageURL(withDimension: 100)?.description
                }
                delegate.socialLoginData(data: dataObj)
            }
        }
    }
}

//MARK: Facebook Login
extension SocialLoginManager {
    //MARK: Facebook login methods
    /// Open facebook login view
    func performFacebookLogin() {
        let loginManager = LoginManager()
        loginManager.logOut()
//        loginManager.authType = .rerequest
//        AccessToken.current = nil
//        Profile.current = nil
        let cookies = HTTPCookieStorage.shared
        let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }

        loginManager.logIn(permissions: ["public_profile","email"], from: UIApplication.topViewController()){ (loginResult, error) in
            if loginResult?.isCancelled ?? false {
                return
            }

            if error == nil {
                let req = GraphRequest(graphPath: "me", parameters: ["fields":  "id, name, first_name, last_name, gender, email, birthday, picture.type(large)"])
                
                req.start(completion: {(connection, response, error) in

                    let resData = JSON(response as Any)

                    //Call delegate
                    if let delegate = self.delegate {
                        var dataObj: SocialLoginDataModel = SocialLoginDataModel()
                        dataObj.socialId = resData["id"].stringValue
                        dataObj.loginType = "F"
                        dataObj.firstName = resData["first_name"].stringValue
                        dataObj.lastName = resData["last_name"].stringValue
                        dataObj.email = resData["email"].stringValue
                        GFunction.shared.firebaseRegister(data: dataObj.email)
                        delegate.socialLoginData(data: dataObj)
                    }

                })
            } else if error != nil {
                Alert.shared.showAlert(message: error?.localizedDescription ?? "", completion: nil)
            }
        }
    }
}
