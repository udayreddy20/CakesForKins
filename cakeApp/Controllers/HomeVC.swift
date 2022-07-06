//
//  HomeVC.swift


import UIKit

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.cakeListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CakeViewCell", for: indexPath) as! CakeViewCell
        cell.configCell(data: self.cakeListData[indexPath.row])
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: CakeDetailsVC.self){
                vc.data = self.cakeListData[indexPath.row]
                self.present(vc, animated: true, completion: nil)
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
//        self.setUpData()
        self.cakeList.delegate = self
        self.cakeList.dataSource = self
        self.cakeListView.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getData()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func setUpData() {
        self.cakeListData.append(CakeModel(docID: "", name: "Pineapple Cake with Cherry Toppings", price: "$495", description: "The ideal way to make any celebration memorable is to add this exotic pineapple flavored cake. Decorated with lots of creamy frosting, pineapple slices and cherry topping, this cake is absolutely delectable.", image: "https://firebasestorage.googleapis.com/v0/b/cakeapp-9efb9.appspot.com/o/cakes%2Fp-pineapple-cake-with-cherry-toppings-half-kg--16988-m.webp?alt=media&token=ec8bbd33-9d5c-4aa5-a2f3-f2cef959c519"))
        
        self.cakeListData.append(CakeModel(docID: "", name: "Classic Red Velvet Cake", price: "$645", description: "Layered with blushed cherry color and white cream cheese, this Red Velvet delicacy is undeniably irresistible. Garnished with little heart shaped crimson colored frosting - a sinful surprise, melt hearts with this baker's perfection.", image: "https://firebasestorage.googleapis.com/v0/b/cakeapp-9efb9.appspot.com/o/cakes%2Fp-classic-red-velvet-cake-half-kg--109230-m.jpg?alt=media&token=31d99642-5179-4e3d-a10f-1119e7dd6f5b"))
        
        self.cakeListData.append(CakeModel(docID: "", name: "Finest Vanilla Cake", price: "$1095", description: "Here is a treat that nobody can say 'no' to; this Finest Vanilla Cake (1 Kg) can turn any regular day into a feast or any celebration into a tastier and better one. Surprise a dear one or treat yourself with this incredible dessert", image: "https://firebasestorage.googleapis.com/v0/b/cakeapp-9efb9.appspot.com/o/cakes%2Fp-finest-vanilla-cake-half-kg--135611-m.jpg?alt=media&token=be3d34fe-22af-4f97-b949-2efc7735b0d6"))
        
        self.cakeListData.append(CakeModel(docID: "", name: "Chocolate Fudge Brownie Cake", price: "$1495", description: "Everyone loves a good Chocolate Fudge Brownie Cake in 1 Kg - it's comforting, delicious & well Chocolatey! What make this Moreish Chocolate Fudge Brownie Cake special than any other cake is the layering of milk chocolate and dark chocolate on a warm brownie baked to perfection.", image: "https://firebasestorage.googleapis.com/v0/b/cakeapp-9efb9.appspot.com/o/cakes%2Fp-chocolate-fudge-brownie-cake-half-kg--109548-m.webp?alt=media&token=4ce36686-24c9-4821-a69e-2860ecff75a2"))
        
        self.cakeListData.append(CakeModel(docID: "", name: "Special Butterscotch Cake", price: "$1795", description: "Lip-smacking, scrumptious, undeniably leaving you craving for more, this Cake spells 'desire'. Garnished with vivid Chocolate thins, every bite of this will be an explosion of flavors.", image: "https://firebasestorage.googleapis.com/v0/b/cakeapp-9efb9.appspot.com/o/cakes%2Fp-special-butterscotch-cake-half-kg--109218-m.webp?alt=media&token=6950f799-5fad-4985-94a7-bc7e76a2025d"))
        
        self.cakeListData.append(CakeModel(docID: "", name: "Truffle Delight Cake", price: "$2045", description: "When in doubt, choose truffle! This yummylicious chocolate cake is covered in gooey, rich and creamy truffle flavoured ganache and loads of choco chips. Let this heavenly half kg cake add more fun to your celebration.", image: "https://firebasestorage.googleapis.com/v0/b/cakeapp-9efb9.appspot.com/o/cakes%2Fp-truffle-delight-cake-half-kg--145988-m.webp?alt=media&token=8a36a74f-6e7f-4994-b221-40113e07ce36"))
        
        for data in self.cakeListData {
            self.addData(data: data)
        }
    }
    
    
    func addData(data: CakeModel) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(cCakes).addDocument(data:
            [
                cName: data.name.description,
                cDescription : data.description.description,
                cPrice: data.price.description,
                cImagePath : data.image.description
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(cCakes).addSnapshotListener{ querySnapshot, error in
            
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
}
