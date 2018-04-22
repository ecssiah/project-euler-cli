module ProjectEulerCli

class Page

  LENGTH = 50

  @@total = 0
  @@visited = []

  def self.total
    @@total
  end

  def self.total=(total)
    @@total = total
  end

  def self.visited
    @@visited
  end

end

end
