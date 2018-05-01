class Apple: Point {
  var xMax: Int
  var yMax: Int
  
  init(xMax: Int, yMax: Int) {
    self.xMax = xMax
    self.yMax = yMax
    
    let randomPoint = Utils.getRandomPoint(xMax: xMax, yMax: yMax)
    super.init(x:randomPoint.x, y: randomPoint.y)
  }
  
  func setPosition(point: Point) {
    x = point.x
    y = point.y
  }
  
  func setRandomPosition() {
    let point = Utils.getRandomPoint(xMax: xMax, yMax: yMax)
    setPosition(point: point)
  }
  
  func changeMaxes(xMax: Int, yMax: Int) {
    self.xMax = xMax
    self.yMax = yMax
  }
}
