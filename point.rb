class Point
  attr_writer :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def px
    self.new(x+1, y)
  end

  def py
    self.new(x, y+1)
  end

  def mx
    self.new(x-1, y)
  end

  def my
    self.new(x, y-1)
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
end
