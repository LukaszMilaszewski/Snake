import UIKit
class GameViewController: UIViewController {
  
  var timer:Timer?
  var snake = Snake(length: 5)
  var board = Board()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipe()
    board.updateScene(snake: snake)
    board.printScene()
    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerMethod(_:)), userInfo: nil, repeats: true)
  }
  
  func showAlert() {
    print("------")
    print("GAME OVER!")
    print("------")
  }
  
  @objc func timerMethod(_ timer:Timer) {
    snake.makeMove()
    
    if board.checkColision(snake: snake) {
      showAlert()
      timer.invalidate()
      return
    }
    
    board.updateScene(snake: snake)
    board.printScene()
  }
  
  func addSwipe() {
    let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
    for direction in directions {
      let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
      gesture.direction = direction
      self.view.addGestureRecognizer(gesture)
    }
  }

  @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
    switch sender.direction {
    case UISwipeGestureRecognizerDirection.up:
      snake.direction = Direction.north
    case UISwipeGestureRecognizerDirection.down:
      snake.direction = Direction.south
    case UISwipeGestureRecognizerDirection.left:
      snake.direction = Direction.west
    case UISwipeGestureRecognizerDirection.right:
      snake.direction = Direction.east
    default:
      assert(false, "Cannot handle direction.")
    }
  }
}
