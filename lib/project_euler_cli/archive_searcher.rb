module ProjectEulerCli

class ArchiveSearcher
  attr_reader :results
  attr_accessor :searching

  def initialize(archive_data)
    @archive_data = archive_data

    @results = []
    @searching = false
    @initial_search = true
  end

  def load_terms
    puts "updating keywords..."

    (1..@archive_data[:num_pages]).each do |page|
      unless @archive_data[:visited_pages].include?(page)
        html = open("https://projecteuler.net/archives;page=#{page}")
        fragment = Nokogiri::HTML(html)

        problem_links = fragment.css('#problems_table td a')

        i = (page - 1) * 50 - 1
        problem_links.each do |link|
          @archive_data[:problems][i += 1] = link.text
        end
      end
    end

    unless @archive_data[:visited_pages].include?(0)
      html = open("https://projecteuler.net/recent")
      fragment = Nokogiri::HTML(html)

      problem_links = fragment.css('#problems_table td a')

      i = @archive_data[:num_problems]
      problem_links.each do |link|
        @archive_data[:problems][i -= 1] = link.text
      end
    end
  end

  def search(terms)
    if @initial_search
      @initial_search = false
      load_terms
    end

    puts "searching..."
    @searching = true

    @results.clear
    terms_arr = terms.downcase.split(' ')

    @archive_data[:problems].each.with_index do |string, i|
      terms_arr.each do |term|
        @results << i if string.include?(term.downcase)
      end
    end
  end

end

end
