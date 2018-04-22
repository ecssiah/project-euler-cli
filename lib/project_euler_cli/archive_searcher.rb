module ProjectEulerCli

# Handles searching the problems
class ArchiveSearcher
  include Scraper

  # Array of IDs corresponding to the problems found in last search
  attr_reader :results
  # Tracks whether there is an active search
  attr_accessor :searching

  def initialize(problems)
    @problems = problems

    @results = []
    @searching = false
    @initial_search = true
  end

  # Loads the problem numbers and titles for every page that is not loaded.
  def load_terms
    puts "updating keywords..."

    0.upto(Page.total) { |page| load_page(page, @problems) }
  end

  # Performs a simple search of the problems. It accepts multiple terms. Results
  # will contain *any* of the terms
  #
  # * +terms+ - String of search terms
  def search(terms)
    if @initial_search
      @initial_search = false
      load_terms
    end

    puts "searching..."
    @searching = true

    @results = (1..Problem.total).select do |i|
      terms.downcase.split(' ').all? do |term|
        @problems[i].title.downcase.include?(term)
      end
    end
  end

end

end
