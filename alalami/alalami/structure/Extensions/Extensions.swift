//
//  Extensions.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import MOLH

extension UIViewController {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if (MOLHLanguage.currentAppleLanguage() == "ar") {
            navigationController?.view.semanticContentAttribute = .forceRightToLeft
            navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        }else {
            navigationController?.view.semanticContentAttribute = .forceLeftToRight
            navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func topMostViewController() -> UIViewController {
           
           if let presented = self.presentedViewController {
               return presented.topMostViewController()
           }
           
           if let navigation = self as? UINavigationController {
               return navigation.visibleViewController?.topMostViewController() ?? navigation
           }
           
           if let tab = self as? UITabBarController {
               return tab.selectedViewController?.topMostViewController() ?? tab
           }
           
           return self
       }
    
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
}


extension UITableView {
    func setEmptyView(title: String, message: String, image : String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let img = UIImage(named: image)
        let imageView = UIImageView(image: img!)
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        messageLabel.textColor = UIColor.text_dark
        
        if (MOLHLanguage.currentAppleLanguage() == "ar") {
            titleLabel.font = UIFont(name: Constants.ARABIC_BOLD, size: 18)
            messageLabel.font = UIFont(name: Constants.ARABIC_REGULAR, size: 13)
        }else {
            titleLabel.font = UIFont(name: Constants.ENGLISH_BOLD, size: 18)
            messageLabel.font = UIFont(name: Constants.ENGLISH_REGULAR, size: 13)
        }
        
        imageView.contentMode = .scaleAspectFit
        emptyView.addSubview(imageView)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        imageView.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 180.0).isActive = true
        
        //  imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}


extension UICollectionView {
    func setEmptyView(title: String, message: String, image : String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let img = UIImage(named: image)
        let imageView = UIImageView(image: img!)
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        messageLabel.textColor = UIColor.text_dark
        
        if (MOLHLanguage.currentAppleLanguage() == "ar") {
            titleLabel.font = UIFont(name: Constants.ARABIC_BOLD, size: 18)
            messageLabel.font = UIFont(name: Constants.ARABIC_REGULAR, size: 13)
        }else {
            titleLabel.font = UIFont(name: Constants.ENGLISH_BOLD, size: 18)
            messageLabel.font = UIFont(name: Constants.ENGLISH_REGULAR, size: 13)
        }
        
        imageView.contentMode = .scaleAspectFit
        emptyView.addSubview(imageView)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        imageView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        // self.separatorStyle = .none
    }
    
    func setEmptyViewWithoutImage(title: String, message: String) {
           let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
           
           let titleLabel = UILabel()
           let messageLabel = UILabel()
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           messageLabel.translatesAutoresizingMaskIntoConstraints = false
           titleLabel.textColor = UIColor.black
           messageLabel.textColor = UIColor.text_dark
           
           if (MOLHLanguage.currentAppleLanguage() == "ar") {
               titleLabel.font = UIFont(name: Constants.ARABIC_BOLD, size: 18)
               messageLabel.font = UIFont(name: Constants.ARABIC_REGULAR, size: 13)
           }else {
               titleLabel.font = UIFont(name: Constants.ENGLISH_BOLD, size: 18)
               messageLabel.font = UIFont(name: Constants.ENGLISH_REGULAR, size: 13)
           }
           
           emptyView.addSubview(titleLabel)
           emptyView.addSubview(messageLabel)
           
           titleLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 20).isActive = true
           titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
           titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
           
           messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
           messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
           messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
           
           titleLabel.text = title
           messageLabel.text = message
           messageLabel.numberOfLines = 0
           messageLabel.textAlignment = .center
           titleLabel.textAlignment = .center
           // The only tricky part is here:
           self.backgroundView = emptyView
           // self.separatorStyle = .none
       }
    
    
    func restore() {
        self.backgroundView = nil
        // self.separatorStyle = .none
    }
    
