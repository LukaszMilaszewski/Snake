import Foundation

protocol GameHandlerDelegate: class {
  func collision()
  func updateBoard(board: Board)
}

class GameHandler {
  var snake: Snake
  var board: Board
  var apple: Apple
  
  var timer: Timer?
  var gameSpeed: Speed?
  
  var delegate: GameHandlerDelegate?
  
  init(boardWidth: Int, boardHeight: Int, snakeLength: Int) {
    board = Board(width: boardWidth, height: boardHeight)
    snake = Snake(length: snakeLength)
    apple = Apple(xMax: boardWidth, yMax: boardHeight)
  }
  
  func startGame(gameSpeed: Speed = Constants.initialGameSpeed) {
    setInitialBoard()
    setTimer(speed: gameSpeed)
  }
  
  func setInitialBoard() {
    addSnake()
    addApple()
    delegate?.updateBoard(board: board)
  }
  
  func setTimer(speed: Speed) {
    
    var timeInterval: Double
    
    switch speed {
    case .slow:
      timeInterval = 0.5
    case .medium:
      timeInterval = 0.2
    case .fast:
      timeInterval = 0.1
    }
    
    self.timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                      target: self,
                                      selector: #selector(self.timerMethod(_:)),
                                      userInfo: nil,
                                      repeats: true)
  }
  
  func addSnake() {
    for point in snake.body {
      board.setElement(x: point.x, y: point.y, value: 1)
    }
  }
  
  func addApple() {
    board.setElement(x: apple.x, y: apple.y, value: 5)
  }
  
  func setSnakeDirection(direction: Direction) {
    if snake.isDirectionPossible(direction: direction) {
      snake.direction = direction
    }
  }
  
  func checkColision() -> Bool {
    return snake.isSelfCollision() || isWallCollision()
  }
  
  func isWallCollision() -> Bool {
    let x = snake.getHeadX()
    let y = snake.getHeadY()
    
    return x < 0 || x >= board.getWidth() || y < 0 || y >= board.getHeight()
  }
  
  @objc func timerMethod(_ timer:Timer) {
    snake.makeMove()
    
    if checkColision() {
      timer.invalidate()
      delegate?.collision()

      return
    }
    
    if isAppleCollected() {
      updateApple()
      snake.shouldGrow = true
    }
    
    updateBoard()
    delegate?.updateBoard(board: board)
  }
  
  func updateApple() {
    apple.setRandomPosition()
  }
  
  func isAppleCollected() -> Bool {
    return snake.getHead() == apple
  }
  
  func updateBoard() {
    board.clearBoard()
    addApple()
    addSnake()
  }
}
