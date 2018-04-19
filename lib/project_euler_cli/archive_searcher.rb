module ProjectEulerCli

class ArchiveSearcher
  attr_accessor :keywords, :results, :searching

  def initialize
    @searching = false
    @initial_search = true

    lookup_totals

    @results = []
    @keywords = Array.new(@num_problems, "")
  end

  # Recent page is considered page 0, invalid pages return -1
  def get_page_from_problem_id(id)
    if id.between?(@num_problems - 9, @num_problems)
      0
    elsif id.between?(1, @num_problems - 10)
      (id - 1)/ 50 + 1
    else
      -1
    end
  end

  def lookup_totals
    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    id_col = fragment.css('#problems_table td.id_column')

    # The newest problem is the first one listed on the recent page. The ID of this
    # problem will always equal the total number of problems.
    @num_problems = id_col.first.text.to_i
    # The last problem on the recent page has an ID that is one larger than the
    # last problem in the archive pages. The total number of pages can be calculated
    # from its ID.
    @num_pages = get_page_from_problem_id(id_col.last.text.to_i - 1)
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
