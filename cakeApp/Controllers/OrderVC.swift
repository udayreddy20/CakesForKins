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
