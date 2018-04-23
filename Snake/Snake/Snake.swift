enum Direction {
  case Up
  case Down
  case Right
  case Left
}

class Snake {
  var body = [Point]()
  var direction = Direction.Down
  var shouldGrow = false
  
  init (length:Int = Constants.snakeLength) {
    for i in 0..<length {
      body.append(Point(x: 0, y: i))
    }
  }
  
  func addHead() {
    let previousHead = body.last
    var offsetX = 0
    var offsetY = 0
    
    switch direction {
    case .Up:
      offsetY = -1
    case .Right:
      offsetX = 1
    case .Down:
      offsetY = 1
    case .Left:
      offsetX = -1
    }
    
    let newHeadX = (previousHead?.x)! + offsetX
    let newHeadY = (previousHead?.y)! + offsetY
    
    body.append(Point(x: newHeadX, y: newHeadY))
  }
  
  func isDirectionPossible(direction: Direction) -> Bool {
    if direction == Direction.Up && self.direction == Direction.Down {return false}
    if direction == Direction.Down && self.direction == Direction.Up {return false}
    if direction == Direction.Right && self.direction == Direction.Left {return false}
    if direction == Direction.Left && self.direction == Direction.Right {return false}
    
    return true
  }
  
  func removeTail() {
    if shouldGrow {
      shouldGrow = false
      return
    }
    body.removeFirst()
  }
  
  func getHead() -> Point {
    return body.last!
  }
  
  func getHeadX() -> Int {
    return getHead().x
  }
  
  func getHeadY() -> Int {
    return getHead().y
  }
  
  func makeMove() {
    removeTail()
    addHead()
  }
}
