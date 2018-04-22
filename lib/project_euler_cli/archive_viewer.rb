module ProjectEulerCli

# Handles the work of displaying information about the problems.
class ArchiveViewer
  include Scraper

  def initialize(problems)
    @problems = problems
  end

  # Displays the 10 most recently added problems.
  def display_recent
    load_recent(@problems)

    puts

    (Problem.total).downto(Problem.total - 9) do |i| 
      puts "#{i} - #{@problems[i].title}" 
    end
  end

  # Displays the problem numbers and titles for an individual page of the archive.
  def display_page(page)
    load_page(page, @problems)

    puts

    start = (page - 1) * Page::PROBLEMS_PER_PAGE + 1
    for i in start...start + Page::PROBLEMS_PER_PAGE
      puts "#{i} - #{@problems[i].title}" unless i >= Problem.total - 9
    end
  end

  # Displays the details of an individual problem.
  #
  # * +id+ - ID of the problem to be displayed
  def display_problem(id)
    load_problem_details(id, @problems)

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
