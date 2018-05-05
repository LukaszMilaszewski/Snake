import UIKit

class GameViewController: UIViewController, GameDelegate, GameViewModelDelegate {
  
  var game: Game?
  var gameViewModel: GameViewModel?
  var gameOptions: GameOptions?
  
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
      game!.setSnakeDirection(direction: Direction.up)
    case UISwipeGestureRecognizerDirection.down:
      game!.setSnakeDirection(direction: Direction.down)
    case UISwipeGestureRecognizerDirection.left:
      game!.setSnakeDirection(direction: Direction.left)
    case UISwipeGestureRecognizerDirection.right:
      game!.setSnakeDirection(direction: Direction.right)
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

    game = Game(boardWidth: width,
                boardHeight: height,
                snakeLength: Constants.snakeLength,
                gameOptions: gameOptions!)

    game!.delegate = self
    setupView(board: (game?.board)!, snake: (game?.snake)!, apple: (game?.apple)!,
              showGrid: gameOptions!.grid)
  }
  
  func setupView(board: Board, snake: Snake, apple: Apple, showGrid: Bool) {
    view.backgroundColor = UIColor.gray
    gameViewModel = GameViewModel(view: self.view,
                                  color: Constants.backgroundColor,
                                  board: board,
                                  snake: snake,
                                  apple: apple,
                                  showGrid: showGrid)
    gameViewModel?.delegate = self
  }
  
  func run() {
    game!.startGame()
  }
  
  //MARK: - gameDelegate
  func collision(score: Int) {
    let defaults = UserDefaults.standard
    let bestScore = defaults.integer(forKey: "BestScore")
    
    if score > bestScore {
      defaults.set(score, forKey: "BestScore")
    }
    
    gameViewModel?.showAlert(score: score)
  }
  
  func updateSnake(snake: Snake) {
    gameViewModel?.updateSnake(snake: snake)
  }
  
  func updateApple(apple: Apple) {
    gameViewModel?.updateApple(apple: apple)
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
