module ProjectEulerCli

# Handles searching the problems
class ArchiveSearcher
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

    # Loading each archive page
    1.upto(Page.total) do |page|
      unless Page.visited.include?(page)
        html = open("https://projecteuler.net/archives;page=#{page}")
        fragment = Nokogiri::HTML(html)

        problem_links = fragment.css('#problems_table td a')

        i = (page - 1) * 50 + 1
        problem_links.each do |link|
          @problems[i].title = link.text
          i += 1
        end

        Page.visited << page
      end
    end

    # Loading the recent problems
    unless Page.visited.include?(0)
      html = open("https://projecteuler.net/recent")
      fragment = Nokogiri::HTML(html)

      problem_links = fragment.css('#problems_table td a')

      i = Problem.total
      problem_links.each do |link|
        @problems[i].title = link.text
        i -= 1
      end

      Page.visited << 0
    end
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
    @results.clear
    @searching = true

    terms.downcase.split(' ').each do |term|
      for i in 1..Problem.total
        if @problems[i].title.downcase.include?(term.downcase)
          @results << i
        end
      end
    end
  end

end

end
