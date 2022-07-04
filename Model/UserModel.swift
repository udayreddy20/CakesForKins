//
//  UserModel.swift
//  cakeApp


import Foundation

class UserModel {
    var docID: String
    var name: String
    var mobile: String
    var address: String
    var email: String
    var password: String
    
    
    init(docID: String,name: String,mobile: String,email: String,password:String,address:String) {
        self.docID = docID
        self.email = email
        self.mobile = mobile
        self.password = password
        self.address = address
        self.name = name
    }
}
