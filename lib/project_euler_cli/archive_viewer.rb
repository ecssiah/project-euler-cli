module ProjectEulerCli

# Handles the work of displaying information about the problems.
class ArchiveViewer
  include Scraper

  def initialize
    lookup_totals
  end

  # Displays the 10 most recently added problems.
  def display_recent
    load_recent

    puts

    (Problem.total).downto(Problem.total - 9) do |i| 
      puts "#{i} - #{Problem[i].title}" 
    end
  end

  # Displays the problem numbers and titles for an individual page of the 
  # archive.
  def display_page(page)
    load_page(page)

    puts

    start = (page - 1) * Page::LENGTH + 1
    start.upto(start + Page::LENGTH - 1) do |i|
      puts "#{i} - #{Problem[i].title}" unless i >= Problem.total - 9
    end
  end

  # Displays the details of an individual problem.
  #
  # * +id+ - ID of the problem to be displayed
  def display_problem(id)
    load_problem_details(id)

    puts
    puts "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    puts
    puts "#{Problem[id].title}".upcase
    puts "Problem #{id}"
    puts
    puts Problem[id].published
    puts Problem[id].solved_by
    puts Problem[id].difficulty if id < Problem.total - 9
    puts
    puts "https://projecteuler.net/problem=#{id}"
    puts
    puts "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
  end

  # Displays a custom page of problems given by an array of IDs.
  #
  # * +list+ - Array of problem IDs
  def display_custom_page(list)
    puts
    list.each { |id| puts "#{id} - #{Problem[id].title}" }
  end

end

end
