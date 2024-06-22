//
//  MainTabBarController.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/6/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    @IBOutlet var tabbarIten: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let items = tabBar.items {
            items[0].image = UIImage(named: "location.circle.fill")?.resizeImage(to: CGSize(width: 30, height: 30))
            items[0].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -12, right: 0)

            items[1].image = UIImage(named: "trophy.circle.fill")?.resizeImage(to: CGSize(width: 50, height: 50))
            items[1].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -12, right: 0)

            items[2].image = UIImage(named: "storefront.circle.fill")?.resizeImage(to: CGSize(width: 50, height: 50))
            items[2].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -12, right: 0)

            items[3].image = UIImage(named: "person.circle.fill")?.resizeImage(to: CGSize(width: 50, height: 50))
            items[3].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -12, right: 0)

            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
        }
    }
}