    func scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {
        let lastSection = numberOfSections - 1
        guard lastSection >= 0 else { return }
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return }
        let lastItemIndexPath = IndexPath(item: lastItem, section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: scrollPosition, animated: animated)
    }
    
}


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 384
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
    
    var visibleViewController: UIViewController? {

            guard let rootViewController = keyWindow?.rootViewController else {
                return nil
            }

            return getVisibleViewController(rootViewController)
        }

        private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {

            if let presentedViewController = rootViewController.presentedViewController {
                return getVisibleViewController(presentedViewController)
            }

            if let navigationController = rootViewController as? UINavigationController {
                return navigationController.visibleViewController
            }

            if let tabBarController = rootViewController as? UITabBarController {
                return tabBarController.selectedViewController
            }

            return rootViewController
        }
    
    
}



extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 0.7) else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }

    func optimizedIfNeeded() -> UIImage? {
           guard let imageData = self.pngData() else { return nil }

           var resizingImage = self
           var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB

           while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
               guard let resizedImage = resizingImage.resized(withPercentage: 0.7),
                     let imageData = resizedImage.pngData()
                   else { return nil }

               resizingImage = resizedImage
               imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
           }

           return resizingImage
       }

       func resized(withPercentage percentage: CGFloat) -> UIImage? {
           let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
           UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
           defer { UIGraphicsEndImageContext() }
           draw(in: CGRect(origin: .zero, size: canvasSize))
           return UIGraphicsGetImageFromCurrentImageContext()
       }

       static func named(_ name: String) -> UIImage? {
           UIImage(named: name)
       }
}

//extension UIImage {
//
//    enum Format: String {
//        case png = "png"
//        case jpeg = "jpeg"
//    }
//
//    func toBase64(type: Format = .jpeg, quality: CGFloat = 1, addMimePrefix: Bool = false) -> String? {
//        let imageData: Data?
//        switch type {
//        case .jpeg: imageData = jpegData(compressionQuality: quality)
//        case .png:  imageData = pngData()
//        }
//        guard let data = imageData else { return nil }
//
//        let base64 = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
//
//        var result = base64
//        if addMimePrefix {
//            let prefix = "data:image/\(type.rawValue);base64,"
//            result = prefix + base64
//        }
//        return result
//    }
//}
//



extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension String {
    
    var isNumeric: Bool {
           guard self.count > 0 else { return false }
           let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
           return Set(self).isSubset(of: nums)
       }
    
    func fromBase64() -> String? {
            guard let data = Data(base64Encoded: self) else {
                return nil
            }
            return String(data: data, encoding: .utf8)
        }

        func toBase64() -> String {
            return Data(self.utf8).base64EncodedString()
        }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func numbersLocalized()-> String {
        
        guard MOLHLanguage.currentAppleLanguage() == "ar" else {
            return self
        }
        
        let numbersDictionary : Dictionary = ["0" : "٠","1" : "١", "2" : "٢", "3" : "٣", "4" : "٤", "5" : "٥", "6" : "٦", "7" : "٧", "8" : "٨", "9" : "٩", "/" : "\\"]
        
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    
    func convertToEnglish() -> String {
        
        let numbersDictionary : Dictionary = ["٠" : "0", "١" : "1", "٢" : "2", "٣" : "3", "٤" : "4", "٥" : "5", "٦" : "6", "٧" : "7", "٨" : "8", "٩" : "9"]
        
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var hex: Int? {
        return Int(self, radix: 16)
    }
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    func convertToEnglishNumber()->String{
        let format = NumberFormatter()
        format.locale = Locale(identifier: "en")
        if let number = format.number(from: self) {
            let faNumber = format.string(from: number)
            return faNumber ?? ""
        }
        return ""
    }
    
    public var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
}


extension UIColor {
    
    static var app_red:UIColor {
        return #colorLiteral(red: 0.9294117647, green: 0.1333333333, blue: 0.1843137255, alpha: 1)
    }
    static var highlight_blue:UIColor {
        return #colorLiteral(red: 0.1725490196, green: 0.2039215686, blue: 0.7254901961, alpha: 1)
    }
    static var text_dark:UIColor {
        return #colorLiteral(red: 0.3098039216, green: 0.3568627451, blue: 0.4549019608, alpha: 1)
    }
    static var text_light : UIColor {
        return #colorLiteral(red: 0.4784313725, green: 0.5254901961, blue: 0.6039215686, alpha: 1)
    }
    static var window_color : UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var ERROR:UIColor{
        return #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
    }
    static var SUCCESS:UIColor{
        return #colorLiteral(red: 0.5450980392, green: 0.7647058824, blue: 0.2901960784, alpha: 1)
    }
    static var INFO:UIColor{
        return #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
    }
    static var WARNING:UIColor{
        return #colorLiteral(red: 0.7764705882, green: 1, blue: 0, alpha: 1)
    }
    static var tab_unselected:UIColor{
        return #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    static var border_color: UIColor {
        return #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    }
    
    static var tag_selected : UIColor {
        return #colorLiteral(red: 0.2, green: 0.2901960784, blue: 0.4, alpha: 1)
    }
    static var tag_unselected : UIColor {
        return #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 0.8980392157, alpha: 1)
    }
    
    static var card_focused_color:UIColor{
        return #colorLiteral(red: 0.1058823529, green: 0.1529411765, blue: 0.2862745098, alpha: 1)
    }
    
    static var card_color:UIColor{
        return #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 0.8980392157, alpha: 1)
    }
    
    static var text_disabled:UIColor{
        return #colorLiteral(red: 0.7058823529, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
    }
    
    static var app_green : UIColor {
        return #colorLiteral(red: 0.3254901961, green: 0.6980392157, blue: 0.003921568627, alpha: 1)
    }
    static var text_gray : UIColor {
        return #colorLiteral(red: 0.6588235294, green: 0.6705882353, blue: 0.7450980392, alpha: 1)
    }
    
    static var disabled : UIColor {
        return #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.968627451, alpha: 1)
    }
    static var disabled_text : UIColor {
        return #colorLiteral(red: 0.1058823529, green: 0.1529411765, blue: 0.2862745098, alpha: 1)
    }
    static var enabled : UIColor {
        return #colorLiteral(red: 0.9294117647, green: 0.1333333333, blue: 0.1843137255, alpha: 1)
    }
    static var enabled_text : UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var selected_color : UIColor {
        return #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1568627451, alpha: 1)
    }
    static var unselected_color : UIColor {
        return #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8823529412, alpha: 1)
    }
    static var card_selected : UIColor {
        return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    static var card_not_selected : UIColor {
        return #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
    }
    
    //order
    static var request_pending : UIColor {
        return #colorLiteral(red: 0.968627451, green: 0.7098039216, blue: 0, alpha: 1)
    }
    static var request_approved : UIColor {
        return #colorLiteral(red: 0.968627451, green: 0.7098039216, blue: 0, alpha: 1)
    }
    static var request_cancelled : UIColor {
        return #colorLiteral(red: 0.8784313725, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
    }
    static var request_rejected : UIColor {
        return #colorLiteral(red: 0.8784313725, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
    }
    static var request_received : UIColor {
        return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
    }
    static var request_returned : UIColor {
        return #colorLiteral(red: 0.5725490196, green: 0.5411764706, blue: 0.7764705882, alpha: 1)
    }
    static var request_completed : UIColor {
        return #colorLiteral(red: 0.3254901961, green: 0.7019607843, blue: 0.003921568627, alpha: 1)
    }
    
    static var hint_color : UIColor {
        return #colorLiteral(red: 0.6509803922, green: 0.6823529412, blue: 0.737254902, alpha: 1)
    }
    
    static var facebook_color:UIColor {
        return #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1)
    }
    static var twitter_color:UIColor {
        return #colorLiteral(red: 0.2549019608, green: 0.5647058824, blue: 0.8039215686, alpha: 1)
    }
    static var instagram_color:UIColor {
        return #colorLiteral(red: 0.8039215686, green: 0.2823529412, blue: 0.4196078431, alpha: 1)
    }
    static var whatsapp_color:UIColor {
        return #colorLiteral(red: 0.1450980392, green: 0.8274509804, blue: 0.4, alpha: 1)
    }
    static var calendar_disabled:UIColor {
        return #colorLiteral(red: 0.1450980392, green: 0.8274509804, blue: 0.4, alpha: 1)
    }
    static var calendar_not_available:UIColor {
        return #colorLiteral(red: 0.1450980392, green: 0.8274509804, blue: 0.4, alpha: 1)
    }
    static var calendar_available:UIColor {
        return #colorLiteral(red: 0.1450980392, green: 0.8274509804, blue: 0.4, alpha: 1)
    }
    static var navigate_color: UIColor {
        return #colorLiteral(red: 0, green: 0.7137254902, blue: 0.7058823529, alpha: 1)
    }
    static var call_color: UIColor {
        return #colorLiteral(red: 0.9490196078, green: 0.431372549, blue: 0.1490196078, alpha: 1)
    }
    
    //visit status colors
    static var accepted : UIColor {
        return #colorLiteral(red: 0.07058823529, green: 0.3450980392, blue: 0.4509803922, alpha: 1)
    }
    static var completed : UIColor {
        return #colorLiteral(red: 0.09411764706, green: 0.6156862745, blue: 0.2549019608, alpha: 1)
    }
    static var cancelled : UIColor {
        return #colorLiteral(red: 0.7568627451, green: 0.06666666667, blue: 0.231372549, alpha: 1)
    }
    static var pending: UIColor {
        return #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2, alpha: 1)
    }
    static var ontheway: UIColor {
        return #colorLiteral(red: 0.9843137255, green: 0.5882352941, blue: 0.4352941176, alpha: 1)
    }
    static var rejected: UIColor {
        return #colorLiteral(red: 0.7568627451, green: 0.06666666667, blue: 0.231372549, alpha: 1)
    }
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
        
    }
    
    var parentViewController: UIViewController? {
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                if parentResponder is UIViewController {
                    return parentResponder as? UIViewController
                }
            }
            return nil
        }
    
    //anchors
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    
    
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 0.0
        }, completion: completion)
    }
    
    
}
extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            }
        }
    }
}
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
private var __maxLengths = [UITextField: Int]()
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.autocapitalizationType = .words
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
   
    @IBInspectable var maxLength: Int {
           get {
               guard let l = __maxLengths[self] else {
                   return 150
               }
               return l
           }
           set {
               __maxLengths[self] = newValue
               addTarget(self, action: #selector(fix), for: .editingChanged)
           }
       }
       @objc func fix(textField: UITextField) {
           if let t = textField.text {
               textField.text = String(t.prefix(maxLength))
           }
       }
}

extension UITextView {
    func setHTMLFromString(htmlText: String) {
            let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

            let attrStr = try! NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
                documentAttributes: nil)

            self.attributedText = attrStr
        }
}

extension UINavigationController {
    
    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
    
    
}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    func setHTMLFromString(htmlText: String) {
            let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

            let attrStr = try! NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
                documentAttributes: nil)

            self.attributedText = attrStr
        }
}

protocol Utilities {}
extension NSObject: Utilities {
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }

    var currentReachabilityStatus: ReachabilityStatus {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }

        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
}

extension UIView {
    
    func dropShadow(color: UIColor = .black,
                    opacity: Float = 0.5,
                    offSet: CGSize,
                    radius: CGFloat = 1) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addMiddleBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:self.frame.size.width/2, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
