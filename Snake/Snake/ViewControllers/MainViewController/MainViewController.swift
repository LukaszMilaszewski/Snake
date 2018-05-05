import UIKit

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBOutlet var gridSwitch: UISwitch!
  @IBOutlet var speedSwitch: UISwitch!
  @IBOutlet var wallsSwitch: UISwitch!
  @IBOutlet var obstaclesSwitch: UISwitch!
  
  @IBAction func startGame() {
    let gameOptions = GameOptions(passWalls: wallsSwitch.isOn, increaseSpeed: speedSwitch.isOn,
                                  grid: gridSwitch.isOn, obstacles: obstaclesSwitch.isOn)
    let gameViewController = GameViewController()
    gameViewController.gameOptions = gameOptions
    present(gameViewController, animated: true, completion: nil)
  }
}

extension MainViewController {
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
