//
//  OrderVC.swift
//  cakeApp


import UIKit

class OrderVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cakeOrderListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderViewCell", for: indexPath) as! orderViewCell
        cell.configCell(data: self.cakeOrderListData[indexPath.row])
        return cell
    }
   
    @IBOutlet weak var vwOrder: UIView!
    @IBOutlet weak var orderList: UITableView!
    
    
    var cakeOrderListData = [OrderModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !GFunction.user.email.isEmpty{
            self.getData(email: GFunction.user.email)
        }

        self.orderList.delegate = self
        self.orderList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }


    func getData(email:String) {
        _ = AppDelegate.shared.db.collection(cOrder).whereField(cEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.cakeOrderListData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[cName] as? String, let description: String = data1[cDescription] as? String,let imagePath: String = data1[cImagePath] as? String, let price: String = data1[cPrice] as? String, let email: String = data1[cEmail] as? String, let orderDate: String = data1[cOrderDate] as? String,let quantity: String = data1[cQuantity] as? String,let status: String = data1[cStatus] as? String {
                        print("Data Count : \(self.cakeOrderListData.count)")
                        self.cakeOrderListData.append(OrderModel(docID: data.documentID, name: name, description: description, email: email, orderDate: orderDate, imagePath: imagePath, price: price,status: status,qty: quantity))
                    }
                }
                self.orderList.delegate = self
                self.orderList.dataSource = self
                self.orderList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}

class orderViewCell: UITableViewCell {
    
    @IBOutlet weak var vwCake: UIView!
    @IBOutlet weak var cakePrice: UILabel!
    @IBOutlet weak var CakeName: UILabel!
    @IBOutlet weak var CakeQuantity: UILabel!
    @IBOutlet weak var CakeStatus: UILabel!
    @IBOutlet weak var imgCake: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgCake.layer.cornerRadius = 5.0
        self.vwCake.layer.cornerRadius = 15.0
    }
    
    func configCell(data: OrderModel){
        self.imgCake.setImgWebUrl(url: data.imagePath.description, isIndicator: true)
        self.CakeName.text = data.name.description
        self.cakePrice.text = data.price.description
        self.CakeStatus.text = data.status.description
        self.CakeQuantity.text = "\(data.qty) item"
    }
}
