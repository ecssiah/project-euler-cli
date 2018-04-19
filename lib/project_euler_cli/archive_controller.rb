module ProjectEulerCli

class ArchiveController
  
  def initialize
    @archive_data = {}

    self.lookup_totals

    @archive_data[:visited_pages] = []
    @archive_data[:problems] = Array.new(@archive_data[:num_problems] + 1, "")
    @archive_data[:problem_details] = Array.new(@archive_data[:num_problems] + 1, {})

    @av = ArchiveViewer.new(@archive_data)
    @as = ArchiveSearcher.new(@archive_data)
  end

  def num_pages
    @archive_data[:num_pages]
  end

  def num_problems
    @archive_data[:num_problems]
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

  # Recent page is considered page 0, invalid pages return -1
  def get_page(id)
    if id.between?(@archive_data[:num_problems] - 9, @archive_data[:num_problems])
      0
    elsif id.between?(1, @archive_data[:num_problems] - 10)
      (id - 1) / 50 + 1
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
    @archive_data[:num_problems] = id_col.first.text.to_i
    # The last problem on the recent page has an ID that is one larger than the
    # last problem in the archive pages. The total number of pages can be calculated
    # from its ID.
    @archive_data[:num_pages] = get_page(id_col.last.text.to_i - 1)
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
    @av.display_results(@as.results)
  end

  def display_problem(id)
    @av.display_problem(id)
  end

end

end
