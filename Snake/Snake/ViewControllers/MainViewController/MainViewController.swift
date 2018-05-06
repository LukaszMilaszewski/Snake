import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var gridSwitch: UISwitch!
  @IBOutlet weak var speedSwitch: UISwitch!
  @IBOutlet weak var wallsSwitch: UISwitch!
  @IBOutlet weak var obstaclesSwitch: UISwitch!
  @IBOutlet weak var scoreLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    let defaults = UserDefaults.standard
    let bestScore = defaults.integer(forKey: "BestScore")
    updateScoreLabel(score: bestScore)
  }
  
  func updateScoreLabel(score: Int) {
    scoreLabel.text = "Best score: \(score)"
  }
  
  @IBAction func startGame() {
    let gameOptions = GameOptions(passWalls: wallsSwitch.isOn, increaseSpeed: speedSwitch.isOn,
                                  grid: gridSwitch.isOn, obstacles: obstaclesSwitch.isOn)
    let gameViewController = GameViewController()
    gameViewController.gameOptions = gameOptions
    present(gameViewController, animated: true, completion: nil)
  }
  
  @IBAction func resetScore() {
    let defaults = UserDefaults.standard
    defaults.set(0, forKey: "BestScore")
    updateScoreLabel(score: 0)
  }
}

extension MainViewController {
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
