module ProjectEulerCli

class ArchiveSearcher
  attr_accessor :keywords

  def initialize
    @initial_search = true
    @keywords = []
  end

  def load_terms
    puts "loading..."
  end

  def search(term)
    if @initial_search
      @initial_search = false
      load_terms
    end

    puts "searching..."
  end
end

end
