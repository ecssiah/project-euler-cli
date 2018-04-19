module ProjectEulerCli

class ArchiveViewer

  def initialize(archive_data)
    @archive_data = archive_data
  end

  def load_recent
    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    problem_links.each do |link|
      @archive_data[:problems].insert(@archive_data[:num_problems] - 9, link.text)
    end

    @archive_data[:visited_pages] << 0
  end

  def display_recent
    load_recent unless @archive_data[:visited_pages].include?(0)

    puts

    (@archive_data[:num_problems]).downto(@archive_data[:num_problems] - 9) do |i|
      puts "#{i} - #{@archive_data[:problems][i]}"
    end
  end

  def load_page(page_num)
    html = open("https://projecteuler.net/archives;page=#{page_num}")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    i = (page_num - 1) * 50
    problem_links.each { |link| @archive_data[:problems][i += 1] = link.text }

    @archive_data[:visited_pages] << page_num
  end

  def display_page(page_num)
    page_num = [1, page_num, @archive_data[:num_pages]].sort[1] #clamp
    load_page(page_num) unless @archive_data[:visited_pages].include?(page_num)

    puts

    init_index = (page_num - 1) * 50 + 1
    for i in init_index...init_index + 50
      puts "#{i} - #{@archive_data[:problems][i]}" unless i > @archive_data[:num_problems] - 10
    end
  end

  def load_problem_details(id)
    html = open("https://projecteuler.net/problem=#{id}")
    fragment = Nokogiri::HTML(html)

    problem_info = fragment.css('div#problem_info span span')

    details = problem_info.text.split(';')
    @archive_data[:problem_details][id][:published] = details[0].strip
    @archive_data[:problem_details][id][:solved_by] = details[1].strip

    # recent problems do not have a difficult rating
    unless id >= @archive_data[:num_problems] - 9
      @archive_data[:problem_details][id][:difficulty] = details[2].strip
    end
  end

  def display_problem(id)
    load_problem_details(id) if @archive_data[:problem_details][id].empty?

    puts
    puts "#{@archive_data[:problems][id]}".upcase
    puts "Problem #{id}"
    puts
    puts @archive_data[:problem_details][id][:published]
    puts @archive_data[:problem_details][id][:solved_by]
    puts @archive_data[:problem_details][id][:difficulty] unless id >= @archive_data[:num_problems] - 9
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
