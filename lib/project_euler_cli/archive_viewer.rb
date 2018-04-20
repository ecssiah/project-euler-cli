module ProjectEulerCli

# Handles the work of displaying information about the problems.
class ArchiveViewer

  def initialize(problems)
    @problems = problems
  end

  # Loads in all of the problem numbers and titles from the recent page.
  def load_recent
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

  # Displays the 10 most recently added problems.
  def display_recent
    load_recent unless Page.visited.include?(0)

    puts

    (Problem.total).downto(Problem.total - 9) do |i|
      puts "#{i} - #{@problems[i].title}"
    end
  end

  # Loads the problem numbers and titles for an individual page of the archive.
  def load_page(page)
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

  # Displays the problem numbers and titles for an individual page of the archive.
  def display_page(page)
    load_page(page) unless Page.visited.include?(page)

    puts

    start = (page - 1) * 50 + 1
    for i in start...start + 50
      unless i >= Problem.total - 9
        puts "#{i} - #{@problems[i].title}"
      end
    end
  end

  # Loads the details of an individual problem.
  def load_problem_details(id)
    html = open("https://projecteuler.net/problem=#{id}")
    fragment = Nokogiri::HTML(html)

    problem_info = fragment.css('div#problem_info span span')

    details = problem_info.text.split(';')
    @problems[id].published = details[0].strip
    @problems[id].solved_by = details[1].strip

    # recent problems do not have a difficult rating
    if id < Problem.total - 9
      @problems[id].difficulty = details[2].strip
    end
  end

  # Displays the details of an individual problem.
  #
  # * +id+ - ID of the problem to be displayed
  def display_problem(id)
    load_problem_details(id) if @problems[id].published.nil?

    puts
    puts "#{@problems[id].title}".upcase
    puts "Problem #{id}"
    puts
    puts @problems[id].published
    puts @problems[id].solved_by
    puts @problems[id].difficulty if id < Problem.total - 9
    puts
    puts "https://projecteuler.net/problem=#{id}"
  end

  # Displays a custom page of problems given by an array of IDs.
  #
  # * +list+ - Array of problem IDs
  def display_custom_page(list)
    puts

    list.each { |id| puts "#{id} - #{@problems[id].title}" }
  end

end

end
