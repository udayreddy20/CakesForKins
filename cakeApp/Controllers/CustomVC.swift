//
//  CustomVC.swift
//  cakeApp


import UIKit
import SendGrid

class CustomVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtShape: UITextField!
    @IBOutlet weak var txtSize: UITextField!
    @IBOutlet weak var txtFlavour: UITextField!
    @IBOutlet weak var txtFilling: UITextField!
    @IBOutlet weak var txtInfo: UITextField!
    
    
    let typeData: [model] = [
        model(imageString: "regular", title: "Regular", typeCake: .type),
        model(imageString: "gluten free", title: "Gluten Free", typeCake: .type),
        model(imageString: "vegan", title: "Vegan", typeCake: .type),
        model(imageString: "eggless", title: "Eggless", typeCake: .type),
        model(imageString: "sugar free", title: "Sugar Free", typeCake: .type),
        model(imageString: "fondant", title: "Fodant", typeCake: .type),
        model(imageString: "pinata", title: "Pinata", typeCake: .type),
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
    let pickerType = UIPickerView()
    let pickerShape = UIPickerView()
    let pickerFlavour = UIPickerView()
    let pickerFilling = UIPickerView()
    let pickerSize = UIPickerView()
    var toolBar = UIToolbar()
    
    let arrData = [
        "Type",
        "Shape",
        "Size",
        "Flavour",
        "Filling",
        "Info"
    ]
    
    
    func getData(type:TypeCake) -> [model] {
        let arrData =  self.typeData.filter { model in
           if model.typeCake == type {
                return true
            }
            return false
        }
        return arrData
    }
    
    
    func setup(sender: UITextField, picker: UIPickerView) {
        sender.delegate = self
        picker.delegate = self
        picker.dataSource = self
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "forgotPassword DropDown Arrow.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 35)
        button.frame = CGRect(x: CGFloat(UIScreen.main.bounds.size.height - 50), y: CGFloat(5), width: CGFloat(25), height: CGFloat(45))
        button.isUserInteractionEnabled = false
        sender.rightView = button
        sender.rightViewMode = .always
        sender.inputView = picker
//        picker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 180, width: UIScreen.main.bounds.size.width, height: 150)
        
    }
    
    func validation() -> String{
        if self.txtType.text!.isEmpty {
            return "Please select type"
        } else if self.txtShape.text!.isEmpty {
            return "Please select shape"
        } else if self.txtSize.text!.isEmpty {
            return "Please select size"
        } else if self.txtFlavour.text!.isEmpty {
            return "Please select flavour"
        } else if self.txtFilling.text!.isEmpty {
            return "Please select filling"
        } else if self.txtInfo.text!.isEmpty {
            return "Please enter info"
        }
        
        return ""
    }
    
    func UTCToDate(date:Date) -> String {
        let formatter = DateFormatter()
       
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)  // convert your string to date
        formatter.dateFormat = "dd, MMM, yyyy"  //then again set the date format whhich type of output you need
        return formatter.string(from: yourDate!) // again convert your date to string
    }
    
    
    @IBAction func btnPlaceOrderClick(_ sender: UIButton) {
        let error = self.validation()
        if error.isEmpty {
            self.createOrder(user: GFunction.user, date: self.UTCToDate(date: Date()))
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.data = self.getData(type: .type)
        self.view.addSubview(toolBar)
        self.setup(sender: txtSize, picker: pickerSize)
        self.setup(sender: txtShape, picker: pickerShape)
        self.setup(sender: txtType, picker: pickerType)
        self.setup(sender: txtFilling, picker: pickerFilling)
        self.setup(sender: txtFlavour, picker: pickerFlavour)
        //picker
        
        // Do any additional setup after loading the view.
    }

}


extension CustomVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerType {
            self.data = self.getData(type: .type)
        } else if pickerView == pickerSize {
            self.data = self.getData(type: .size)
        } else if pickerView == pickerShape {
            self.data = self.getData(type: .shape)
        } else if pickerView == pickerFlavour {
            self.data = self.getData(type: .flavour)
        } else if pickerView == pickerFilling {
            self.data = self.getData(type: .filling)
        }
        return self.data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.data[row].title.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerType {
            self.txtType.text = self.data[row].title
        } else if pickerView == pickerSize {
            self.txtSize.text = self.data[row].title
        } else if pickerView == pickerShape {
            self.txtShape.text = self.data[row].title
        } else if pickerView == pickerFlavour {
            self.txtFlavour.text = self.data[row].title
        } else if pickerView == pickerFilling {
            self.txtFilling.text = self.data[row].title
        }
    }
    
    func createOrder(user:UserModel,date:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(cOrder).addDocument(data:
            [
                cName: "Custom Cake",
                cEmail : user.email.description,
                cOrderDate: date,
                cPrice: "$899",
                cDescription: "",
                cImagePath: "https://firebasestorage.googleapis.com/v0/b/cakeapp-9efb9.appspot.com/o/cakes%2Fp-mesmeric-chocolate-almond-cake-half-kg--109557-m.webp?alt=media&token=b1732744-6c27-4d8d-ac65-7b41f3cf314b",
                cStatus: "Custom Made",
                cQuantity: "1"
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                let fullname = "\(user.name)"
               // self.emailSend(fullName: fullname, email: user.email)
            }
        }
    }
  
}
    
