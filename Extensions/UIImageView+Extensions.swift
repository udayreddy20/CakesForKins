//
//  UIImageView+Extensions.swift

import Foundation
import SDWebImage

extension UIImageView {
    func setImgWebUrl(url : String, isIndicator : Bool){
        if isIndicator == true{
            SDWebImageActivityIndicator.gray.indicatorView.color = UIColor.systemPink
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }else{
            self.sd_imageIndicator = nil
        }
        self.sd_setImage(with: URL(string: url), placeholderImage:UIImage(named: "PlaceHolder"))
    }
}


extension UIView {
    func shadowView() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5.0
    }
}
