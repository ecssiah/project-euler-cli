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

    puts

    if input == "l"
      # Enter problem number to view details
      # Next Page (n) / Prev Page (p)
      # Go to Page # by entering (g#)
      main_menu
    elsif input == "s"


      main_menu
    elsif input.start_with?("g")
      main_menu
    elsif input == "x"
      return
    else
      main_menu
    end
  end

end

end
