
import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    private lazy var controllers: [OnboardingViewController] = {
       let firstVC = OnboardingViewController()
        firstVC.onboardingLabel.text = "Отслеживайте только то, что хотите"
        firstVC.backgroundImageView.image = UIImage(named: "onboardingBlue")
        firstVC.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let secondVC = OnboardingViewController()
        secondVC.onboardingLabel.text = "Даже если это\nне литры воды и йога"
        secondVC.backgroundImageView.image = UIImage(named: "onboardingRed")
        secondVC.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return [firstVC, secondVC]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = controllers.count
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .black.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
       return pageControl
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        dataSource = self
        delegate = self
        
        if let first = controllers.first {setViewControllers([first], direction: .forward, animated: true, completion: nil)}
    }
    
    private func setUpView() {
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -155),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
// MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.firstIndex(of: viewController as! OnboardingViewController) else {
            return nil
        }
        
        let previouseIndex = viewControllerIndex - 1
        
        guard previouseIndex >= 0 else {return nil}
        
        return controllers[previouseIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.firstIndex(of: viewController as! OnboardingViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < controllers.count else {return nil}
        
        return controllers[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = controllers.firstIndex(of: currentVC as! OnboardingViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
