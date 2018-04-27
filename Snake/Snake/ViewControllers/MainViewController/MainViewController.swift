import UIKit

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
     createButton()
    view.backgroundColor = UIColor.white
  }
  
  func createButton () {
    let button = UIButton();
    button.setTitle("Start Game", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.frame = CGRect(x: 15, y: 50, width: 200, height: 100)
    button.center = view.center
    button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
    self.view.addSubview(button)
  }
  
  @objc fileprivate func action(sender: UIButton) {
    sender.showsTouchWhenHighlighted = true
    let gameViewController = GameViewController()
    present(gameViewController, animated: true, completion: nil)
  }
}

extension MainViewController {
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
