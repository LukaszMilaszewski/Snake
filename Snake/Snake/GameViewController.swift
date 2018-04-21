import UIKit

class GameViewController: UIViewController, GameHandlerDelegate {
  
  var gameHandler: GameHandler?
  var gameViewModel: GameViewModel?
  

  var width: Int?
  var height: Int?
  var offsetX: Int?
  var offsetY: Int?
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipe()
    setupView()
    startGame()
  }
  
  func startGame() {
    gameHandler = GameHandler(boardWidth: width!, boardHeight: height!,
                              snakeLength: Constants.snakeLength)
    
    gameHandler!.delegate = self
    gameHandler!.startGame()
  }
  
  func setupView() {
    setupDimensions()
    view.backgroundColor = UIColor.gray
    gameViewModel = GameViewModel(view: self.view, color: UIColor.green, width: width!, height: height!, offsetX: offsetX!, offsetY: offsetY!)

  }
  
  func setupDimensions() {
    let screenWidth = Int(view.bounds.width)
    let screenHeight = Int(view.bounds.height)
    
    width = Int(screenWidth / Constants.squareDimension)
    height = Int(screenHeight / Constants.squareDimension)
    
    offsetX = (screenWidth - width! * Constants.squareDimension) / 2
    offsetY = (screenHeight - height! * Constants.squareDimension) / 2
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
  
  func updateBoard(board: Board) {
    gameViewModel!.temp(board: board)
  }
}
