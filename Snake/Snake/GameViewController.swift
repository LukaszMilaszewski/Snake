import UIKit

class GameViewController: UIViewController, GameHandlerDelegate {
  
  let gameHandler = GameHandler()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipe()
    gameHandler.delegate = self
  }
  
  func showAlert() {
    print("------")
    print("GAME OVER!")
    print("------")
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
      gameHandler.setSnakeDirection(direction: Direction.north)
    case UISwipeGestureRecognizerDirection.down:
      gameHandler.setSnakeDirection(direction: Direction.south)
    case UISwipeGestureRecognizerDirection.left:
      gameHandler.setSnakeDirection(direction: Direction.west)
    case UISwipeGestureRecognizerDirection.right:
      gameHandler.setSnakeDirection(direction: Direction.east)
    default:
      assert(false, "Cannot handle direction.")
    }
  }
  
  func collision() {
    showAlert()
  }
  
  func updatedBoard(board: Board) {
    board.printBoard()
  }
}
