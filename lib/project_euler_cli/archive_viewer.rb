module ProjectEulerCli

# Handles the work of displaying information about the problems.
class ArchiveViewer

  def initialize(archive_data)
    @archive_data = archive_data
  end

  # Loads in all of the problem numbers and titles from the recent page.
  def load_recent
    html = open("https://projecteuler.net/recent")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    problem_links.each do |link|
      @archive_data[:problems].insert(@archive_data[:num_problems] - 9, link.text)
    end

    @archive_data[:visited_pages] << 0
  end

  # Displays the 10 most recently added problems.
  def display_recent
    load_recent unless @archive_data[:visited_pages].include?(0)

    puts

    (@archive_data[:num_problems]).downto(@archive_data[:num_problems] - 9) do |i|
      puts "#{i} - #{@archive_data[:problems][i]}"
    end
  end

  # Loads the problem numbers and titles for an individual page of the archive.
  def load_page(page)
    html = open("https://projecteuler.net/archives;page=#{page}")
    fragment = Nokogiri::HTML(html)

    problem_links = fragment.css('#problems_table td a')

    i = (page - 1) * 50 + 1
    problem_links.each do |link|
      @archive_data[:problems][i] = link.text
      i += 1
    end

    @archive_data[:visited_pages] << page
  end

  # Displays the problem numbers and titles for an individual page of the archive.
  def display_page(page)
    page = [1, page, @archive_data[:num_pages]].sort[1] #clamp
    load_page(page) unless @archive_data[:visited_pages].include?(page)

    puts

    start = (page - 1) * 50 + 1
    for i in start...start + 50
      unless i >= @archive_data[:num_problems] - 9
        puts "#{i} - #{@archive_data[:problems][i]}"
      end
    end
  end

  # Loads the details of an individual problem.
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

  # Displays the details of an individual problem.
  #
  # * +id+ - ID of the problem to be displayed
  def display_problem(id)
    load_problem_details(id) if @archive_data[:problem_details][id].empty?

    puts
    puts "#{@archive_data[:problems][id]}".upcase
    puts "Problem #{id}"
    puts
    puts @archive_data[:problem_details][id][:published]
    puts @archive_data[:problem_details][id][:solved_by]

    if id < @archive_data[:num_problems] - 9
      puts @archive_data[:problem_details][id][:difficulty]
    end

    puts
    puts "https://projecteuler.net/problem=#{id}"
  end

  # Displays a custom page of problems given by an array of IDs.
  #
  # * +list+ - Array of problem IDs
  def display_custom_page(list)
    puts

    list.each do |id|
      puts "#{id} - #{@archive_data[:problems][id]}"
    end
  end

end

end
