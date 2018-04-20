import UIKit
class GameViewController: UIViewController {
  
  var timer:Timer?
  var snake = Snake(length: 5)
  var board = Board()
  
  func testMove(times: Int = 20) {
    for _ in 0..<times {
      snake.makeMove()
      board.updateScene(snake: snake)
      board.printScene()
      print("----")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipe()
    board.updateScene(snake: snake)
    board.printScene()
    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerMethod(_:)), userInfo: nil, repeats: true)
  }
  
  @objc func timerMethod(_ timer:Timer) {
    snake.makeMove()
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
      print("gora")
    case UISwipeGestureRecognizerDirection.down:
      snake.direction = Direction.south
      print("dol")
    case UISwipeGestureRecognizerDirection.left:
      snake.direction = Direction.west
      print("left")
    case UISwipeGestureRecognizerDirection.right:
      snake.direction = Direction.east
      print("right")
    default:
      assert(false, "Cannot handle direction.")
    }
  }
}
