enum Direction {
  case north
  case south
  case east
  case west
}

class Snake {
  var body = [Point]()
  var direction = Direction.south
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
  
  func isSelfCollision() -> Bool {
    for i in body.indices.dropLast() {
      if body[i] == body.last {
        return true
      }
    }
    return false
  }
  
  func removeTail() {
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
