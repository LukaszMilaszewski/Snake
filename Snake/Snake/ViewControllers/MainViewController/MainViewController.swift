import UIKit

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    
    addLabel(name: "SNAKE", fontName: "AmericanTypewriter-CondensedBold",
             size: CGFloat(50), x: view.center.x, y: CGFloat(50), width: 200, height: 50,
             alignment: .center)
    
    let defaults = UserDefaults.standard
    let bestScore = defaults.integer(forKey: "BestScore")
    
    addLabel(name: "Best Score: \(bestScore)", fontName: "AmericanTypewriter-CondensedBold",
             size: CGFloat(30), x: view.center.x, y: CGFloat(150), width: 200, height: 50,
             alignment: .center)
    
    
    addStartButton()
    view.backgroundColor = UIColor.white
  }
  
  func addLabel(name: String, fontName: String, size: CGFloat, x: CGFloat, y: CGFloat, width: Int, height: Int,
                alignment: NSTextAlignment) {
    let label = UILabel()
    label.text = name
    label.textAlignment = alignment
    label.font = UIFont(name: fontName, size: size)
    label.frame = CGRect(x: 0, y: 0, width: width, height: height)
    label.center.x = x
    label.center.y = y
    self.view.addSubview(label)
  }
  
  func addStartButton () {
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
