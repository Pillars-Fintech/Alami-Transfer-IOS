//
//  BaseVC.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//cd

import UIKit
import BRYXBanner
import MOLH
import SVProgressHUD
import CoreLocation
import MapKit
import SwiftDate
import DatePickerDialog
import ImageTransition

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeToPop()
        SVProgressHUD.setDefaultMaskType(.clear)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // UIApplication.shared.statusBarView?.backgroundColor = UIColor.pages_background
    }
    
    func swipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func showLoading() {
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func presentNav(name : String, sb : String) {
        let initialViewControlleripad : UIViewController = getStoryBoard(name: sb).instantiateViewController(withIdentifier: name) as! UINavigationController
        initialViewControlleripad.modalPresentationStyle = .fullScreen
        self.present(initialViewControlleripad, animated: true, completion: {})
    }
    
    func presentTabBar(name : String, sb : String) {
        let initialViewControlleripad : UIViewController = getStoryBoard(name: sb).instantiateViewController(withIdentifier: name)
        initialViewControlleripad.modalPresentationStyle = .fullScreen
        self.present(initialViewControlleripad, animated: true, completion: {})
    }
    
    func isArabic() -> Bool {
        if (MOLHLanguage.currentAppleLanguage() == "ar") {
            return true
        }else {
            return false
        }
    }
    
    
    
    func showBanner(title:String, message:String,style: UIColor) {
//        let banner = Banner(title: title, subtitle: message, image: nil, backgroundColor: style)
//        banner.dismissesOnTap = true
//        banner.textColor = UIColor.white
//        if (isArabic()) {
//            banner.titleLabel.font = UIFont(name: Constants.ARABIC_BOLD, size: 16)
//            banner.detailLabel.font = UIFont(name: Constants.ARABIC_MEDIUM, size: 14)
//        }else {
//            banner.titleLabel.font = UIFont(name: Constants.ENGLISH_BOLD, size: 16)
//            banner.detailLabel.font = UIFont(name: Constants.ENGLISH_MEDIUM, size: 14)
//        }
//
//        banner.show(duration: 2.0)
        showAlert(title: title, message: message)
    }
    
    func showBanner(title:String, message:[String]?,style: UIColor) {
        var messageStr = "";
        for str in message ?? [String]() {
            messageStr = "\(messageStr)\n\(str)"
        }
//        let banner = Banner(title: title, subtitle: messageStr, image: nil, backgroundColor: style)
//        banner.dismissesOnTap = true
//        banner.textColor = UIColor.white
//        if (isArabic()) {
//            banner.titleLabel.font = UIFont(name: Constants.ARABIC_BOLD, size: 16)
//            banner.detailLabel.font = UIFont(name: Constants.ARABIC_MEDIUM, size: 14)
//        }else {
//            banner.titleLabel.font = UIFont(name: Constants.ENGLISH_BOLD, size: 16)
//            banner.detailLabel.font = UIFont(name: Constants.ENGLISH_MEDIUM, size: 14)
//        }
//        banner.show(duration: 2.0)
        showAlert(title: title, message: messageStr)
    }
    
    
    func presentVC(name : String, sb : String) {
        let vc = getStoryBoard(name: sb).instantiateViewController(withIdentifier: name)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func pushVC(name : String, sb : String) {
        let vc = getStoryBoard(name: sb).instantiateViewController(withIdentifier: name)
        //  vc.modalPresentationCapturesStatusBarAppearance = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushParentVC(name : String, sb : String) {
        let vc = getStoryBoard(name: sb).instantiateViewController(withIdentifier: name)
        vc.hidesBottomBarWhenPushed = true
        self.parent?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getStoryBoard(name : String) -> UIStoryboard {
        return UIStoryboard.init(name: name, bundle: nil)
    }
    
    func showAlert(title:String,
                   message:String,
                   buttonText:String = "ok".localized,
                   actionHandler:(()->())? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: buttonText, style: UIAlertAction.Style.default) { (action) in
            actionHandler?()
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String,
                   message: String,
                   actionTitle: String,
                   cancelTitle: String,
                   actionHandler:(()->Void)?,
                   cancelHandler:(()->Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            actionHandler?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler?()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showAlertDaynamic(title: String,
                   message: String,
                   actionTitle: String,
                   cancelTitle: String,
                   actionHandler:(()->Void)?,
                   cancelHandler:(()->Void)? ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            actionHandler?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler?()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancel(title: String,
                             message: String,
                             actionTitle: String,
                             cancelTitle: String,
                             actionHandler:(()->Void)?,
                             cancelHandler:(()->Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            actionHandler?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { (action) in
            cancelHandler?()
        }
        let dismissAction = UIAlertAction(title: "cancel".localized, style: .cancel) {
            UIAlertAction in
            
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getApiManager() -> ApiManager {
        if currentReachabilityStatus == .notReachable {
            // Network Unavailable
            self.showAlert(title: "alert".localized, message: "no_internet_connection".localized)
        }
        let manager = ApiManager()
        return manager
    }
    
    
    //
    //
    //dates
    //
    //
    
    func getStringDateWithFormat(dateStr : String, outputFormat : String) -> String {
        let date = dateStr.toDate()
        let dateFinal = date?.toFormat(outputFormat)
        return dateFinal ?? ""
    }
    
    func getStringFromDate(date : Date, outputFormat : String) -> String {
        let dateFinal = date.toFormat(outputFormat)
        return dateFinal
    }
    
    func getDateFromString(dateStr : String) -> Date {
        return dateStr.toDate()?.date ?? Date()
    }
    
    func getNowDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        
        let date = formatter.string(from: Date())
        let formattedDate = self.getDateFromString(dateStr: date)
        
        return formattedDate
    }
    
    
    func getFontName(type : Int) -> String {
        if (self.isArabic()) {
            switch type {
            case Constants.FONT_TYPE.light:
                return Constants.ARABIC_LIGHT
            case Constants.FONT_TYPE.regular:
                return Constants.ARABIC_REGULAR
            case Constants.FONT_TYPE.medium:
                return Constants.ARABIC_MEDIUM
            case Constants.FONT_TYPE.semibold:
                return Constants.ARABIC_SEMIBOLD
            case Constants.FONT_TYPE.bold:
                return Constants.ARABIC_BOLD
            default:
                return Constants.ARABIC_REGULAR
            }
        }else {
            switch type {
            case Constants.FONT_TYPE.light:
                return Constants.ENGLISH_LIGHT
            case Constants.FONT_TYPE.regular:
                return Constants.ENGLISH_REGULAR
            case Constants.FONT_TYPE.medium:
                return Constants.ENGLISH_MEDIUM
            case Constants.FONT_TYPE.semibold:
                return Constants.ENGLISH_SEMIBOLD
            case Constants.FONT_TYPE.bold:
                return Constants.ENGLISH_BOLD
            default:
                return Constants.ENGLISH_REGULAR
            }
        }
    }
    
    func getImageUrl(image : String) -> URL {
        if let url = URL(string: "\(Constants.IMAGE_URL)\(image)") {
            return url
        }
        return  URL(string: (Constants.DUMMY_IMAGE_URL))!
    }
    
    func openUrl(str : String, screenTitle : String) {
        let vc : WebViewVC = self.getStoryBoard(name: Constants.STORYBOARDS.profile).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        vc.url = str
        vc.screenTitle = screenTitle
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func openUrl(str : String) {
        let correctUrl = str.replacingOccurrences(of: "\\", with: "")
        if let url = URL(string: correctUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    func callNumber(phone : String) {
        if (phone.count > 0) {
            if let url = URL(string: "tel://\(phone)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func startNavigation(longitude : Double, latitude : Double) {
        let sourceSelector = UIAlertController(title: "continueUsing".localized, message: nil, preferredStyle: .actionSheet)
        
        if let popoverController = sourceSelector.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        let googleMapsAction = UIAlertAction(title: "googleMaps".localized, style: .default) { (action) in
            
            
            let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)&directionsmode=driving")
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel) { (action) in }
        
        sourceSelector.addAction(googleMapsAction)
        sourceSelector.addAction(cancelAction)
        
        self.present(sourceSelector, animated: true, completion: nil)
    }
    
    func openWhatsApp(phone : String) {
        if (phone.count > 0) {
            if let url = URL(string: "https://api.whatsapp.com/send?phone=\(phone)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }else {
            self.showBanner(title: "alert".localized, message: "not_available".localized, style: UIColor.INFO)
        }
    }
    
    func goHome() {
        self.presentNav(name: "TabBarNav", sb: Constants.STORYBOARDS.main)
    }
    
    func goHomeWithConfirmation() {
        self.showAlert(title: "alert".localized, message: "confirm_go_home".localized, actionTitle: "go_home".localized, cancelTitle: "cancel".localized, actionHandler: {
            self.presentNav(name: "TabBarNav", sb: Constants.STORYBOARDS.main)
            
        })
    }
    
    
    func getDistanceFloat(fromLatitude : Double, fromLongitude : Double,toLatitude : Double, toLongitude : Double) -> Double {
        let userLatLng = CLLocation(latitude: fromLatitude, longitude: fromLongitude)
        let shopLatLng = CLLocation(latitude: toLatitude, longitude: toLongitude)
        let distanceInMeters = shopLatLng.distance(from: userLatLng)
        let distanceInKM = distanceInMeters / 1000.0
        return distanceInKM
    }
    func getDistance(fromLatitude : Double, fromLongitude : Double,toLatitude : Double, toLongitude : Double) -> String {
        let userLatLng = CLLocation(latitude: fromLatitude, longitude: fromLongitude)
        let shopLatLng = CLLocation(latitude: toLatitude, longitude: toLongitude)
        let distanceInMeters = shopLatLng.distance(from: userLatLng)
        let distanceInKM = distanceInMeters / 1000.0
        let distanceStr = String(format: "%.1f", distanceInKM)
        return "\(distanceStr) \("km".localized)"
    }
    
    //--------------------------user
    
    func deleteUser() {
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "key_id")
        
        defaults.set("", forKey: "key_username")
        
        defaults.set("", forKey: "key_fullname")
        
        defaults.set("", forKey: "key_phoneNumber")
        
        defaults.set("", forKey: "key_email")
        
        defaults.set("", forKey: "key_picture")
        
        defaults.set("", forKey: "key_dateOfBirth")
        
        defaults.set("", forKey: "key_createdDate")
        
        defaults.set(false, forKey: "key_active")
        
        defaults.set(true, forKey: "key_allowNotifications")
        
        defaults.set("", forKey: "key_roles")
        
        defaults.set("", forKey: "key_token")
        
        defaults.set("", forKey: "key_refreshToken")
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    func shareAction(content : String) {
        let textToShare = [ content ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    //date formatting
    func dateComponentFromDate(date: Date) -> DateComponents {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DATE_FORMATS.api_date
        formatter.timeZone = .autoupdatingCurrent
        let newDateStr = formatter.string(from: date)
        let newDate = self.getDateFromString(dateStr: newDateStr)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: newDate)
        
        return components
    }
    
    func isValidPassword(password : String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", Constants.PASSWORD_REGEX).evaluate(with: password)
    }
    
    func isPureText(text : String) -> Bool {
        if (text.contains("-")) {
            return false
        }
        return NSPredicate(format: "SELF MATCHES %@", Constants.PERSON_NAME_REGEX).evaluate(with: text)
    }
    
    func isPureTextNumber(text : String) -> Bool {
        if (text.range(of: Constants.TEXT_NUMBER_REGEX, options: .regularExpression) != nil) {
            return false
        }
        return true
    }
    
    func isPureText(text : [String]) -> Bool {
        for str in text {
            if NSPredicate(format: "SELF MATCHES %@", Constants.PERSON_NAME_REGEX).evaluate(with: str) == false {
                return false
            }
        }
        if (text.contains("-")) {
            return false
        }
        return true
    }
    
    func saveDataForBiometric(username : String, password : String) {
        let keychain = KeychainSwift()
        keychain.set(username, forKey: "alami_xmobxilex_biometry")
        keychain.set(password, forKey: "alami_xpassxwordx_biometry")
    }
    
    func getBiometryUsername() -> String {
        let keychain = KeychainSwift()
        return keychain.get("alami_xmobxilex_biometry") ?? ""
    }
    
    func getBiometryPassword() -> String {
        let keychain = KeychainSwift()
        return keychain.get("alami_xpassxwordx_biometry") ?? ""
    }
    
    func emptyBiometryData() {
        let keychain = KeychainSwift()
        keychain.delete("alami_xmobxilex_biometry")
        keychain.delete("alami_xpassxwordx_biometry")
        keychain.delete("alami_xtokxenx_biometry")
        UserDefaults.standard.setValue(false, forKey: Constants.DEFAULT_KEYS.IS_TOUCHID_ACTIVE)
    }
    
    func saveAccessToken(token : String) {
        let keychain = KeychainSwift()
        print("access_token: \(token)")
        keychain.set(token, forKey: "alami_xtokxenx_biometry")
    }
    
    func getAccessToken() -> String {
        let keychain = KeychainSwift()
        return keychain.get("alami_xtokxenx_biometry") ?? ""
    }
    
    func getDefaultBranches() -> [BranchDatum] {
        var defaultBranches = [BranchDatum]()
        //select branch item
        let selectBranch = BranchDatum(branchID: nil, code: "", afexCode: "", name: "select_branch".localized, address: "", phone: "", fax: "", longitude: "0.0", latitude: "0.0", afexCostCenterID: 0, activeInSend: false, activeInReceive: false, hasPhysicalLocation: false)
        defaultBranches.append(selectBranch)
        
        //anywhere payout item
        let anywherePayout = BranchDatum(branchID: nil, code: "", afexCode: "", name: "anywhere_payout".localized, address: "", phone: "", fax: "", longitude: "0.0", latitude: "0.0", afexCostCenterID: 0, activeInSend: false, activeInReceive: false, hasPhysicalLocation: false)
        defaultBranches.append(anywherePayout)
        
        return defaultBranches
    }
    
    
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.showBanner(title: "alert".localized, message: "screenshot_saved_successfully".localized, style: UIColor.SUCCESS)
        }
        return screenshotImage
    }
    
    
    func getDatePicker() -> DatePickerDialog {
        let picker = DatePickerDialog()
        if #available(iOS 13.4, *) {
            picker.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return picker
    }
    
    func openProfileScreen() {
        self.pushParentVC(name: "ProfileMainVC", sb: Constants.STORYBOARDS.profile)
    }
    
    func openNotificationsScreen() {
        self.pushParentVC(name: "NotificationCategoriesVC", sb: Constants.STORYBOARDS.profile)
    }
    
    func setupTransitionConfig() {
        ImageTransitionDelegate.shared.presentDuration = 0.2
        ImageTransitionDelegate.shared.dismissDuration = 0.2
        ImageTransitionDelegate.shared.pushDuration = 0.2
        ImageTransitionDelegate.shared.popDuration = 0.2
    }
    
    func handleError(code : String?, message : [String]?) {
        if (code == "401") {
            self.showAlert(title: "alert".localized, message: "session_expired".localized, buttonText: "login".localized) {
                self.emptyBiometryData()
                self.presentVC(name: "LoginNav", sb: Constants.STORYBOARDS.authentication)
            }
        }else {
        
            
            
            if message == []{
                self.showBanner(title: "alert".localized, message: ["Something Wrong"], style: UIColor.INFO)

                
            }else{
                self.showBanner(title: "alert".localized, message: message, style: UIColor.INFO)

            }

        }
    }
    
     func getUserFullName() -> String {
        let userInfo = App.shared.accountInfo
        return "\(userInfo?.firstNameEn ?? "") \(userInfo?.lastNameEn ?? "")"
    }
    
    func getUserShortName() -> String {
        let userInfo = App.shared.accountInfo
        let firstNameChar = userInfo?.firstNameEn?.prefix(1)
        let lastNameChar = userInfo?.lastNameEn?.prefix(1)
        return "\(firstNameChar?.uppercased() ?? "")\(lastNameChar?.uppercased() ?? "")"
    }
    
    
    func createNotification(title : String, message : String) {
        
        let requestIdentifier = "Notification"
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            
            content.badge = 1
            content.title = title
            content.subtitle = "appname".localized
            content.body = message
            content.categoryIdentifier = "actionCategory"
            content.sound = UNNotificationSound.default
            
            //  self.updateChat()
            
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "not localized")
                }
                print("Notification Register Success")
            }
        } else {
            // Fallback on earlier versions
            let content = UILocalNotification()
            
            content.alertTitle = title
            content.alertBody = message
            content.category = ""
            
        }
        
    }
    
     func showArabicContentAlert(completion:@escaping()-> Void) {
        self.showAlert(title: "alert".localized, message: "arabic_content_only".localized, buttonText: "ok".localized) {
            completion()
        }
    }
    
}
