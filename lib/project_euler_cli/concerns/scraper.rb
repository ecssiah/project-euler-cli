module ProjectEulerCli

# Holds all of the methods related to accessing the site.
module Scraper

  # Pulls information from the recent page to determine the total number of 
  # problems and pages.
  def lookup_totals
    begin
      Timeout.timeout(4) do
        html = open("https://projecteuler.net/recent")
        fragment = Nokogiri::HTML(html)

        id_col = fragment.css('#problems_table td.id_column')

        # The newest problem is the first one listed on the recent page. The ID 
        # of this problem will always equal the total number of problems.
        id_col.first.text.to_i.times { Problem.new }
        # There are ten problems on the recent page, so the last archive problem 
        # can be found by subtracting 10 from the total number of problems.
        Page.total = Problem.page(Problem.total - 10) 
      end
    rescue Timeout::Error
      puts "Project Euler is not responding."

      exit(true)
    end
  end

  # Loads in all of the problem numbers and titles from the recent page.
  def load_recent
    return if Page.visited.include?(0)

    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    i = Problem.total
    problem_links.each do |link|
      Problem[i].title = link.text
      i -= 1
    end

    Page.visited << 0
  end

  # Loads the problem numbers and titles for an individual page of the archive.
  def load_page(page)
    return if Page.visited.include?(page)

    html = open("https://projecteuler.net/archives;page=#{page}")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    i = (page - 1) * Page::LENGTH + 1
    problem_links.each do |link|
      Problem[i].title = link.text
      i += 1
    end

    Page.visited << page
  end

  # Loads the details of an individual problem.
  def load_problem_details(id)
    return unless Problem[id].published.nil?

    html = open("https://projecteuler.net/problem=#{id}")
    fragment = Nokogiri::HTML(html)

    problem_info = fragment.css('div#problem_info span span')

    details = problem_info.text.split(';')
    Problem[id].published = details[0].strip
    Problem[id].solved_by = details[1].strip

    # recent problems do not have a difficult rating
    Problem[id].difficulty = details[2].strip if id <= Problem.total - 10
  end

end

end
