//
//  CakeModel.swift
//  cakeApp


import Foundation

class CakeModel {
    var docID: String
    var name: String
    var price: String
    var description: String
    var image: String
    
    init(docID: String,name: String,price: String,description: String,image:String) {
        self.docID = docID
        self.price = price
        self.name = name
        self.description = description
        self.image = image
    }
}
