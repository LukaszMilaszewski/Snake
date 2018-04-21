import UIKit

class GameViewController: UIViewController {
  
  var timer:Timer?
  var snake = Snake()
  var board = Board()
  var apple: Apple?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipe()
    
    generateApple()
    board.updateBoard(snake: snake, apple: apple!)
    board.printBoard()
    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerMethod(_:)), userInfo: nil, repeats: true)
  }
  
  func generateApple() {
     apple = Apple(boardWidth: board.width, boardHeight: board.height)
  }
  
  func updateApple() {
    board.removeApple(apple: apple!)
    generateApple()
  }
  
  func showAlert() {
    print("------")
    print("GAME OVER!")
    print("------")
  }
  
  func isAppleGained() -> Bool {
    return snake.getHead() == apple ? true : false
  }
  
  @objc func timerMethod(_ timer:Timer) {
    snake.makeMove()
    
    if board.checkColision(snake: snake) {
      showAlert()
      timer.invalidate()
      return
    }
    
    if isAppleGained() {
      updateApple()
      snake.isAppleGained = true
    }
    
    board.updateBoard(snake: snake, apple: apple!)
    board.printBoard()
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
