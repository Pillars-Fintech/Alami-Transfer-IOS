//
//  PayOutServiceOptionCell.swift
//  alalami
//
//  Created by Zaid Khaled on 9/8/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class PayOutServiceOptionCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bgContainer: CardView!
    @IBOutlet weak var bgColor: CardView!
    @IBOutlet weak var ivChecked: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var items = [ResponseList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setup(items : [ResponseList]) {
        self.items.removeAll()
        self.items.append(contentsOf: items)
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PayoutInnerCell = self.tableView.dequeueReusableCell(withIdentifier: "PayoutInnerCell") as! PayoutInnerCell
        
        let item = self.items[indexPath.row]
        
        if let iconUrl = URL(string: "\(Constants.IMAGE_URL)\(item.icon ?? "")") {
            cell.ivLogo.isHidden = false
            cell.ivLogo.kf.setImage(with: iconUrl)
        }else {
            cell.ivLogo.isHidden = true
        }
        
        cell.lblTitle.text = item.caption ?? ""
        cell.lblValue.text = item.value ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
}
