//
//  MailsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class MailsVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var mails = [MailDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMails()
    }
    
    func loadMails() {
        self.showLoading()
        self.getApiManager().getMails(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            
            if response.success == false {
                self.handleError(code: response.code, message: response.message ?? ["Something Wrong"])

            }else{
                self.mails.removeAll()
                self.mails.append(contentsOf: response.data ?? [MailDatum]())
                self.tableView.reloadData()

            }
            

        }
    }
    
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mail = self.mails[indexPath.row]
        
        let cell: MailCell = tableView.dequeueReusableCell(withIdentifier: "MailCell", for: indexPath as IndexPath) as! MailCell
        
        cell.lblSubject.text = mail.emailSubject ?? ""
        cell.lblDate.text = self.getStringDateWithFormat(dateStr: mail.sendDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy_hh_mm_a)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : MailDetailsVC = self.getStoryBoard(name: Constants.STORYBOARDS.more).instantiateViewController(withIdentifier: "MailDetailsVC") as! MailDetailsVC
        vc.mail = self.mails[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
