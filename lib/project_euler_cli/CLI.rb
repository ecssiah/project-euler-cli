module ProjectEulerCli

class CLI

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

    if input == "l"
      # Enter problem number to view details
      # Next Page (n) / Prev Page (p)
      # Go to Page # by entering (g#)

      ArchiveViewer.display_page(1)

    elsif input == "s"
      print "Search: "
      search_terms = gets.strip

      ArchiveSearcher.search(search_terms)

    elsif input.start_with?("g")

      ArchiveViewer.display_problem(input.gsub("g", ""))

    elsif input == "x"
      return
    else
      main_menu
    end
  end

end

end
