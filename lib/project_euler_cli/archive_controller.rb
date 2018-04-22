module ProjectEulerCli

# Controller class that manages the archive system. It holds the archive data 
# used by ArchiveViewer and ArchiveSearcher.
class ArchiveController
  include Scraper

  def initialize
    lookup_totals

    @problems = Array.new(Problem.total + 1) { Problem.new }

    @av = ArchiveViewer.new(@problems)
    @as = ArchiveSearcher.new(@problems)
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

  # call-seq:
  #   get_page(id) => page
  #
  # Returns page number based on the ID of the problem. The recent page is
  # considered page 0, invalid pages return -1.
  def get_page(id)
    if id.between?(Problem.total - 9, Problem.total)
      0
    elsif id.between?(1, Problem.total - 10)
      (id - 1) / Page::LENGTH + 1
    else
      -1
    end
  end

end

end
