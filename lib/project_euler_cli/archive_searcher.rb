module ProjectEulerCli

# Handles searching the problems
class ArchiveSearcher
  # Array of IDs corresponding to the problems found in last search
  attr_reader :results
  attr_accessor :searching

  def initialize(archive_data)
    @archive_data = archive_data

    @results = []
    @searching = false
    @initial_search = true
  end

  # Loads the problem numbers and titles for every page that is not loaded.
  def load_terms
    puts "updating keywords..."

    # Loading each archive page
    (1..@archive_data[:num_pages]).each do |page|
      unless @archive_data[:visited_pages].include?(page)
        html = open("https://projecteuler.net/archives;page=#{page}")
        fragment = Nokogiri::HTML(html)

        problem_links = fragment.css('#problems_table td a')

        i = (page - 1) * 50 + 1
        problem_links.each do |link|
          @archive_data[:problems][i] = link.text
          i += 1
        end

        @archive_data[:visited_pages] << page
      end
    end

    # Loading the recent problems
    unless @archive_data[:visited_pages].include?(0)
      html = open("https://projecteuler.net/recent")
      fragment = Nokogiri::HTML(html)

      problem_links = fragment.css('#problems_table td a')

      problem_links.each do |link|
        @archive_data[:problems].insert(@archive_data[:num_problems] - 9, link.text)
      end

      @archive_data[:visited_pages] << 0
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
      for i in 1..@archive_data[:num_problems]
        if @archive_data[:problems][i].downcase.include?(term.downcase)
          @results << i
        end
      end
    end
  end

end

end
