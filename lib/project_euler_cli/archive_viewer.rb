module ProjectEulerCli

class ArchiveViewer
  attr_reader :num_problems, :num_pages

  def initialize
    lookup_totals

    @visited_pages = []
    @recent = []
    @problems = Array.new(@num_problems, "")
    @problem_details = Array.new(@num_problems, {})
  end

  # Recent page is considered page 0, invalid pages return -1
  def get_page_from_problem_id(id)
    if id.between?(@num_problems - 9, @num_problems)
      0
    elsif id.between?(1, @num_problems - 10)
      (id - 1)/ 50 + 1
    else
      -1
    end
  end

  # Dynamically looking up the total number of problems and the page count will
  # allow the application to continue working after new problems and pages are
  # added to the archive
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

    problem_links.each do |link|
      @recent.unshift(link.text)
    end
  end

  def display_recent
    load_recent if @recent.empty?

    index = @num_problems + 1

    @recent.each do |problem|
      puts "#{index -= 1} - #{problem}"
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

    load_page(page_num) unless @visited_pages.include?(page_num)

    init_index = (page_num - 1) * 50 + 1

    for i in init_index...init_index + 50
      puts "#{i} - #{@problems[i]}"
    end
  end

  def load_problem_details(id)
    html = open("https://projecteuler.net/problem=#{id}")
    fragment = Nokogiri::HTML(html)

    problem_info = fragment.css('div#problem_info span span')
    details = problem_info.text.split(';')
    @problem_details[id][:published] = details[0].strip
    @problem_details[id][:solved_by] = details[1].strip

    # recent problems do not have a difficult rating
    if details.size > 2
      @problem_details[id][:difficulty] = details[2].strip
    end
  end

  def display_problem(id)
    puts

    if id > @num_problems - 10
      puts "#{@recent[@num_problems - id]}".upcase
    else
      puts "#{@problems[id]}".upcase
    end

    puts "Problem #{id}"
    puts

    load_problem_details(id) if @problem_details[id].empty?

    puts @problem_details[id][:published]
    puts @problem_details[id][:solved_by]
    puts @problem_details[id][:difficulty] unless id > @num_problems - 10
    puts
    puts "https://projecteuler.net/problem=#{id}"
  end

end

end
