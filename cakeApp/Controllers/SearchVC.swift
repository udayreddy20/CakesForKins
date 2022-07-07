//
//  SearchVC.swift


import UIKit

class SearchVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.cakeListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CakeViewCell", for: indexPath) as! CakeViewCell
        cell.configFavCell(data: self.cakeListData[indexPath.row])
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: CakeDetailsVC.self){
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        cell.btnFav.addAction(for: .touchUpInside) {
            Alert.shared.showAlert("", actionOkTitle: "Delete", actionCancelTitle: "Cancel", message: "Are you sure you want to remove?") { (true) in
                self.removeFromFav(data: self.cakeListData[indexPath.row], email: GFunction.user.email)
            }
        }
        
        cell.vwCell.isUserInteractionEnabled = true
        cell.vwCell.addGestureRecognizer(tap)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((280/375) * UIScreen.main.bounds.width), height: ((200/375) * UIScreen.main.bounds.width))
    }

    @IBOutlet weak var cakeList: UICollectionView!
    @IBOutlet weak var cakeListView: UIView!
    
    var cakeListData = [CakeModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCakeList()
        self.cakeList.delegate = self
        self.cakeList.dataSource = self
        self.cakeListView.layer.cornerRadius = 15
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

}



class CakeViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    @IBOutlet weak var imgCake: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    override func awakeFromNib() {
        if UIScreen.main.bounds.width == 375 {
            self.widthConst.constant = 280
        }else{
            self.widthConst.constant = 320
        }
        self.imgCake.layer.cornerRadius = 10.0
    }
    
    func configCell(data: CakeModel) {
        self.lblName.text = data.name
        self.imgCake.setImgWebUrl(url: data.image, isIndicator: true)
        self.lblPrice.text = data.price.description
    }
    
    func configFavCell(data: CakeModel) {
        self.lblName.text = data.name
        self.imgCake.setImgWebUrl(url: data.image, isIndicator: true)
    }
}


extension SearchVC {
    func getCakeList() {
        _ = AppDelegate.shared.db.collection(cFavourite).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.cakeListData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[cName] as? String, let description: String = data1[cDescription] as? String,let imagePath: String = data1[cImagePath] as? String, let price: String = data1[cPrice] as? String {
                        print("Data Count : \(self.cakeListData.count)")
                        self.cakeListData.append(CakeModel(docID: data.documentID, name: name, price: price, description: description, image: imagePath))
                    }
                }
                self.cakeList.delegate = self
                self.cakeList.dataSource = self
                self.cakeList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    
    func removeFromFav(data: CakeModel,email:String){
        let ref = AppDelegate.shared.db.collection(cFavourite).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully deleted")
                //Alert.shared.showAlert(message: "Cake has been removed successfully !!!") { (true) in
                    UIApplication.shared.setTab()
                //}
            }
        }
    }
}

