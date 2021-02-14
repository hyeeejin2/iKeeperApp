//
//  InformationDetailImageViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/14.
//

import UIKit

class InformationDetailImageViewController: UIViewController {

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        //페이지 컨트롤의 전체 페이지를 images 배열의 전체 개수 값으로 설정
        pageController.numberOfPages = images.count
        // 페이지 컨트롤의 현재 페이지를 0으로 설정
        pageController.currentPage = 0
        // 페이지 표시 색상을 밝은 회색으로 설정
        pageController.pageIndicatorTintColor = .lightGray
        // 현재 페이지 표시 색상을 검정색으로 설정
        pageController.currentPageIndicatorTintColor = .black
        image.image = images[0]
        pageLabel.text = "\(pageController.currentPage + 1)/\(pageController.numberOfPages)"
        
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        pageLabel.text = "\(pageController.currentPage + 1)/\(pageController.numberOfPages)"
        image.image = images[pageController.currentPage]
    }
    
    @IBAction func closeBarButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
