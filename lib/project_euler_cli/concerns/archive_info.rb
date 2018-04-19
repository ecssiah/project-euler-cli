module ProjectEulerCli

module ArchiveInfo
  attr_reader :num_problems, :num_pages

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

  # Dynamically looking up the total number of problems and the page count will
  # allow the application to continue working after new problems and pages are
  # added to the archive
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

end

end
