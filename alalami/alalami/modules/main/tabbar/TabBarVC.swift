//
//  TabBarVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomAppBar

class TabBarVC: BaseVC {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomBar: MDCBottomAppBarView!
    
    var btnSettings : UIBarButtonItem?
    var btnBranches : UIBarButtonItem?
    var btnWhatsApp : UIBarButtonItem?
    var btnBeneficiary : UIBarButtonItem?
    
    //view controllers
    var settingsVC: UINavigationController!
    var branchesVC: UINavigationController!
    var homeVC: UINavigationController!
    var beneficiariesVC : UINavigationController!
    
    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorScheme = MDCSemanticColorScheme()
        let typgoraphyScheme = MDCTypographyScheme()
        let buttonScheme = MDCContainerScheme()
        buttonScheme.colorScheme = colorScheme
        buttonScheme.typographyScheme = typgoraphyScheme
        
        bottomBar.floatingButton.mode = .expanded
        bottomBar.floatingButton.setTitle("home_btn".localized, for: .normal)
        bottomBar.floatingButton.setTitleFont(UIFont(name: getFontName(type: Constants.FONT_TYPE.regular), size: 14), for: .normal)
        
        //settings
        btnSettings = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(settingsAction(sender:)))
        btnSettings?.width = 70.0
        btnSettings?.accessibilityLabel = "settings".localized
        btnSettings?.image = UIImage(named: "ic_nav1")
        
        //branches
        btnBranches = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(branchesAction(sender:)))
        btnBranches?.width = 70.0
        btnBranches?.accessibilityLabel = "branches".localized
        btnBranches?.image = UIImage(named: "ic_nav2")
        
        //add leading buttons
        bottomBar.leadingBarButtonItems = [ btnSettings, btnBranches ] as? [UIBarButtonItem]
        
        //whatsapp
        btnWhatsApp = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(whatsappAction(sender:)))
        btnWhatsApp?.width = 70.0
        btnWhatsApp?.accessibilityLabel = "whatsapp".localized
        btnWhatsApp?.image = UIImage(named: "ic_nav3")
        
        //add beneficiary
        btnBeneficiary = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(beneficiaryAction(sender:)))
        btnBeneficiary?.width = 70.0
        btnBeneficiary?.accessibilityLabel = "add_beneficiary".localized
        btnBeneficiary?.image = UIImage(named: "ic_nav4")
        
        //add trailing buttons
        bottomBar.trailingBarButtonItems = [ btnBeneficiary , btnWhatsApp ] as? [UIBarButtonItem]
        
        let addImage = UIImage(named:"ic_fab_logo")?.withRenderingMode(.alwaysOriginal)
        bottomBar.floatingButton.setImage(addImage, for: .normal)
        bottomBar.floatingButton.setBackgroundColor(UIColor.app_red)
        bottomBar.floatingButton.setImageTintColor(UIColor.white, for: .normal)
        bottomBar.floatingButton.setTitleColor(UIColor.white, for: .normal)
        bottomBar.floatingButton.tintColor = UIColor.white
        
        
        bottomBar.floatingButton.addTarget(self,
                                           action: #selector(didTapFloatingButton(_:)),
                                           for: .touchUpInside)
        
        let storyboard = UIStoryboard(name: Constants.STORYBOARDS.main, bundle: nil)
        settingsVC = storyboard.instantiateViewController(withIdentifier: "MoreNav") as? UINavigationController
        branchesVC = storyboard.instantiateViewController(withIdentifier: "BranchesNav") as? UINavigationController
        homeVC = storyboard.instantiateViewController(withIdentifier: "DashboardNav") as? UINavigationController
        beneficiariesVC = storyboard.instantiateViewController(withIdentifier: "MyBeneficiariesNav") as? UINavigationController
        
        viewControllers = [settingsVC, branchesVC, homeVC, beneficiariesVC]
        
        self.selectHome()
        
    }
    
    @objc func didTapFloatingButton(_ sender : MDCFloatingButton) {
        selectHome()
    }
    
    @objc func settingsAction(sender: UIBarButtonItem) ->() {
        self.selectSettings()
    }
    
    @objc func branchesAction(sender: UIBarButtonItem) ->() {
        self.selectBranches()
    }
    
    @objc func whatsappAction(sender: UIBarButtonItem) ->() {
        self.openWhatsApp(phone: App.shared.config?.company?.whatsapp ?? "")
    }
    
    @objc func beneficiaryAction(sender: UIBarButtonItem) ->() {
        selectBeneficiaries()
    }
    
    private func expandFloating(expand : Bool) {
        if (expand) {
            self.bottomBar.floatingButton.setMode(.expanded, animated: true)
            self.bottomBar.floatingButton.setTitle("home_btn".localized, for: .normal)
        }else {
            self.bottomBar.floatingButton.setMode(.normal, animated: true)
            self.bottomBar.floatingButton.setTitle("", for: .normal)
        }
    }
    
    func selectSettings() {
        expandFloating(expand: false)
        self.btnSettings?.image = UIImage(named: "ic_nav1_selected")
        self.btnBranches?.image = UIImage(named: "ic_nav2")
        self.btnBeneficiary?.image = UIImage(named: "ic_nav4")
        
        selectedIndex = 0
        self.showViewController()
    }
    
    func selectBranches() {
        expandFloating(expand: false)
        self.btnSettings?.image = UIImage(named: "ic_nav1")
        self.btnBranches?.image = UIImage(named: "ic_nav2_selected")
        self.btnBeneficiary?.image = UIImage(named: "ic_nav4")
        
        selectedIndex = 1
        self.showViewController()
    }
    
    private func getVisibleViewController() -> UIViewController? {
            return self.navigationController?.visibleViewController!.topMostViewController()
    }
    func selectHome() {
        expandFloating(expand: true)
        self.btnSettings?.image = UIImage(named: "ic_nav1")
        self.btnBranches?.image = UIImage(named: "ic_nav2")
        self.btnBeneficiary?.image = UIImage(named: "ic_nav4")
        
        selectedIndex = 2
        self.homeVC.popViewController(animated: true)
        self.showViewController()
    }
    
    func selectBeneficiaries() {
        expandFloating(expand: false)
        self.btnSettings?.image = UIImage(named: "ic_nav1")
        self.btnBranches?.image = UIImage(named: "ic_nav2")
        self.btnBeneficiary?.image = UIImage(named: "ic_nav4_selected")
        
        selectedIndex = 3
        self.showViewController()
    }
    
    func showViewController() {
        let previousIndex = selectedIndex
        let previousVC = viewControllers[previousIndex]
        //show home
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
}
