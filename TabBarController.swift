
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTabBar()
    }
    
    private func prepareTabBar() {
        viewControllers = [
            prepareVC(viewController: TrackersViewController(), title: "Трекеры", image: UIImage(named: "CircleIcon")),
         prepareVC(viewController: StatisticsViewController(), title: "Статистика", image: UIImage(named: "RabbitIcon"))
    ]}
    
    private func prepareVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}
