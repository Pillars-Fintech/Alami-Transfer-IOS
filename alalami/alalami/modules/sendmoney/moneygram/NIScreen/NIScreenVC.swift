//
//  NIScreenVC.swift
//  alalami
//
//  Created by Pillars Fintech on 02/02/2022.
//  Copyright © 2022 technzone. All rights reserved.
//

import UIKit
import WebKit


class NIScreenVC: BaseVC  {
    

    @IBOutlet weak var btnBack: UIButton!
    
    var details = [MGSentDatum]()

    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    var links:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
       print("links:\(links)")

        
        guard let url = URL(string: "\(links ?? "https://www.google.com")") else { return }
        


        webView.navigationDelegate = self
        
        let contentSize:CGSize = webView.scrollView.contentSize
        let viewSize:CGSize = self.view.bounds.size

        let rw:Float = Float(viewSize.width / contentSize.width)

        webView.scrollView.minimumZoomScale = CGFloat(rw)
        webView.scrollView.maximumZoomScale = CGFloat(rw)
        webView.scrollView.zoomScale = CGFloat(rw)

        
        
        webView.load(URLRequest(url: url))
//        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        view.addSubview(webView)
        
        
    }
        
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        webView.load(URLRequest(url: URL(string: "\(links ?? "https://www.google.com")")!))
//        if let text = webView.request?.url?.absoluteString{
//             print(text)
//        }
//    }
//
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        if let text = webView.request?.url?.absoluteString{
//            print("-------------------------------------")
//            print("-------------------------------------")
//            print("-------------------------------------")
//            print("-------------------------------------")
//
//             print("text\(text)")
//        }
//    }
    
    
    private func confirmApi() {
//        self.fillData()
        self.showLoading()
        self.getApiManager().sendMoneyMG(token: self.getAccessToken(), sendModel: App.shared.sendMoneyMG) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.openCompletedScreen(details: response.data ?? [MGSentDatum]())
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
                
//                if(response.message != nil){
//
//                    self.handleError(code : response.code ?? "", message : ["somethig wrong"])
//
//
//                }else{
//                    self.handleError(code : response.code ?? "", message : response.message)
//
//                    print("error")
//                }
        
            }
        }
    }
    
    
    
    func openCompletedScreen(details : [MGSentDatum]) {
        let vc : mg_CompletedVC = self.getStoryBoard(name: Constants.STORYBOARDS.money_gram).instantiateViewController(withIdentifier: "mg_CompletedVC") as! mg_CompletedVC
        vc.details = details
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
@IBAction func back(_ sender: Any) {
        
    self.showAlertDaynamic(title: "alert".localized, message: "confirm_go_home".localized, actionTitle: "ok".localized, cancelTitle: "cancel".localized, actionHandler: {
            self.goHome()
        }, cancelHandler: {
            
        })
        
//        self.navigationController?.popViewController(animated: true)
 }
    
@IBAction func homeAction(_ sender: Any) {
        goHomeWithConfirmation()

}
 
@IBAction func screanShootAction(_ sender: Any) {
        let _ = self.takeScreenshot()

    }
    

}


extension NIScreenVC: WKNavigationDelegate {
    internal func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        if let url = webView.url?.absoluteString{
            print("url didFinish= \(url)")
        }
        
        debugPrint("didCommit")
    }

    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        if let url = webView.url?.absoluteString{
            print("url didFail= \(url)")
            
          var home = url
            
            
            if home.contains(find: "CheckoutSessionModels/CancelPage"){
                

                self.showAlertDaynamic(title: "alert".localized, message: "confirm_go_home".localized, actionTitle: "ok".localized, cancelTitle: "cancel".localized, actionHandler: {
                    self.goHome()
                }, cancelHandler: {
                    
                })
//                self.presentNav(name: "TabBarNav", sb: Constants.STORYBOARDS.main)
            }
            
            if home.contains(find: "CheckoutSessionModels/HostedCheckoutReceipt"){
                confirmApi()
            }
     }
            
        debugPrint("didFinish")
    }

    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("didFail")
        
         
        
}
    
    
func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("www.google.com"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
}
    
    
    
}
