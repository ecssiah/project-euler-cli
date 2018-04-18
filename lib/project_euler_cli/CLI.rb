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
    puts "  ---------------------------------- "
    puts " [          Project Euler           ]"
    puts " [            e^iπ = -1             ]"
    puts "  ---------------------------------- "
  end

  def main_menu
    puts " -     List recent problems (r)     -"
    puts " -    List archived problems (l)    -"
    puts " -        Search archive (s)        -"
    puts " -             Exit (x)             -"
    print "e: "

    input = gets.strip

    if input == 'r'
      @archive_viewer.display_recent
      main_menu
    elsif input == 'l'
      @archive_viewer.display_page(1)
      main_menu
    elsif input == 's'
      @archive_searcher.search_menu
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

end

end
