class GameOptions {
  var passWalls: Bool
  var increaseSpeed: Bool
  var grid: Bool
  var obstacles: Bool
  
  init(passWalls: Bool = false, increaseSpeed: Bool = false,
       grid: Bool = false, obstacles: Bool = false) {
    self.passWalls = passWalls
    self.increaseSpeed = increaseSpeed
    self.grid = grid
    self.obstacles = obstacles
  }
}
