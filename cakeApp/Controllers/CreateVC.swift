//
//  CreateVC.swift
//  cakeApp



import UIKit
import DTPagerController
import HMSegmentedControl


enum TypeCake {
    case type
    case shape
    case size
    case flavour
    case filling
    case info
}

class model {
    var imageString: String!
    var title: String!
    var typeCake: TypeCake
    
    init(imageString:String,title:String,typeCake:TypeCake){
        self.imageString = imageString
        self.title = title
        self.typeCake = typeCake
    }
}

class CustomCakeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = data.count
        self.vwNotes.isHidden = true
        self.typeTbl.isHidden = false
        if data == 0 {
            self.vwNotes.isHidden = false
            self.typeTbl.isHidden = true
        }
        return data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as! TypeCell
        cell.configCell(data: data[indexPath.row])
        return cell
    }
    

    @IBOutlet weak var vwControl: UIView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var vwNotes: UIView!
    
    let typeData: [model] = [
        model(imageString: "regular", title: "Regular", typeCake: .type),
        model(imageString: "gluten free", title: "Gluten Free", typeCake: .type),
        model(imageString: "vegan", title: "Vegan", typeCake: .type),
        model(imageString: "eggless", title: "Eggless", typeCake: .type),
        model(imageString: "sugar free", title: "Sugar Free", typeCake: .type),
        model(imageString: "fondant", title: "Fodant", typeCake: .type),
        model(imageString: "hexagon", title: "Hexagon", typeCake: .shape),
        model(imageString: "heart", title: "Heart", typeCake: .shape),
        model(imageString: "round", title: "Round", typeCake: .shape),
        model(imageString: "numeric", title: "Numeric", typeCake: .shape),
        model(imageString: "square", title: "Square", typeCake: .shape),
        model(imageString: "alphabet", title: "Alphabet", typeCake: .shape),
        model(imageString: "0.5 lbs", title: "Serves 2-3", typeCake: .size),
        model(imageString: "1.0 lbs", title: "Serves 4-6", typeCake: .size),
        model(imageString: "1.5 lbs", title: "Serves 6-8", typeCake: .size),
        model(imageString: "2.0 lbs", title: "Serves 9-11", typeCake: .size),
        model(imageString: "2.5 lbs", title: "Serves 12-15", typeCake: .size),
        model(imageString: "3.0 lbs", title: "Serves 15-17", typeCake: .size),
        model(imageString: "A", title: "Almond", typeCake: .flavour),
        model(imageString: "B", title: "Black Current", typeCake: .flavour),
        model(imageString: "B", title: "Butterscotch", typeCake: .flavour),
        model(imageString: "C", title: "Chocolate", typeCake: .flavour),
        model(imageString: "D", title: "Dark Chocolate", typeCake: .flavour),
        model(imageString: "K", title: "Kit Kat", typeCake: .flavour),
        model(imageString: "S", title: "Strawberry", typeCake: .filling),
        model(imageString: "O", title: "Oreo Cookie", typeCake: .filling),
        model(imageString: "M", title: "Mango", typeCake: .filling),
        model(imageString: "C", title: "Chocolate Rum", typeCake: .filling),
        model(imageString: "B", title: "Blackberry", typeCake: .filling),
        model(imageString: "A", title: "Almonds", typeCake: .filling)
    ]
    
    var data = [model]()
    
    let arrData = [
        "Type",
        "Shape",
        "Size",
        "Flavour",
        "Filling",
        "Info"
    ]
    
    var segmentedControl = HMSegmentedControl()
    
    
    @IBOutlet weak var typeTbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.data = self.getData(type: .type)
        self.typeTbl.delegate = self
        self.typeTbl.dataSource = self
        self.btnContinue.layer.cornerRadius = 10
        self.btnPrevious.layer.cornerRadius = 10
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

    
    @IBAction func btnPrevious(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex > 0 {
            let selectedIndex = segmentedControl.selectedSegmentIndex - 1
            segmentedControl.selectedSegmentIndex = selectedIndex
            switch selectedIndex {
            case 0:
                self.data = self.getData(type: .type)
                self.typeTbl.reloadData()
                return
            case 1:
                self.data = self.getData(type: .shape)
                self.typeTbl.reloadData()
                return
            case 2:
                self.data = self.getData(type: .size)
                self.typeTbl.reloadData()
                return
            case 3:
                self.data = self.getData(type: .flavour)
                self.typeTbl.reloadData()
                return
            case 4:
                self.data = self.getData(type: .filling)
                self.typeTbl.reloadData()
                return
            case 5:
                self.data = self.getData(type: .info)
                self.typeTbl.reloadData()
                return
            default:
                print("selectedSegmentIndex : - Error")
        }
        }
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex < arrData.count - 1 {
            let selectedIndex = segmentedControl.selectedSegmentIndex + 1
            segmentedControl.selectedSegmentIndex = selectedIndex
            switch selectedIndex {
            case 1:
                self.data = self.getData(type: .shape)
                self.typeTbl.reloadData()
                return
            case 2:
                self.data = self.getData(type: .size)
                self.typeTbl.reloadData()
                return
            case 3:
                self.data = self.getData(type: .flavour)
                self.typeTbl.reloadData()
                return
            case 4:
                self.data = self.getData(type: .filling)
                self.typeTbl.reloadData()
                return
            case 5:
                self.data = self.getData(type: .info)
                self.typeTbl.reloadData()
                return
            default:
                print("selectedSegmentIndex : - Error")
        }
        }
        
    }
    
    func getData(type:TypeCake) -> [model] {
        let arrData =  self.typeData.filter { model in
           if model.typeCake == type {
                return true
            }
            return false
        }
        return arrData
    }
    
    func setUpView(){
        segmentedControl = HMSegmentedControl(sectionTitles: arrData)
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.selectionIndicatorColor = .clear
        segmentedControl.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        segmentedControl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white.cgColor];
        
        segmentedControl.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width == 375.0 ? ( self.vwControl.layer.frame.width-30): (self.vwControl.layer.frame.width), height: self.vwControl.frame.height)
        segmentedControl.addTarget(self, action: #selector(self.getValue(_:)), for: .valueChanged)
        vwControl.addSubview(segmentedControl)
    }
    
    @objc func getValue(_ sender: HMSegmentedControl){
        print(self.arrData[Int(exactly: sender.selectedSegmentIndex)!].description)
        switch sender.selectedSegmentIndex {
        case 0:
            self.data = self.getData(type: .type)
            self.typeTbl.reloadData()
            return
        case 1:
            self.data = self.getData(type: .shape)
            self.typeTbl.reloadData()
            return
        case 2:
            self.data = self.getData(type: .size)
            self.typeTbl.reloadData()
            return
        case 3:
            self.data = self.getData(type: .flavour)
            self.typeTbl.reloadData()
            return
        case 4:
            self.data = self.getData(type: .filling)
            self.typeTbl.reloadData()
            return
        case 5:
            self.data = self.getData(type: .info)
            self.typeTbl.reloadData()
            return
        default:
            print("selectedSegmentIndex : - Error")
        }
    }
    

}

class TypeCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCakeType: UIImageView!
    
    func configCell(data: model) {
        self.imgCakeType.setImageForName(string: data.imageString ?? "", circular: true)
        self.lblTitle.text = data.title
    }
}
