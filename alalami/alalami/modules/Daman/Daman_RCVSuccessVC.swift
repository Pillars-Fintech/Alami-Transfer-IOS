//
//  Daman_RCVSuccessVC.swift
//  alalami
//
//  Created by Pillars Fintech on 08/05/2022.
//  Copyright © 2022 technzone. All rights reserved.
//

import UIKit


import UIKit

class Daman_RCVSuccessVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ivSuccess: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var details = [RCVSentDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            self.ivSuccess.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 2.0, animations: {() -> Void in
                self.ivSuccess.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let detail = self.details[indexPath.row]
        
        let cell: MGSentDetailCell = tableView.dequeueReusableCell(withIdentifier: "MGSentDetailCell", for: indexPath as IndexPath) as! MGSentDetailCell
        
        cell.lblTitle.text = detail.caption ?? ""
        cell.lblValue.text = detail.value ?? ""
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.goHome()
    }
    
    @IBAction func homeAction(_ sender: Any) {
        self.goHome()
    }
    
    @IBAction func screenshotAction(_ sender: Any) {
        let _ = self.takeScreenshot()
    }
    
    
    //
}
