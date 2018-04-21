import UIKit

class GameViewController: UIViewController, GameHandlerDelegate {
  
  var gameHandler: GameHandler?
  var squares: [[CAShapeLayer]]?
  var width: Int?
  var height: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipe()
    width = Int(Int(view.bounds.width) / Int(Constants.squareDimension))
    height = Int(Int(view.bounds.height) / Int(Constants.squareDimension))
    
    gameHandler = GameHandler(boardWidth: width!, boardHeight: height!,
                              snakeLength: Constants.snakeLength)
    
    squares = [[CAShapeLayer]](repeating: [CAShapeLayer](repeating: CAShapeLayer(), count: gameHandler!.board!.getWidth()), count: gameHandler!.board!.getHeight())
    
    gameHandler!.delegate = self
  }
  
  
  
  func showAlert() {
    print("------")
    print("GAME OVER!")
    print("------")
    let alert = UIAlertController(title: "GAME OVER!", message: "Game Over.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
              self.viewDidLoad()
            }))
            self.present(alert, animated: true)
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
      gameHandler!.setSnakeDirection(direction: Direction.north)
    case UISwipeGestureRecognizerDirection.down:
      gameHandler!.setSnakeDirection(direction: Direction.south)
    case UISwipeGestureRecognizerDirection.left:
      gameHandler!.setSnakeDirection(direction: Direction.west)
    case UISwipeGestureRecognizerDirection.right:
      gameHandler!.setSnakeDirection(direction: Direction.east)
    default:
      assert(false, "Cannot handle direction.")
    }
  }
  
  func collision() {
    showAlert()
  }
  
  func updatedBoard(board: Board) {
    board.printBoard()
    
    for i in 0..<board.getHeight() {
      for j in 0..<board.getWidth() {
        squares![i][j] = getLayer(x: j * Constants.squareDimension, y: i * Constants.squareDimension, value: board.getElement(x: i, y: j))
      }
    }
    view.layer.sublayers?.removeAll()
    for i in 0..<squares!.count {
      for j in 0..<squares![i].count {
        view.layer.addSublayer(squares![i][j])
      }
    }
  }
  
  func getLayer(x: Int, y: Int, value: Int) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let element = CGRect(x: x, y: y, width: Constants.squareDimension, height: Constants.squareDimension)
    layer.path = UIBezierPath(roundedRect: element, cornerRadius: 4).cgPath
    
    switch value {
    case 0:
      layer.fillColor = UIColor.gray.cgColor
    case 1:
      layer.fillColor = UIColor.black.cgColor
    case 5:
      layer.fillColor = UIColor.red.cgColor
    default:
      print("cannot happen")
    }
    
    return layer
  }
}
