//
//  HomeVC.swift


import UIKit

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
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
