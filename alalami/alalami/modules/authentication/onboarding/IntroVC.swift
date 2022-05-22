//
//  IntroVC.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class IntroVC: BaseVC {
    
    @IBOutlet weak var cvNext: CardView!
    @IBOutlet weak var btnNext: MyUIButton!
    @IBOutlet weak var btnSkip: MyUIButton!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [IntroItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.collectionView.collectionViewLayout = ArabicCollectionFlow()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        pageControl.hidesForSinglePage = true
        
        var item = IntroItem()
        item.imageName = "bg_intro1"
        item.title = "intro1_title".localized
        item.desc = "intro1_desc".localized
        self.items.append(item)
        
        item = IntroItem()
        item.imageName = "bg_intro2"
        item.title = "intro2_title".localized
        item.desc = "intro2_desc".localized
        self.items.append(item)
        
        item = IntroItem()
        item.imageName = "bg_intro3"
        item.title = "intro3_title".localized
        item.desc = "intro3_desc".localized
        self.items.append(item)
        
        
        let configIntro = App.shared.config?.introStrings ?? [IntroString]()
        if (configIntro.count >= 3) {
            if (self.isArabic()) {
                self.items[0].title = configIntro[0].masterWelcomeSliderTitleAr ?? ""
                self.items[0].desc = configIntro[0].masterWelcomeSliderDescriptionAr ?? ""
                
                self.items[1].title = configIntro[1].masterWelcomeSliderTitleAr ?? ""
                self.items[1].desc = configIntro[1].masterWelcomeSliderDescriptionAr ?? ""
                
                self.items[2].title = configIntro[2].masterWelcomeSliderTitleAr ?? ""
                self.items[2].desc = configIntro[2].masterWelcomeSliderDescriptionAr ?? ""
            }else {
                self.items[0].title = configIntro[0].masterWelcomeSliderTitle ?? ""
                self.items[0].desc = configIntro[0].masterWelcomeSliderDescription ?? ""
                
                self.items[1].title = configIntro[1].masterWelcomeSliderTitle ?? ""
                self.items[1].desc = configIntro[1].masterWelcomeSliderDescription ?? ""
                
                self.items[2].title = configIntro[2].masterWelcomeSliderTitle ?? ""
                self.items[2].desc = configIntro[2].masterWelcomeSliderDescription ?? ""
            }
        }
        
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func doneAction() {
        let defaults = UserDefaults.standard
        defaults.setValue(true, forKey: Constants.DEFAULT_KEYS.DID_SEE_INTRO)
        let didSeeStarted = defaults.value(forKey: Constants.DEFAULT_KEYS.DID_SEE_STARTED) as? Bool ?? false
        if (didSeeStarted) {
            self.presentVC(name: "LoginNav", sb: Constants.STORYBOARDS.authentication)
        }else {
            self.presentVC(name: "StarterScreenNav", sb: Constants.STORYBOARDS.authentication)
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if (self.pageControl.currentPage == 0) {
            let indexPath = IndexPath(item: 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            self.pageControl.currentPage = 1
            self.validateCurrentPage()
        }else if (self.pageControl.currentPage == 1) {
            let indexPath = IndexPath(item: 2, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            self.pageControl.currentPage = 2
            self.validateCurrentPage()
        }else {
            //done actions
            self.doneAction()
        }
    }
    
    @IBAction func skipAction(_ sender: Any) {
        //done actions
        self.doneAction()
    }
    
    
    func validateCurrentPage() {
        if (self.pageControl.currentPage == 0) {
            self.btnNext.setTitle("next".localized, for: .normal)
            self.btnNext.setTitleColor(UIColor.enabled_text, for: .normal)
            self.cvNext.backgroundColor = UIColor.enabled
        }else if (self.pageControl.currentPage == 1) {
            self.btnNext.setTitle("next".localized, for: .normal)
            self.btnNext.setTitleColor(UIColor.enabled_text, for: .normal)
            self.cvNext.backgroundColor = UIColor.enabled
        }else {
            self.btnNext.setTitle("lets_get_started".localized, for: .normal)
            self.btnNext.setTitleColor(UIColor.enabled_text, for: .normal)
            self.cvNext.backgroundColor = UIColor.enabled
        }
    }
}

extension IntroVC : UICollectionViewDelegate , UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : IntroCell = self.collectionView.dequeueReusableCell(withReuseIdentifier:"IntroCell", for: indexPath) as! IntroCell
        
        let item = self.items[indexPath.row]
        cell.ivLogo.image = UIImage(named: item.imageName ?? "")
        cell.lblText.text = item.title ?? ""
        cell.lblDesc.text = item.desc ?? ""
        
        if (isSmallDevice()) {
            cell.lblText.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.bold), size: CGFloat(Constants.ONBOARDING_TEXT_SIZE.SMALL_TITLE))
            cell.lblDesc.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.regular), size: CGFloat(Constants.ONBOARDING_TEXT_SIZE.SMALL_BODY))
        }else {
            cell.lblText.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.bold), size: CGFloat(Constants.ONBOARDING_TEXT_SIZE.NORMAL_TITLE))
            cell.lblDesc.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.regular), size: CGFloat(Constants.ONBOARDING_TEXT_SIZE.NORMAL_BODY))
        }
        
        return cell
        
    }
    
    private func isSmallDevice() -> Bool {
        let deviceName = UIDevice.modelName
        if (deviceName == "iPhone 4" || deviceName == "iPhone 4s" || deviceName == "iPhone 5" || deviceName == "iPhone 5c" || deviceName == "iPhone 5s" || deviceName == "iPhone SE") {
            return true
        }else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // self.pageControl.currentPage = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height:self.collectionView.bounds.height)
        
    }
}

extension IntroVC : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.validateCurrentPage()
    }
}
