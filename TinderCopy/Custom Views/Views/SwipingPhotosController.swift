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
            print(cardViewModel.attributedString)
            controllers = cardViewModel.imageUrls.map({
                return PhotoController(imageUrl: $0)
            })
        }
    }
    
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        
        if let firstController = controllers.first {
            setViewControllers([firstController], direction: .forward, animated: true)
        } else {
            setViewControllers([PhotoController(image: #imageLiteral(resourceName: "top_left_profile"))], direction: .forward, animated: true)
        }
        
    }

}

extension SwipingPhotosController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
//        if index == 0 { return controllers.last! }
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
//        if index == controllers.count - 1 { return controllers.first! }
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
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
        imageView.layout.top(equalTo: view.topAnchor).leading().trailing().bottom(equalTo: view.bottomAnchor)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
}
