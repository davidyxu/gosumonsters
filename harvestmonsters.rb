require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super(800, 800, false)
    self.caption = "Harvest Monsters"
    @player = Player.new(self, 5, 5)
    @sector = Sector.new(self, "media/start.map")
  end
  
  def update
    if button_down? Gosu::KbLeft then
      @player.move(:left) if @player.delay <= 0
    end
    if button_down? Gosu::KbRight then
      @player.move(:right) if @player.delay <= 0
    end
    if button_down? Gosu::KbUp then
      @player.move(:up) if @player.delay <= 0
    end
    if button_down? Gosu::KbDown then
      @player.move(:down) if @player.delay <= 0
    end
    @player.update
  end
  
  def draw
    @sector.draw(@player.x, @player.y)
    @player.draw
  end
end


#player
class Entity
  attr_reader :x, :y, :dir, :delay
  def initialize(window, x, y, dir = :up)
    @image = Gosu::Image.new(window, "media/player.png", false)
    @x, @y = x, y
    @delay = 0
  end
  def face(dir)
    @dir = dir
  end
end
class Combatant < Entity
  attr_reader :formation
end
class Player < Combatant
  def move(dir)
    @dir = dir
    @y -= 1 if dir == :up
    @y += 1 if dir == :down
    @x -= 1 if dir == :left
    @x += 1 if dir == :right
    @delay = 5
  end
  def update
    @delay -= 1 if delay>0
  end
  def draw
    @image.draw_rot(@x*50, @y*50, 1, 0)
  end
end


#map
class Map
end
class Sector
  def initialize(window, map_file)
    @ground = Gosu::Image.new(window, "media/ground.png", false)
    @wall = Gosu::Image.new(window, "media/wall.png", false)
    @sector ||= load_sector(map_file)
    print @sector
  end
  def load_sector(map_file)
    File.readlines(map_file).map {|line| line.chomp.split('').map!{|x|x.to_sym}}
  end
  def get_tile(x,y)
    @sector[y][x]
  end
  def draw(x, y)
    @sector.each_with_index do |line, i|
      line.each_with_index do |tile, j|
        case tile
        when :x
          @ground.draw_rot(j*50, i*50, 1, 0)
        when :o
          @wall.draw_rot(j*50, i*50, 1, 0)
        end
      end
    end
  end
end

window = GameWindow.new
window.show