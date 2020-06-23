//
//  SwipingPhotosController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/04/17.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController {

    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.filter{$0 != ""}.map({
                return PhotoController(imageUrl: $0)
            })
            
            if let firstController = controllers.first {
                setViewControllers([firstController], direction: .forward, animated: true)
            } else {
                setViewControllers([PhotoController(image: #imageLiteral(resourceName: "top_left_profile"))], direction: .forward, animated: true)
            }
            
            configureBarViews()
        }
    }
    
    var controllers = [UIViewController]()
    
    let barStackView = UIStackView(arrangedSubviews: [])
    let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
    }
    
    private func configureBarViews() {
        cardViewModel.imageUrls.filter{$0 != ""}.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = barDeselectedColor
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        barStackView.arrangedSubviews.first?.backgroundColor = .white

        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        view.addSubview(barStackView)
        barStackView.layout.top(equalTo: view.topAnchor, constant: statusBarHeight + 8)
                            .leading(equalTo: view.leadingAnchor, constant: 8)
                            .trailing(equalTo: view.trailingAnchor, constant: -8)
                            .height(equalToconstant: 4)
    }

}

extension SwipingPhotosController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard self.controllers.count > 1 else { return nil }
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0 // viewController는 현재 보여지는 viewController
        if index == 0 { return controllers.last! } // show last image
//        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard self.controllers.count > 1 else { return nil }
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return controllers.first! } // show first image
//        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    
}

extension SwipingPhotosController: UIPageViewControllerDelegate {
    // called after Swiping
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = viewControllers?.first // Swiping 되고 나서 현재 보여지는 ViewController
        if let index = controllers.firstIndex(where: {$0 == currentViewController}) {
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = barDeselectedColor})
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}

class PhotoController: UIViewController {
    
    let imageView = UIImageView()
    
    init(imageUrl: String){
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        } else {
            imageView.image = #imageLiteral(resourceName: "top_left_profile")
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.layout.fillSuperView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
}
