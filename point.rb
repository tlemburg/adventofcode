class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def dup
    self.class.new(x,y)
  end

  def px(inc = 1)
    self.class.new(x+inc, y)
  end

  def py(inc = 1)
    self.class.new(x, y+inc)
  end

  def mx(dec = 1)
    self.class.new(x-dec, y)
  end

  def my(dec = 1)
    self.class.new(x, y-dec)
  end

  def left
    self.mx
  end

  def right
    self.px
  end

  def up
    self.my
  end

  def down
    self.py
  end

  def neighbors
    [self.px, self.py, self.my, self.mx]
  end

  def to_s
    "<#{x},#{y}>"
  end

  def eql?(other)
    x == other.x && y == other.y
  end

  def hash
    to_s.hash
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def manhattan(other)
    (other.x - x).abs + (other.y - y).abs
  end
end
