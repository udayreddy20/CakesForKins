//
//  CakeDetailsVC.swift

import UIKit

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
    }

}
