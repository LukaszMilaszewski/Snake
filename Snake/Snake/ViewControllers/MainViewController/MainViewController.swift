import UIKit

class MainViewController: UIViewController {
  
  var isGrid = false
  
  override func viewDidLoad() {
    addLabel(name: "SNAKE", fontName: "AmericanTypewriter-CondensedBold",
             size: CGFloat(50), x: view.center.x, y: CGFloat(50), width: 200, height: 50,
             alignment: .center)
    
    addLabel(name: "GRID:", fontName: "ArialMT",
             size: CGFloat(25), x: 150, y: CGFloat(170), width: 70, height: 50,
             alignment: .center)
    
    addSwitch(x: view.frame.maxX - 150, y: 170)
    
    view.backgroundColor = UIColor.white
    addButton()
    addSlider()
  }
  
  func addSlider() {
    let mySlider = UISlider(frame:CGRect(x: 100, y: 300, width: 200, height: 20))
    mySlider.center.x = view.center.x
    mySlider.center.y = CGFloat(300)
    mySlider.minimumValue = 0
    mySlider.maximumValue = 3
    mySlider.isContinuous = false
    
    mySlider.tintColor = UIColor.green
    view.addSubview(mySlider)
  }
  
  func addLabel(name: String, fontName: String, size: CGFloat, x: CGFloat, y: CGFloat, width: Int, height: Int, alignment: NSTextAlignment) {
    let label = UILabel()
    label.text = name
    label.textAlignment = alignment
    label.font = UIFont(name: fontName, size: size)
    label.frame = CGRect(x: 0, y: 0, width: width, height: height)
    label.center.x = x
    label.center.y = y
    self.view.addSubview(label)
  }
  
  func addSwitch(x: CGFloat, y: CGFloat) {
    let sw = UISwitch();
    sw.frame = CGRect(x: 0, y: 0, width: sw.frame.width, height: sw.frame.height)
    sw.center.x = x
    sw.center.y = y
    sw.isOn = false
    sw.addTarget(self, action: #selector(actionn(sender:)), for: .touchUpInside)
    self.view.addSubview(sw)
  }
  
  @objc fileprivate func actionn(sender: UISwitch) {
    if sender.isOn {
      isGrid = true
    } else {
      isGrid = false
    }
  }
  
  
  func addButton () {
    let button = UIButton();
    button.setTitle("START GAME", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
    button.center.x = view.center.x
    button.center.y = view.frame.maxY - 150
    button.titleLabel?.font =  UIFont(name: "ArialMT", size: 30)

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

