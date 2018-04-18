module ProjectEulerCli

class ArchiveSearcher

  def initialize
    @initial_search = true
    @keywords = {}
  end

  def load_terms
    puts "loading..."
  end

  def search_menu
    print "Search: "
    search_terms = gets.strip

    search(search_terms)
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
