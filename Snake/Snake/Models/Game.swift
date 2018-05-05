import Foundation

protocol GameDelegate: class {
  func collision(score: Int) 
  func updateSnake(snake: Snake)
  func updateApple(apple: Apple)
}

class Game {
  public private(set) var snake: Snake
  public private(set) var board: Board
  public private(set) var apple: Apple
  
  private var timer: Timer?
  private var gameSpeed: Double?
  
  private var score = 0
  private var shouldIncreaseSpeed = false
  
  private var gameOptions: GameOptions
  var delegate: GameDelegate?
  
  init(boardWidth: Int, boardHeight: Int, snakeLength: Int, gameOptions: GameOptions) {
    board = Board(width: boardWidth, height: boardHeight)
    snake = Snake(length: snakeLength)
    apple = Apple(xMax: boardWidth, yMax: boardHeight)
    self.gameOptions = gameOptions
  }
  
  func startGame(gameSpeed: Double = Constants.initialGameSpeed) {
    self.gameSpeed = gameSpeed
    setInitialBoard()
    setTimer(speed: gameSpeed)
  }
  
  private func setInitialBoard() {
    delegate?.updateSnake(snake: snake)
    delegate?.updateApple(apple: apple)
  }
  
  private func setTimer(speed: Double) {
    timer?.invalidate()
    let timeInterval = speed
    
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
  
  private func checkColision() -> Bool {
    return snake.isSelfCollision() || isWallCollision()
  }
  
  private func isWallCollision() -> Bool {
    let x = snake.getHeadX()
    let y = snake.getHeadY()
    
    return x < 0 || x >= board.width || y < 0 || y >= board.height
  }
  
  @objc func timerMethod(_ timer:Timer) {
    if shouldIncreaseSpeed {
      increaseSpeed()
    }
    snake.makeMove()

    if !isMoveValid() {
      timer.invalidate()
      delegate?.collision(score: score)
      
      return
    }

    if isAppleCollected() {
      appleCollected()
    }
    delegate?.updateSnake(snake: snake)
  }
  
  private func isMoveValid() -> Bool {
    if gameOptions.passWalls && isWallCollision() {
      switch snake.direction {
      case .down:
        snake.setHead(point: Point(x: snake.getHeadX(), y: 0))
      case .up:
        snake.setHead(point: Point(x: snake.getHeadX(), y: board.height - 1))
      case .right:
        snake.setHead(point: Point(x: 0, y: snake.getHeadY()))
      case .left:
        snake.setHead(point: Point(x: board.width - 1, y: snake.getHeadY()))
      }
    } else {
      if checkColision() {
        return false
      }
    }
    return true
  }
  
  private func increaseSpeed() {
    shouldIncreaseSpeed = !shouldIncreaseSpeed
    gameSpeed! -= Constants.increaseSpeedStep
    
    if gameSpeed! <= 0.0 {
      gameSpeed! = 0.1
    }
    setTimer(speed: gameSpeed!)
  }
  
  private func appleCollected() {
    score += 1
    
    if score % Constants.scorePointsToIncreaseSpeed == 0  && gameOptions.increaseSpeed {
      shouldIncreaseSpeed = !shouldIncreaseSpeed
    }
    updateApple()
    delegate?.updateApple(apple: apple)
    snake.shouldGrow = true
  }
  
  private func updateApple() {
    var point = Utils.getRandomPoint(xMax: apple.xMax, yMax: apple.yMax)
    while !isPointOnSnake(point: point) {
      point = Utils.getRandomPoint(xMax: apple.xMax, yMax: apple.yMax)
    }
    apple.setPosition(point: point)
  }
  
  private func isPointOnSnake(point: Point) -> Bool {
    for snakePoint in snake.body {
      if snakePoint == point { return false }
    }
    return true
  }
  
  private func isAppleCollected() -> Bool {
    return snake.getHead() == apple
  }
}
