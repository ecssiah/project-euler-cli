module ProjectEulerCli

class CLI

  def initialize
    @av = ArchiveViewer.new
    @as = ArchiveSearcher.new
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
    puts " -            Search (s)            -"
    puts " -             Exit (x)             -"
    print "e: "

    input = gets.strip

    if input == 'r'
      recent_menu
      main_menu
    elsif input == 'l'
      page_menu(1)
      main_menu
    elsif input == 's'
      search_menu
      main_menu
    elsif input == 'x'
      return
    else
      main_menu
    end
  end

  def recent_menu
    @av.display_recent

    puts
    puts "e(x)it"
    print "e: "

    input = gets.strip

    if input.to_i.between?(@av.num_problems, @av.num_problems - 9)
      problem_menu(input.to_i)
    elsif input == 'x'
      return
    else
      recent_menu
    end
  end

  def page_menu(page_num)
    @av.display_page(page_num)

    puts
    puts "[#{page_num}/#{@av.num_pages}] (n)ext (p)rev (g)oto e(x)it"
    print "e: "

    input = gets.strip

    if input.to_i.between?(1, @av.num_pages)
      problem_menu(input.to_i)
    elsif input == 'n'
      page_menu(page_num + 1)
    elsif input == 'p'
      page_menu(page_num - 1)
    elsif input.start_with?('g')
      page_menu(input.gsub('g', '').to_i)
    elsif input == 'x'
      return
    else
      page_menu(page_num)
    end
  end

  def problem_menu(id)
    @av.display_problem(id)

    puts
    puts "(b)ack e(x)it"
    print "e: "

    input = gets.strip

    if input == 'b'
      page_menu(@av.get_page_from_problem_id(id))
    elsif input == 'x'
      return
    else
      problem_menu(id)
    end
  end

  def search_menu
    print "Search: "

    search_terms = gets.strip

    @as.search(search_terms)
  end

end

end
