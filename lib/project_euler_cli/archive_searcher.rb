module ProjectEulerCli

class ArchiveSearcher

  @@initial_search = true

  def self.load
    puts "loading..."
  end

  def self.search(term)
    if @@initial_search
      @@initial_search = false
      self.load
    end

    puts "searching..."
  end
end

end
