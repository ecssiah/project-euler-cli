module ProjectEulerCli

# Handles searching the problems
class ArchiveSearcher
  include Scraper

  # Array of IDs corresponding to the problems found in last search
  attr_reader :results
  # Tracks whether there is an active search
  attr_accessor :searching

  def initialize
    @results = []
    @searching = false
    @initial_search = true
  end

  # Loads the problem numbers and titles for every page that is not loaded.
  def load_keywords
    puts "updating keywords..."

    0.upto(Page.total) { |page| load_page(page) }
  end

  # Performs a simple search of the problems. It accepts multiple terms and
  # recognizes quoted phrases. Results will contain *all* of the search terms.
  #
  # * +terms+ - String of search terms
  def search(terms_string)
    load_keywords if Page.visited != (0..Page.total).to_a

    puts "searching..."
    @searching = true

    terms_string.downcase!
    terms = terms_string.scan(/"[^"]*"/)
    terms.each { |term| terms_string.slice!(term) }
    terms.collect! { |term| term.gsub("\"", '') }
    terms += terms_string.split(' ')

    @results = (1..Problem.total).select do |i|
      terms.all? { |term| Problem[i].title.downcase.include?(term) }
    end
  end

end

end
