//
//  SendMoneyVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import Kingfisher

class SendMoneyVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lService: MyUILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var services = [ServiceDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lService.textAlignment = .natural

        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        
        if (isArabic()) {
            lService.textAlignment = .right
        }else{
            lService.textAlignment = .left

        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadServices()
    }
    
    func loadServices() {
        self.showLoading()
        self.getApiManager().getServiceProviders(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.services.removeAll()
                self.services.append(contentsOf: response.data ?? [ServiceDatum]())
                // test only
                let ria = ServiceDatum(servicesProviderID: nil, code: "03", isAvailableSend: true, isAvailableReceived: true, name: "Ria", shortName: "Ria", explain: "", logo: "ic_service_Ria", color: nil, backgroundColor: nil)
//                self.services.append(ria)
                self.tableView.reloadData()
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let service = self.services[indexPath.row]
        
        let cell: ServiceProviderCell = tableView.dequeueReusableCell(withIdentifier: "ServiceProviderCell", for: indexPath as IndexPath) as! ServiceProviderCell
        
        cell.lblService.text = service.name ?? ""
        
        let url = URL(string: "\(Constants.IMAGE_URL)\(service.logo ?? "")")
        cell.ivService.kf.setImage(with: url, placeholder: UIImage(named: "service_placeholder"))
        
        if (self.isArabic()) {
            cell.ivIndicator.image = UIImage(named: "ic_service_indicator_ar")
            cell.lblService.textAlignment = .right
        }else {
            cell.ivIndicator.image = UIImage(named: "ic_service_indicator")
            cell.lblService.textAlignment = .left

        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = self.services[indexPath.row]
        //check if service is available
        if (service.isAvailableSend ?? false == false) {
            self.showBanner(title: "alert".localized, message: "service_send_unavailable".localized, style: UIColor.INFO)
            return
        }
        switch service.code ?? "" {
        case Constants.SERVICE_PROVIDERS.money_gram: //moneygram
            self.showArabicContentAlert {
                self.checkMGReward(service: service)
            }
            break
            
        case Constants.SERVICE_PROVIDERS.afs: //afs
            self.showArabicContentAlert {
                App.shared.sendMoneyAFS = SendMoneyAFSModel()
                App.shared.sendMoneyAFS?.serviceProviderId = service.servicesProviderID ?? ""
                self.pushVC(name: "afs_RemittanceInfoVC", sb: Constants.STORYBOARDS.afs)
            }
            
        case Constants.SERVICE_PROVIDERS.ria: // Ria
            self.showArabicContentAlert { [weak self] in
                guard let self = self else {return}
//                self.pushVC(name: "Ria_ServiceOptionVC", sb: Constants.STORYBOARDS.Ria)
            }
            break
        default:
            //not supported
            break
        }
    }
    
    func checkMGReward(service: ServiceDatum) {
        self.showLoading()
        self.getApiManager().checkMGReward(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            if (response.data?.count ?? 0 > 0) {
                App.shared.sendMoneyMG = SendMoneyMGModel()
                App.shared.sendMoneyMG?.serviceProviderId = service.servicesProviderID ?? ""
                self.pushVC(name: "mg_RemittanceInfoVC", sb: Constants.STORYBOARDS.money_gram)
            }else {
                //show reward alert
                var message = App.shared.config?.moneyGramSettings?.rewardsAlertEn ?? ""
                if (self.isArabic()) {
                    message = App.shared.config?.moneyGramSettings?.rewardsAlertAr ?? ""
                }
                self.showAlert(title: "money_gram".localized, message: message, actionTitle: "yes".localized, cancelTitle: "no".localized, actionHandler: {
                    //open reward screen (step zero)
                    App.shared.sendMoneyMG = SendMoneyMGModel()
                    App.shared.sendMoneyMG?.serviceProviderId = service.servicesProviderID ?? ""
                    self.pushVC(name: "mg_AddRewardVC", sb: Constants.STORYBOARDS.money_gram)
                }) {
                    //go to step 1
                    App.shared.sendMoneyMG = SendMoneyMGModel()
                    App.shared.sendMoneyMG?.serviceProviderId = service.servicesProviderID ?? ""
                    self.pushVC(name: "mg_RemittanceInfoVC", sb: Constants.STORYBOARDS.money_gram)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
