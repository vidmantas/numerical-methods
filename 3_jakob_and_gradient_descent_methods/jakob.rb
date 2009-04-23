#!/usr/bin/ruby19
require 'optparse'
require 'matrix'
require 'function'

class Matrix
  # norma
  def rate
    rows_sums = []
    self.row_size.times do |ri|
      sum = 0
      self.column_size.times do |ci|
        sum += self.[](ri, ci)
      end
      rows_sums << sum
    end
    
    rows_sums.max
  end
end

class JakobMethod
  def initialize(args)
    @options = { folder: "matrices1", epsilon: 0.0001 }
    OptionParser.new do |opts|
      opts.banner = "Usage: jakob.rb [options]"
      opts.on("-e", "--epsilon E", Float, "Define epsilon (accuracy)") do |e|
        @options[:epsilon] = e
      end
      
      opts.on("-f", "--folder F", "Folder where data is located") do |f|
        @options[:folder] = f
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end.parse!
  end
  
  def build_matrices
    matrix = []
    File.read("#{@options[:folder]}/a.txt").split("\n").each do |line|
      matrix << line.split(" ").map(&:to_f)
    end
    b = File.read("#{@options[:folder]}/b.txt").split("\n").map(&:to_f)

    @matrix_A = Matrix.rows(matrix)
    @matrix_B = Matrix.rows(b.zip)

    @system = []
    matrix.each_with_index do |row, index|  
      function_items = []
      row.each_with_index do |r, i| 
        function_items << "(-1)*#{r}*X[#{i+1}]" unless index == i
      end 
      @system << Function.new("(#{function_items.join(" + ")} + #{b[index]}) / #{row[index]}")
    end
    
    @rows_count = @matrix_B.row_size
  end
  
  def print_header
    print "# \t "
    @rows_count.times { |i| print "x#{i+1}".center(20) }
    print "Paklaida".center(25)
    print "Netiktis".center(25)
    puts
  end
  
  def print_result_line(iteration, result, last_results, netiktis)
    print "#{iteration+1} \t "
    @rows_count.times { |i| print "#{result.[](i, 0)}".center(20) }
    print (result - Matrix.rows(last_results.zip)).rate.to_s.center(25)
    print "#{netiktis}".center(25)
    puts
  end
  
  def solve
    build_matrices
    print_header

    last_results = []
    @rows_count.times { last_results << 0 }

    iteration = 0
    while true do
      result_arr = []
      @rows_count.times do |i|
        result_arr << @system[i].value(last_results)
      end
      
      result = Matrix.rows(result_arr.zip)
      netiktis = ((@matrix_A * result) - @matrix_B).rate
      print_result_line(iteration, result, last_results, netiktis)
      
      iteration += 1
      break if netiktis < @options[:epsilon] || iteration > 10_000
      last_results = result_arr.dup
    end 
  end
end

JakobMethod.new(ARGV).solve
