module ProjectEulerCli

class ArchiveSearcher
  include ArchiveInfo

  attr_accessor :keywords, :results, :searching

  def initialize
    @searching = false
    @initial_search = true

    lookup_totals

    @results = []
    @keywords = Array.new(@num_problems, "")
  end

  def load_terms
    puts "updating keywords..."

    (1..@num_pages).each do |page|
      html = open("https://projecteuler.net/archives;page=#{page}")
      fragment = Nokogiri::HTML(html)

      problem_links = fragment.css('#problems_table td a')

      i = (page - 1) * 50 - 1
      problem_links.each do |link|
        @keywords[i += 1] = link.text.downcase
      end
    end

    # !!! TODO Add keywords from the recent page !!!

    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    i = @num_problems
    problem_links.each do |link|
      @keywords[i -= 1] = link.text.downcase
    end
  end

  def search(terms)
    if @initial_search
      @initial_search = false
      load_terms
    end

    puts "searching..."
    @searching = true

    @results.clear
    terms_arr = terms.downcase.split(' ')

    @keywords.each.with_index do |string, i|
      terms_arr.each do |term|
        @results << i + 1 if string.include?(term)
      end
    end
  end

end

end
