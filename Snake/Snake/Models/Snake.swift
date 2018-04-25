class Snake {
  var body: [Point]
  var direction: Direction
  var shouldGrow = false
  
  init (length:Int = Constants.snakeLength, initialDirection: Direction = Constants.snakeDirection) {
    direction = initialDirection
    
    body = [Point]()
    for i in 0..<length {
      body.append(Point(x: 0, y: i))
    }
  }
  
  func isDirectionPossible(direction: Direction) -> Bool {
    if direction == Direction.up && self.direction == Direction.down {return false}
    if direction == Direction.down && self.direction == Direction.up {return false}
    if direction == Direction.right && self.direction == Direction.left {return false}
    if direction == Direction.left && self.direction == Direction.right {return false}
    
    return true
  }
  
  func isSelfCollision() -> Bool {
    for i in body.indices.dropLast() {
      if body[i] == body.last {
        return true
      }
    }
    return false
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
  
  func removeTail() {
    if shouldGrow {
      shouldGrow = false
      return
    }
    body.removeFirst()
  }
  
  func addHead() {
    let previousHead = body.last
    var offsetX = 0
    var offsetY = 0
    
    switch direction {
    case .up:
      offsetY = -1
    case .right:
      offsetX = 1
    case .down:
      offsetY = 1
    case .left:
      offsetX = -1
    }
    
    let newHeadX = (previousHead?.x)! + offsetX
    let newHeadY = (previousHead?.y)! + offsetY
    
    body.append(Point(x: newHeadX, y: newHeadY))
  }
}
