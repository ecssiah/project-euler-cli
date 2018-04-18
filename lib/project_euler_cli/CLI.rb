module ProjectEulerCli

class CLI

  def initialize
    @archive_viewer = ArchiveViewer.new
    @archive_searcher = ArchiveSearcher.new
  end

  def start
    welcome
    main_menu
  end

  def welcome
    puts "  -----------------------------  "
    puts " [      Project Euler CLI      ] "
    puts " [          e^iπ = -1          ] "
    puts "  -----------------------------  "
  end

  def main_menu
    puts " -      List problems (l)      -"
    puts " -     Search archives (s)     -"
    puts " -   Go to problem #23 (g23)   -"
    puts " -         To exit (x)         -"
    print "e: "

    input = gets.strip

    if input == 'l'
      display_menu
      main_menu
    elsif input == 's'
      search_menu
      main_menu
    elsif input.start_with?('g')
      problem_menu(input)
      main_menu
    elsif input == 'x'
      return
    else
      main_menu
    end
  end

  def display_menu
    # Enter problem number to view details
    # Next Page (n) / Prev Page (p)
    # Go to Page # by entering (g#)

    @archive_viewer.display_page(1)
  end

  def problem_menu(input)
    @archive_viewer.display_problem(input.gsub("g", ""))
  end

  def search_menu
    print "Search: "
    search_terms = gets.strip

    @archive_searcher.search(search_terms)
  end

end

end
