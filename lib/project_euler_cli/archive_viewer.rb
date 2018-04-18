module ProjectEulerCli

class ArchiveViewer

  def initialize
    @problems = {}

    @visited_pages = []

    lookup_totals
  end

  def get_page_from_problem_id(id)
    id / 50 + 1
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

  def load_page(page_num)
    html = open("https://projecteuler.net/archives;page=#{page_num}")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    @visited_pages << page_num
  end

  def display_page(page_num)
    unless @visited_pages.include?(page_num)
      load_page(page_num)
    end

    puts "[#{page_num}/#{@num_pages}] (n)ext (p)rev"
    print "e: "
    input = gets.strip

  end

  def display_problem(id)
    puts id
  end

end

end
