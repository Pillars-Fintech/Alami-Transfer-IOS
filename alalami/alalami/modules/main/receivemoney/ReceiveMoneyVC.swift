//
//  ReceiveMoneyVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class ReceiveMoneyVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
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
        if (service.isAvailableReceived ?? false == false) {
            self.showBanner(title: "alert".localized, message: "service_receive_unavailable".localized, style: UIColor.INFO)
            return
        }
        
        self.showArabicContentAlert {
            App.shared.receiveMoney = ReceiveMoneyModel()
            App.shared.receiveMoney?.serviceProviderId = service.servicesProviderID ?? ""
            self.pushVC(name: "step1_ReceiveRequestVC", sb: Constants.STORYBOARDS.receive_money)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
