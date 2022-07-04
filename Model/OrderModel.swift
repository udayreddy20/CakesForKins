//
//  OrderModel.swift
//  cakeApp

import Foundation


class OrderModel {
    var docID: String
    var name: String
    var description: String
    var imagePath: String
    var email: String
    var orderDate: String
    var price: String
    var status: String
    var qty: String
    
    
    init(docID: String,name: String,description: String,email: String,orderDate:String,imagePath:String,price: String,status:String, qty:String) {
        self.docID = docID
        self.email = email
        self.description = description
        self.orderDate = orderDate
        self.imagePath = imagePath
        self.name = name
        self.price = price
        self.status = status
        self.qty = qty
    }
}
