module ProjectEulerCli

class ArchiveViewer

  def initialize
    lookup_totals

    @visited_pages = []
    @recent = Array.new(10, "")
    @problems = Array.new(@num_problems, "")
  end

  def get_page_from_problem_id(id)
    id / 50 + 1
  end

  def lookup_totals
    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    id_col = fragment.css('#problems_table td.id_column')

    # The newest problem is the first one listed on the recent page. The ID of this
    # problem will always equal the total number of problems.
    @num_problems = id_col.first.text.to_i
    # The last problem on the recent page has an ID that is one larger than the
    # last problem in the archive pages. The total number of pages can be calculated
    # from its ID.
    @num_pages = get_page_from_problem_id(id_col.last.text.to_i - 1)
  end

  def load_recent
    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    i = @num_problems + 1

    problem_links.each do |link|
      @problems[i -= 1] = link.text
    end
  end

  def display_recent
    if @recent[0] == ""
      load_recent
    end

    init_index = @num_problems
    init_index.downto(init_index - 9) do |i|
      puts "#{i} - #{@problems[i]}"
    end

    puts
    display_recent_menu
  end

  def display_recent_menu
    puts "Enter ID to view problem"
    puts "e(x)it"
    print "e: "

    input = gets.strip

    if input.to_i.between?(@num_problems, @num_problems - 9)
      display_problem(input.to_i)
    elsif input == 'x'
      return
    else
      display_recent_menu
    end
  end

  def load_page(page_num)
    html = open("https://projecteuler.net/archives;page=#{page_num}")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    i = (page_num - 1) * 50

    problem_links.each do |link|
      @problems[i += 1] = link.text
    end

    @visited_pages << page_num
  end

  def display_page(page_num)
    page_num = [1, page_num, @num_pages].sort[1] #clamp

    unless @visited_pages.include?(page_num)
      load_page(page_num)
    end

    init_index = (page_num - 1) * 50 + 1

    for i in init_index...init_index + 50
      puts "#{i} - #{@problems[i]}"
    end

    puts
    display_page_menu(page_num)
  end

  def display_page_menu(cur_page)
    puts "[#{cur_page}/#{@num_pages}] Enter ID to view problem"
    puts "(n)ext (p)rev (g)oto e(x)it"
    print "e: "

    input = gets.strip

    if input.to_i.between?(1, @num_pages)
      display_problem(input.to_i)
    elsif input == 'n'
      display_page(cur_page + 1)
    elsif input == 'p'
      display_page(cur_page - 1)
    elsif input.start_with?('g')
      display_page(input.gsub('g', '').to_i)
    elsif input == 'x'
      return
    else
      display_page_menu(cur_page)
    end
  end

  def display_problem(id)
    puts id
  end

end

end
