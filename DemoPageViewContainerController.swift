import UIKit

class DemoPageViewContainerController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var demoPageViewMainController: DemoPageViewMainController?
    
    var viewControllerList: [UIViewController] = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        viewControllerList.append(UIStoryboard(name: "Demo", bundle: nil).instantiateViewController(withIdentifier: "demoPageViewContent1Controller"))
        
        viewControllerList.append(UIStoryboard(name: "Demo", bundle: nil).instantiateViewController(withIdentifier: "demoPageViewContent2Controller"))
        
        viewControllerList.append(UIStoryboard(name: "Demo", bundle: nil).instantiateViewController(withIdentifier: "demoPageViewContent3Controller"))
        
        demoPageViewMainController?.pageControl.numberOfPages = viewControllerList.count
        
        if let firstViewController = viewControllerList.first {
            setViewControllers([firstViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.viewControllerList.firstIndex(of: viewController)
        if (currentIndex != nil) {
            let previousIndex = currentIndex! - 1
            if (previousIndex >= 0) {
                return self.viewControllerList[previousIndex]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.viewControllerList.firstIndex(of: viewController)
        if (currentIndex != nil) {
            let nextIndex = currentIndex! + 1
            if (nextIndex < self.viewControllerList.count) {
                return self.viewControllerList[nextIndex]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first {
            let currentIndex = self.viewControllerList.firstIndex(of: currentViewController)
            if let index = currentIndex, let pageControl = demoPageViewMainController?.pageControl {
                // 取得當前頁數的 currentIndex
                pageControl.currentPage = index
            }
        }
        
    }

}
