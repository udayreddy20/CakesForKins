//
//  CakeDetailsVC.swift


import UIKit

class CakeDetailsVC: UIViewController {
    @IBOutlet weak var imgCake: UIImageView!
    @IBOutlet weak var btnCart: BlueThemeButton!
    @IBOutlet weak var btnFav: BlueThemeButton!
    @IBOutlet weak var lblCakeTitle: UILabel!
    @IBOutlet weak var lblCakeDescription: UILabel!
    
    
    @IBAction func btnAddFavClick(_ sender: Any) {
        Alert.shared.showAlert(message: "Your cake has been added into favourite list"){ _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnAddCartClick(_ sender: Any) {
        Alert.shared.showAlert(message: "Your cake has been placed") { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.btnFav.layer.cornerRadius = self.btnFav.layer.frame.height / 2
            self.btnCart.layer.cornerRadius = self.btnCart.layer.frame.height / 2

        }
    }

}
