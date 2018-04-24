module ProjectEulerCli

class Problem
  attr_accessor :title, :published, :solved_by, :difficulty

  @@all = []

  def initialize
    @@all << self
  end

  def self.[](id)
    @@all[id - 1]
  end

  def self.[]=(id, value)
    @@all[id - 1] = value
  end

  def self.total
    @@all.size
  end

  # call-seq:
  #   get_page(id) => page
  #
  # Returns page number based on the ID of the problem. The recent page is
  # considered page 0.
  def self.page(id)
    id.between?(1, total - 10) ? (id - 1) / Page::LENGTH + 1 : 0
  end

end

end
