module ProjectEulerCli

class CLI

  def initialize
    begin
      Timeout::timeout(4) do
        @av = ArchiveViewer.new
        @as = ArchiveSearcher.new
      end

      start
    rescue => e
      banner
      puts "    ! Project Euler Unavailable !    "
    end
  end

  def start
    banner
    main_menu
  end

  def banner
    puts
    puts "  ---------------------------------- "
    puts " [          Project Euler           ]"
    puts " [            e^iπ = -1             ]"
    puts "  ---------------------------------- "
  end

  def prompt
    print "e: "
    gets.strip
  end

  def main_menu
    puts " -     List recent problems (r)     -"
    puts " -    List archived problems (l)    -"
    puts " -            Search (s)            -"
    puts " -             Exit (x)             -"

    input = prompt

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

    input = prompt

    if input.to_i.between?(@av.num_problems - 9, @av.num_problems)
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

    input = prompt

    if input.to_i.between?(50 * (page_num - 1) + 1, 50 * page_num)
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

    input = prompt

    if input == 'b'
      page = @av.get_page_from_problem_id(id)
      page == 0 ? recent_menu : page_menu(page)
    elsif input == 'x'
      return
    else
      problem_menu(id)
    end
  end

  def search_menu
    print "search: "

    search_terms = gets.strip

    @as.search(search_terms)
  end

end

end
