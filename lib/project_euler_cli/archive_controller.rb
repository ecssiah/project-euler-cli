module ProjectEulerCli

# Controller class that manages the archive system. It holds the archive data used
# by ArchiveViewer and ArchiveSearcher.
class ArchiveController

  def initialize
    lookup_totals

    @problems = Array.new(Problem.total + 1) { Problem.new }

    @av = ArchiveViewer.new(@problems)
    @as = ArchiveSearcher.new(@problems)
  end

  # call-seq:
  #   get_page(id) => page
  #
  # Returns page number based on the ID of the problem. The recent page is
  # considered page 0, invalid pages return -1.
  def get_page(id)
    if id.between?(Problem.total - 9, Problem.total)
      0
    elsif id.between?(1, Problem.total - 10)
      (id - 1) / 50 + 1
    else
      -1
    end
  end

  # Pulls information from the recent page to determine the total number of problems
  # and pages.
  def lookup_totals
    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    id_col = fragment.css('#problems_table td.id_column')

    # The newest problem is the first one listed on the recent page. The ID of this
    # problem will always equal the total number of problems.
    Problem.total = id_col.first.text.to_i
    # The last problem on the recent page has an ID that is one larger than the
    # last problem in the archive pages. The total number of pages can be calculated
    # from its ID.
    Page.total = get_page(id_col.last.text.to_i - 1)
  end

  def searching=(searching)
    @as.searching = searching
  end

  def searching
    @as.searching
  end

  def search(terms)
    @as.search(terms)
  end

  def results_include?(id)
    @as.results.include?(id)
  end

  def display_recent
    @av.display_recent
  end

  def display_page(page)
    @av.display_page(page)
  end

  def display_results
    @av.display_custom_page(@as.results)
  end

  def display_problem(id)
    @av.display_problem(id)
  end

end

end
