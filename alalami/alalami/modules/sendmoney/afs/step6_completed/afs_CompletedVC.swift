//
//  afs_CompletedVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/16/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class afs_CompletedVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ivSuccess: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var details = [AfsSentDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
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
    
    @IBAction func closeAction(_ sender: Any) {
        self.goHome()
    }
    
    @IBAction func homeAction(_ sender: Any) {
        self.goHome()
    }
    
    @IBAction func screenshotAction(_ sender: Any) {
        let _ = self.takeScreenshot()
    }
    
}
