//
//  DashboardVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import ImageTransition
import FirebaseMessaging

enum HomeActionType {
    case send_money
    case receive_money
    case history
    case order_card
    case daman
}
struct HomeAction {
    var imageName : String?
    var title : String?
    var type : HomeActionType?
}

//0c343d

class DashboardVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //shortname
    @IBOutlet weak var lblShortName: MyUILabel!
    
    
    //notifications
    @IBOutlet weak var cvCount: CardView!
    @IBOutlet weak var lblCount: UILabel!
    
    
    //flashcards
    @IBOutlet weak var collectionFlashCardsHeight: NSLayoutConstraint! //182
    @IBOutlet weak var collectionFlashCards: UICollectionView!
    var flashcards = [FlashCardDatum]()
    
    
    //user card
    @IBOutlet weak var viewUserCard: UIView!
    @IBOutlet weak var lblUserFullName: MyUILabel!
    @IBOutlet weak var lblUserGreetings: MyUILabel!
    
    
    //user amounts card
    @IBOutlet weak var viewUserAmountCard: UIView!
    @IBOutlet weak var lblUserAmountGreetings: MyUILabel!
    @IBOutlet weak var lblUserAmountFullName: MyUILabel!
    @IBOutlet weak var lblSendAmount: MyUILabel!
    @IBOutlet weak var lblReceiveAmount: MyUILabel!
    
    //actions
    @IBOutlet weak var collectionActions: UICollectionView!
    
    var homeActions = [HomeAction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("currentHour\(getNowDate().hour)")

        
        self.collectionFlashCards.collectionViewLayout = ArabicCollectionFlow()
        self.collectionFlashCards.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        self.collectionFlashCards.delegate = self
        self.collectionFlashCards.dataSource = self
        
        self.collectionActions.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionActions.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        self.collectionActions.delegate = self
        self.collectionActions.dataSource = self
        
        setUpActions()
        
        self.collectionActions.reloadData()
        
        self.setupTransitionConfig()
        
        updateDeviceInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotifications), name: NSNotification.Name(rawValue: "notificationsCountShouldRefresh"), object: nil)
        
        handleClickedNotification()
    }
    
    @objc private func refreshNotifications() {
        validateNotificationsCount()
    }
    
    private func handleClickedNotification() {
        let notificationType = App.shared.notificationType ?? ""
        let notificationValue = App.shared.notificationValue ?? ""
        if ((notificationType == "1" || notificationType == "2") && notificationValue.count > 0) { //send || receive
            App.shared.notificationType = nil
            App.shared.notificationValue = nil
            loadRemittanceDetails(id: notificationValue)
        }
        
    }
    
    private func loadRemittanceDetails(id : String) {
        self.openRemittanceDetails(transactionId: id)
    }
    
    private func openRemittanceDetails(transactionId : String) {
        let vc : TransactionDetailsVC = self.getStoryBoard(name: Constants.STORYBOARDS.transactions).instantiateViewController(withIdentifier: "TransactionDetailsVC") as! TransactionDetailsVC
        vc.transactionId = transactionId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func validateNotificationsCount() {
        let count = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.NOTIFICATION_COUNT) as? Int ?? 0
        if (count > 0) {
            self.cvCount.isHidden = false
            self.lblCount.text = "\(count)"
        }else {
            self.cvCount.isHidden = true
        }
    }
    
    func loadRemittanceSettings() {
        getApiManager().getRemittanceSettings(token: getAccessToken()) { (response) in
            App.shared.remittanceSettings = response.data ?? [RemittanceSettingsDatum]()
        }
    }
    
    private func updateDeviceInfo() {
        let regId = Messaging.messaging().fcmToken ?? "not_avaliable"
        getApiManager().updateDeviceInfo(token: getAccessToken(), regId: regId) { (response) in
            
        }
    }
    
    private func setUpActions() {
        var action = HomeAction(imageName: "ic_sendmoney", title: "send_money".localized, type: .send_money)
        homeActions.append(action)
        
        action = HomeAction(imageName: "ic_history", title: "history".localized, type: .history)
        homeActions.append(action)
        
        action = HomeAction(imageName: "ic_receive_money", title: "receive_money".localized, type: .receive_money)
        homeActions.append(action)
        
//        action = HomeAction(imageName: "ic_order_card", title: "order_your_card".localized, type: .order_card)
//        homeActions.append(action)
        
        
        action = HomeAction(imageName: "ic_newDaman", title: "daman".localized, type: .daman)
        homeActions.append(action)
    }
    
    private func loadAvailableSendAmount() {
        self.getApiManager().getAvailableSendAmount(token: getAccessToken()) { (response) in
            if (response.code ?? "" == "100" && (response.success ?? false)) {
                App.shared.availableSendAmount = response.data ?? 0.0
                self.showAmountsCard(show: true)
            }else {
                self.showAmountsCard(show: false)
            }
        }
    } 
    
    private func loadAvailableReceiveAmount() {
        self.getApiManager().getAvailableReceiveAmount(token: getAccessToken()) { (response) in
            if (response.code ?? "" == "100" && (response.success ?? false)) {
                App.shared.availableReceiveAmount = response.data ?? 0.0
                self.showAmountsCard(show: true)
            }else {
                self.showAmountsCard(show: false)
            }
        }
    }
    
    private func showAmountsCard(show : Bool) {
        if (show) {
            viewUserCard.isHidden = true
            viewUserAmountCard.isHidden = false
            lblUserAmountGreetings.text = getGreetingsText()
            lblUserAmountFullName.text = getUserFullName()
            lblReceiveAmount.text = "\(App.shared.availableReceiveAmount ?? 0.0)"
            lblSendAmount.text = "\(App.shared.availableSendAmount ?? 0.0)"
        }else {
            viewUserCard.isHidden = false
            viewUserAmountCard.isHidden = true
            lblUserGreetings.text = getGreetingsText()
            lblUserFullName.text = getUserFullName()
        }
        self.lblShortName.text = getUserShortName()
    }
    
    private func getGreetingsText() -> String {
        let currentHour = self.getNowDate().hour
        if (currentHour >= 12) {
            return "good_evening".localized
        }else {
            return "good_morning".localized
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = nil
        loadFlashCards()
        loadAvailableSendAmount()
        loadAvailableReceiveAmount()
        loadRemittanceSettings()
        validateNotificationsCount()
    }
    
    func loadFlashCards() {
        self.getApiManager().getFlashCards(token: self.getAccessToken()) { (response) in
            if (response.success ?? false) {
                self.flashcards.removeAll()
                self.flashcards.append(contentsOf: response.data ?? [FlashCardDatum]())
                if (self.flashcards.count > 0) {
                    self.collectionFlashCards.isHidden = false
                    self.collectionFlashCardsHeight.constant = 182.0
                }else {
                    self.collectionFlashCards.isHidden = true
                    self.collectionFlashCardsHeight.constant = 0
                }
                self.collectionFlashCards.reloadData()
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    
    //collection delegates
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionFlashCards) {
            return CGSize(width: self.collectionFlashCards.bounds.width - 40, height: self.collectionFlashCards.bounds.height - 5)
        }else {
            return CGSize(width: (self.collectionActions.bounds.width - 45) / 2.0, height: (self.collectionActions.bounds.height - 10) / 2.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionFlashCards) {
            return self.flashcards.count
        }else {
            return self.homeActions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == collectionFlashCards) {
            let flashcard = self.flashcards[indexPath.row]
            let vc : FlashCardDetailsVC = self.getStoryBoard(name: Constants.STORYBOARDS.main).instantiateViewController(withIdentifier: "FlashCardDetailsVC") as! FlashCardDetailsVC
            vc.flashCard = flashcard
            
            self.navigationController?.delegate = ImageTransitionDelegate.shared
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let action = self.homeActions[indexPath.row]
            switch action.type {
            case .send_money:
                if (canSend()) {
                    self.pushParentVC(name: "SendMoneyVC", sb: Constants.STORYBOARDS.main)
                }else {
                    self.showBanner(title: "alert".localized, message: "send_disabled".localized, style: UIColor.INFO)
                }
                break
            case .receive_money:
                if (canReceive()) {
                    self.pushParentVC(name: "ReceiveMoneyVC", sb: Constants.STORYBOARDS.main)
                }else {
                    self.showBanner(title: "alert".localized, message: "receive_disabled".localized, style: UIColor.INFO)
                }
                break
            case .history:
                self.pushParentVC(name: "AllTransactionsVC", sb: Constants.STORYBOARDS.transactions)
                break
                
            case .order_card:
                self.callNumber(phone: "06-5504545")
                break
                
            case .daman:
                self.pushParentVC(name: "DamanVC", sb: Constants.STORYBOARDS.daman)
                break
                
                
            default:
                break
            }
        }
    }
    
    private func canSend() -> Bool {
        let sendItems = App.shared.remittanceSettings?.filter({ (remSetting) -> Bool in
            remSetting.id ?? 0 == Constants.REMITTANCE_SETTINGS.send_remittance
        })
        if (sendItems?.count ?? 0 > 0) {
            return sendItems?[0].value ?? "false" == "true"
        }else {
            return false
        }
    }
    
    private func canReceive() -> Bool {
        let receiveItems = App.shared.remittanceSettings?.filter({ (remSetting) -> Bool in
                 remSetting.id ?? 0 == Constants.REMITTANCE_SETTINGS.receive_remittance
        })
        if (receiveItems?.count ?? 0 > 0) {
            return receiveItems?[0].value ?? "false" == "true"
        }else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == collectionFlashCards) {
            let cell: FlashCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlashCardCell", for: indexPath as IndexPath) as! FlashCardCell
            
            let flashCard = self.flashcards[indexPath.row]
            
            cell.lblTitle.text = flashCard.title ?? ""
            
            let url = URL(string: "\(Constants.IMAGE_URL)\(flashCard.image ??  "")")
            cell.ivLogo.kf.setImage(with: url, placeholder: UIImage(named: "flashcard_placeholder"))
            
            var bgColor : UIColor?
            
            if (flashCard.color?.count ?? 0 > 0) {
                bgColor = hexStringToUIColor(hex: flashCard.color ?? "")
            }else {
                bgColor = self.hexStringToUIColor(hex: "#2C34B9")
            }
            
            cell.bgColor.backgroundColor = bgColor
            
            return cell
        }else {
            let cell: HomeActionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeActionCell", for: indexPath as IndexPath) as! HomeActionCell
            let action = self.homeActions[indexPath.row]
            cell.lblTitle.text = action.title ?? ""
            cell.ivLogo.image = UIImage(named: action.imageName ?? "")
            return cell
        }
        
    }
    
    private func selectedCell() -> FlashCardCell? {
        guard let selectedIndexPath = self.collectionFlashCards.indexPathsForSelectedItems?.first,
              let selectedCell = self.collectionFlashCards.cellForItem(at: selectedIndexPath) as? FlashCardCell else {
            //assertionFailure()
            return nil
        }
        return selectedCell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell(collectionView: self.collectionFlashCards)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell(collectionView: self.collectionFlashCards)
        }
    }
    
    
    func scrollToNearestVisibleCollectionViewCell(collectionView : UICollectionView) {
        let visibleCenterPositionOfScrollView = Float(collectionView.contentOffset.x + (collectionView.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<collectionView.visibleCells.count {
            let cell = collectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = collectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            collectionView.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
    
    @IBAction func profileAction(_ sender: Any) {
        self.openProfileScreen()
    }
    
    @IBAction func notificationsAction(_ sender: Any) {
        self.openNotificationsScreen()
    }
    
      
}

extension DashboardVC: ImageTransitionable {
    var imageViewForTransition: UIImageView? {
        guard let selectedCell = selectedCell() else { return nil }
        return selectedCell.ivLogo
    }
}
