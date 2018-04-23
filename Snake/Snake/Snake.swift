enum Direction {
  case north
  case south
  case east
  case west
}

class Snake {
  var body = [Point]()
  var direction = Direction.south
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
    case .north:
      offsetY = -1
    case .east:
      offsetX = 1
    case .south:
      offsetY = 1
    case .west:
      offsetX = -1
    }
    
    let newHeadX = (previousHead?.x)! + offsetX
    let newHeadY = (previousHead?.y)! + offsetY
    
    body.append(Point(x: newHeadX, y: newHeadY))
  }
  
  func isDirectionPossible(direction: Direction) -> Bool {
    if direction == Direction.north && self.direction == Direction.south {return false}
    if direction == Direction.south && self.direction == Direction.north {return false}
    if direction == Direction.east && self.direction == Direction.west {return false}
    if direction == Direction.west && self.direction == Direction.east {return false}
    
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
