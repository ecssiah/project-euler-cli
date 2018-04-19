module ProjectEulerCli

class ArchiveViewer
  include ArchiveInfo

  def initialize
    lookup_totals

    @visited_pages = []
    @recent = []
    @problems = Array.new(@num_problems - 9, "")
    @problem_details = Array.new(@num_problems + 1, {})

  end

  def load_recent
    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    problem_links.each do |link|
      @problems.insert(@num_problems - 9, link.text)
    end

    @visited_pages << 0
  end

  def display_recent
    load_recent unless @visited_pages.include?(0)

    puts

    (@num_problems).downto(@num_problems - 9) do |i|
      puts "#{i} - #{@problems[i]}"
    end
  end

  def load_page(page_num)
    html = open("https://projecteuler.net/archives;page=#{page_num}")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    i = (page_num - 1) * 50
    problem_links.each { |link| @problems[i += 1] = link.text }

    @visited_pages << page_num
  end

  def display_page(page_num)
    page_num = [1, page_num, @num_pages].sort[1] #clamp
    load_page(page_num) unless @visited_pages.include?(page_num)

    puts

    init_index = (page_num - 1) * 50 + 1
    for i in init_index...init_index + 50
      puts "#{i} - #{@problems[i]}" unless i > @num_problems - 10
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
    load_problem_details(id) if @problem_details[id].empty?

    puts

    if id > @num_problems - 10
      puts "#{@recent[@num_problems - id]}".upcase
    else
      puts "#{@problems[id]}".upcase
    end

    puts "Problem #{id}"
    puts
    puts @problem_details[id][:published]
    puts @problem_details[id][:solved_by]
    puts @problem_details[id][:difficulty] unless id > @num_problems - 10
    puts
    puts "https://projecteuler.net/problem=#{id}"
  end

  def display_results(results, keywords)
    puts

    results.each do |result|
      puts "#{result} - #{keywords[result - 1]} "
    end
  end

end

end
