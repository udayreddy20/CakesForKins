//
//  SearchVC.swift


import UIKit

class SearchVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CakeViewCell", for: indexPath) as! CakeViewCell
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: CakeDetailsVC.self){
                self.present(vc, animated: true) {
                    let vc  = SuccessVC.instantiate(fromAppStoryboard: .main)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
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
    
//    var cakeListData = [ProductModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getCakeList()
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
    
    
    override func awakeFromNib() {
        if UIScreen.main.bounds.width == 375 {
            self.widthConst.constant = 280
        }else{
            self.widthConst.constant = 320
        }
        self.imgCake.layer.cornerRadius = 10.0
    }
    
    func configCell(data: ProductModel) {
        self.lblName.text = data.name
        self.imgCake.setImgWebUrl(url: data.image, isIndicator: true)
    }

    func configCellFav(data: FavouriteModel) {
        self.lblName.text = data.name
        self.imgCake.setImgWebUrl(url: data.image, isIndicator: true)
    }
}


extension SearchVC {
    func getCakeList() {
        _ = AppDelegate.shared.db.collection(cProduct).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.cakeListData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents{
                    let data = data.data()
                    print(data)
                    self.cakeListData.append(ProductModel(id: data["id"] as! String, image: (data["image"] as! String), name: (data["name"] as! String), description: (data["description"] as! String), price: (data["price"] as! String)))
                }
                self.cakeList.delegate = self
                self.cakeList.dataSource = self
                self.cakeList.reloadData()

            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }

    }
}

