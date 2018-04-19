module ProjectEulerCli

class ArchiveSearcher
  attr_accessor :keywords, :results

  def initialize
    @initial_search = true
    @results = []
    @keywords = []
  end

  def load_terms
    puts "updating keywords..."

    # test data
    @keywords[0] = "Multiples of 3 and 5"
    @keywords[1] = "Even Fibonacci numbers"
    @keywords[2] = "Largest prime factor"
    @keywords[3] = "Largest palindrome product"
    @keywords[4] = "Smallest multiple"
    @keywords[5] = "Sum square difference"
    @keywords[6] = "10001st prime"
    @keywords[7] = "Largest product in a series"
    @keywords[8] = "Special Pythagorean triplet"
    @keywords[9] = "Summation of primes"
    @keywords[10] = "Largest product in a grid"
    @keywords[11] = "Highly divisible triangular number"
    @keywords[12] = "Large sum"
    @keywords[13] = "Longest Collatz sequence"
    @keywords[14] = "Lattice paths"
    @keywords[15] = "Power digit sum"
    @keywords[16] = "Number letter counts"
    @keywords[17] = "Maximum path sum I"
    @keywords[18] = "Counting Sundays"
    @keywords[19] = "Factorial digit sum"

    @keywords.each { |string| string.downcase }
  end

  def search(term)
    puts "searching..."

    @results.clear
    term.downcase

    if @initial_search
      @initial_search = false
      load_terms
    end

    @keywords.each.with_index do |string, i|
      @results << i + 1 if string.include?(term)
    end
  end


  def test_output
    @results.each do |result|
      puts "#{result} - #{@keywords[result - 1]}"
    end
  end

end

end
