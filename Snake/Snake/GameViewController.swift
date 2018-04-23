import UIKit

class GameViewController: UIViewController, GameHandlerDelegate, GameViewModelDelegate {
  
  var gameHandler: GameHandler?
  var gameViewModel: GameViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipe()
    setupView()
    startGame()
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
      gameHandler!.setSnakeDirection(direction: Direction.up)
    case UISwipeGestureRecognizerDirection.down:
      gameHandler!.setSnakeDirection(direction: Direction.down)
    case UISwipeGestureRecognizerDirection.left:
      gameHandler!.setSnakeDirection(direction: Direction.left)
    case UISwipeGestureRecognizerDirection.right:
      gameHandler!.setSnakeDirection(direction: Direction.right)
    default:
      assert(false, "Cannot handle direction.")
    }
  }
  
  func setupView() {
    view.backgroundColor = UIColor.gray
    gameViewModel = GameViewModel(view: self.view,
                                  color: Constants.backgroundColor)
    gameViewModel?.delegate = self
  }
  
  func startGame() {
    let width = Int(Int(view.bounds.width) / Constants.squareDimension)
    let height = Int(Int(view.bounds.height) / Constants.squareDimension)
    
    gameHandler = GameHandler(boardWidth: width,
                              boardHeight: height,
                              snakeLength: Constants.snakeLength)
    
    gameHandler!.delegate = self
    gameHandler!.startGame()
  }
  
  //MARK: - GameHandlerDelegate
  func collision() {
    gameViewModel?.showAlert()
  }
  
  func updateBoard(board: Board) {
    gameViewModel?.showView(board: board)
  }
  
  //MARK: - GameViewModelDelegate
  func restartButtonPressed() {
    self.viewDidLoad()
  }

  func presentAlert(alert: UIAlertController) {
    self.present(alert, animated: true)
  }
}

extension GameViewController {
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
