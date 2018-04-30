import Foundation

protocol GameDelegate: class {
  func collision(score: Int) 
  func updateSnake(snake: Snake)
  func updateApple(apple: Apple)
}

class Game {
  var snake: Snake
  var board: Board
  var apple: Apple
  
  var timer: Timer?
  var gameSpeed: Speed?
  
  var score: Int = 0
  var delegate: GameDelegate?
  
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
    delegate?.updateSnake(snake: snake)
    delegate?.updateApple(apple: apple)
  }
  
  func setTimer(speed: Speed) {
    
    let timeInterval = speed.rawValue
    
    self.timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                      target: self,
                                      selector: #selector(self.timerMethod(_:)),
                                      userInfo: nil,
                                      repeats: true)
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
    
    return x < 0 || x >= board.width || y < 0 || y >= board.height
  }
  
  @objc func timerMethod(_ timer:Timer) {
    snake.makeMove()
    
    if checkColision() {
      timer.invalidate()
      delegate?.collision(score: score)

      return
    }
    
    if isAppleCollected() {
      score += 1
      updateApple()
      delegate?.updateApple(apple: apple)
      snake.shouldGrow = true
    }

    delegate?.updateSnake(snake: snake)
  }
  
  func updateApple() {
    var point = Utils.getRandomPoint(xMax: apple.xMax, yMax: apple.yMax)
    while !isPointOnSnake(point: point) {
      point = Utils.getRandomPoint(xMax: apple.xMax, yMax: apple.yMax)
    }
    apple.setPosition(point: point)
  }
  
  func isPointOnSnake(point: Point) -> Bool {
    for snakePoint in snake.body {
      if snakePoint == point { return false }
    }
    return true
  }
  
  func isAppleCollected() -> Bool {
    return snake.getHead() == apple
  }
}
