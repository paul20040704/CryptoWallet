import UIKit

class DemoPageViewMainController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    var demoPageViewContainerController: DemoPageViewContainerController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DemoPageViewContainerController {
            demoPageViewContainerController = vc
            demoPageViewContainerController?.demoPageViewMainController = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
