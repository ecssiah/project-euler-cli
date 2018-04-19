module ProjectEulerCli

class CLI

  def initialize
    @ac = ArchiveController.new
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
    @ac.av.display_recent

    puts
    puts "e(x)it"

    input = prompt

    if input.to_i.between?(@ac.num_problems - 9, @ac.num_problems)
      problem_menu(input.to_i)
    elsif input == 'x'
      return
    else
      recent_menu
    end
  end

  def page_menu(page_num)
    @ac.av.display_page(page_num)

    puts
    puts "[#{page_num}/#{@ac.num_pages}] (n)ext (p)rev (g)oto e(x)it"

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
    @ac.av.display_problem(id)

    puts
    puts "(b)ack e(x)it"

    input = prompt

    if input == 'b'
      if @ac.as.searching
        search_results_menu
      else
        page = @ac.get_page_from_problem_id(id)
        page == 0 ? recent_menu : page_menu(page)
      end
    elsif input == 'x'
      return
    else
      problem_menu(id)
    end
  end

  def search_results_menu
    @ac.av.display_results(@ac.as.results)

    puts
    puts "(s)earch e(x)it"

    input = prompt

    if @ac.as.results.include?(input.to_i)
      problem_menu(input.to_i)
    elsif input == 's'
      search_menu
    elsif input == 'x'
      @ac.as.searching = false
      return
    else
      search_results_menu
    end
  end

  def search_menu
    print "search: "

    search_terms = gets.strip
    @ac.as.search(search_terms)
    search_results_menu
  end

end

end
