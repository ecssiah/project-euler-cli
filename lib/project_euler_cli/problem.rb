module ProjectEulerCli

class Problem
  attr_accessor :id, :title, :published, :solved_by, :difficulty

  @@total = 0

  def self.total
    @@total
  end

  def self.total=(total)
    @@total = total
  end

end

end
