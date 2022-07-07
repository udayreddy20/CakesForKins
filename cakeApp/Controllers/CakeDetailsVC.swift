//
//  CakeDetailsVC.swift

import UIKit
import SendGrid

class CakeDetailsVC: UIViewController {
    @IBOutlet weak var imgCake: UIImageView!
    @IBOutlet weak var btnCart: BlueThemeButton!
    @IBOutlet weak var btnFav: BlueThemeButton!
    @IBOutlet weak var lblCakeTitle: UILabel!
    @IBOutlet weak var lblCakeDescription: UILabel!
    
    
    var data: CakeModel!
    var isFav : Bool = true
    
    
    @IBAction func btnAddFavClick(_ sender: Any) {
        self.checkAddToFav(data: data, email: GFunction.user.email)
    }
    
    @IBAction func btnAddCartClick(_ sender: Any) {
        self.createOrder(data: data, user: GFunction.user, date: self.UTCToDate(date: Date()))
    }
    
    func UTCToDate(date:Date) -> String {
        let formatter = DateFormatter()
       
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)  // convert your string to date
        formatter.dateFormat = "dd, MMM, yyyy"  //then again set the date format whhich type of output you need
        return formatter.string(from: yourDate!) // again convert your date to string
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.btnFav.layer.cornerRadius = self.btnFav.layer.frame.height / 2
            self.btnCart.layer.cornerRadius = self.btnCart.layer.frame.height / 2
        }
        
        if data != nil {
            self.lblCakeTitle.text = data.name.description
            self.lblCakeDescription.text = data.description.description
            self.imgCake.setImgWebUrl(url: data.image, isIndicator: true)
        }
    }
    
    func addToFav(data: CakeModel,email:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(cFavourite).addDocument(data:
            [
                cName: data.name,
                cDescription : data.description,
                cPrice: data.price,
                cEmail: email,
                docID: data.docID,
                cImagePath: data.image
                
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Cake has been added into Favourite!!!") { (true) in
                    UIApplication.shared.setTab()
                }
            }
        }
    }
    
    func checkAddToFav(data: CakeModel, email:String) {
        _ = AppDelegate.shared.db.collection(cFavourite).whereField(cEmail, isEqualTo: email).whereField(docID, isEqualTo: data.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count == 0 {
                self.isFav = true
                self.addToFav(data: data, email: email)
            }else{
                if !self.isFav {
                    Alert.shared.showAlert(message: "Cake has been already existing into Favourite!!!", completion: nil)
                }
                
            }
        }
    }
    
    
    func createOrder(data: CakeModel, user:UserModel,date:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(cOrder).addDocument(data:
            [
                cName: data.name.description,
                cEmail : user.email.description,
                cOrderDate: date,
                cPrice: data.price.description,
                cDescription: data.description.description,
                cImagePath: data.image.description,
                cStatus: "PreMade",
                cQuantity: "1"
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                let fullname = "\(user.name)"
                self.emailSend(fullName: fullname, email: user.email)
            }
        }
    }
    
    func emailSend(fullName:String, email:String){
        self.sendEmail(fullName: fullName, email: email){ [unowned self] (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                                    Alert.shared.showAlert(message: "Your Order has been placed successfully !!!") { (true) in
                                        UIApplication.shared.setSuccess()
                                    }
                case .failure(_):
                    Alert.shared.showAlert(message: "Error", completion: nil)
                }
            }
            
        }
    }
    
    func sendEmail(fullName:String, email:String, completion: @escaping (Result<Void,Error>) -> Void) {
        let apikey = "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"
        let name = fullName
        let email = email
        
        let devemail = "2095405@cegepgim.ca"
        
        let data : [String:String] = [
            "name" : name,
            "user" : email
        ]
        
        
        let personalization = TemplatedPersonalization(dynamicTemplateData: data, recipients: email)
        let session = Session()
        session.authentication = Authentication.apiKey(apikey)
        
        let from = Address(email: devemail, name: name)
         let template = Email(personalizations: [personalization], from: from, templateID: "d-6b7fd08ad23d4a2cb854e48e8023d0e2", subject: "Your Order has been placed!!!")
        
        do {
            try session.send(request: template, completionHandler: { (result) in
                switch result {
                case .success(let response):
                    print("Response : \(response)")
                    completion(.success(()))
                    
                case .failure(let error):
                    print("Error : \(error)")
                    completion(.failure(error))
                }
            })
        }catch(let error){
            print("ERROR: ")
            completion(.failure(error))
        }
    }
}
