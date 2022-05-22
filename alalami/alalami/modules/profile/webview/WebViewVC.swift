//
//  WebViewVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/27/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: BaseVC {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var lblTitle: MyUILabel!
    
    var screenTitle : String?
    var url : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = screenTitle ?? ""
        
        if let link = URL(string:url ?? "") {
            let request = URLRequest(url: link)
            self.webView.load(request)
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
