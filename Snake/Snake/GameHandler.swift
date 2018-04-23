import Foundation

protocol GameHandlerDelegate: class {
  func collision()
  func updateBoard(board: Board)
}

class GameHandler {
  var delegate: GameHandlerDelegate?
  var timer: Timer?
  var snake: Snake
  var board: Board
  var apple: Apple
  
  init(boardWidth: Int, boardHeight: Int, snakeLength: Int) {
    board = Board(width: boardWidth, height: boardHeight)
    snake = Snake(length: snakeLength)
    apple = Apple(xMax: boardWidth, yMax: boardHeight)
  }
  
  func startGame() {
    setInitialBoard()
    self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.timerMethod(_:)), userInfo: nil, repeats: true)
  }
  
  func setSnakeDirection(direction: Direction) {
    if snake.isDirectionPossible(direction: direction) {
      snake.direction = direction
    }
  }
  
  func setInitialBoard() {
    addSnake()
    addApple()
    delegate?.updateBoard(board: board)
  }
  
  func addSnake() {
    for point in snake.body {
      board.setElement(x: point.x, y: point.y, value: 1)
    }
  }
  
  func isWallCollision() -> Bool {
    let x = snake.getHeadX()
    let y = snake.getHeadY()
    
    return x < 0 || x >= board.getWidth() || y < 0 || y >= board.getHeight()
  }
  
  func isSelfCollision() -> Bool {
    for i in snake.body.indices.dropLast() {
      if snake.body[i] == snake.body.last {
        return true
      }
    }
    return false
  }
  
  func checkColision() -> Bool {
    return isSelfCollision() || isWallCollision()
  }
  
  func addApple() {
    board.setElement(x: apple.x, y: apple.y, value: 5)
  }
  
  func updateApple() {
    apple.setRandomPosition()
  }
  
  func isAppleCollected() -> Bool {
    return snake.getHead() == apple
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
  
  func updateBoard() {
    board.clearBoard()
    addApple()
    addSnake()
  }
}
