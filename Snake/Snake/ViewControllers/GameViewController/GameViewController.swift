import UIKit

class GameViewController: UIViewController, GameDelegate, GameViewModelDelegate {
  
  var gameHandler: Game?
  var gameViewModel: GameViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipe()
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
  
  func startGame() {
    setup()
    run()
  }
  
  func setup() {
    let width = Int(Int(view.bounds.width) / Constants.squareDimension)
    let height = Int(Int(view.bounds.height) / Constants.squareDimension)
    
    gameHandler = Game(boardWidth: width,
                              boardHeight: height,
                              snakeLength: Constants.snakeLength
      )
    
    gameHandler!.delegate = self
    
    setupView(board: (gameHandler?.board)!, snake: (gameHandler?.snake)!, apple: (gameHandler?.apple)!)
  }
  
  func setupView(board: Board, snake: Snake, apple: Apple) {
    view.backgroundColor = UIColor.gray
    gameViewModel = GameViewModel(view: self.view,
                                  color: Constants.backgroundColor,
                                  board: board,
                                  snake: snake,
                                  apple: apple)
    gameViewModel?.delegate = self
  }
  
  func run() {
    gameHandler!.startGame()
  }
  
  //MARK: - GameHandlerDelegate
  func collision() {
    gameViewModel?.showAlert()
  }
  
  func updateBoard(snake: Snake, apple: Apple) {
    gameViewModel?.showView(snake: snake, apple: apple)
  }
  
  //MARK: - GameViewModelDelegate
  func restartButtonPressed() {
    view.layer.sublayers?.removeAll()
    startGame()
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
