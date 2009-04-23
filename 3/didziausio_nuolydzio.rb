#!/usr/bin/ruby19
require 'optparse'
require 'matrix'

class Matrix
  def simetric?
    self.t == self
  end
end

class DidziausioNuolydzio
  def initialize(args)
    @options = { folder: "variantas2", epsilon: 0.0001 }
    OptionParser.new do |opts|
      opts.banner = "Usage: didziausio_nuolydzio.rb [options]"
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
    @options[:epsilon] = @options[:epsilon]**2
  end
  
  def build_matrices
    matrix = []
    File.read("#{@options[:folder]}/a.txt").split("\n").each do |line|
      matrix << line.split(" ").map(&:to_f)
    end
    b = File.read("#{@options[:folder]}/b.txt").split("\n").map(&:to_f)

    @matrix_A = Matrix.rows(matrix)
    @matrix_B = Matrix.rows(b.zip)

    @rows_count = @matrix_B.row_size
    
    unless @matrix_A.simetric?
      puts "Matrica nera simetrine, ar testi skaiciavimus?"
      if gets.chomp == "n"
        exit
      end
    end
  end
  
  def print_header
    print "# \t "
    @rows_count.times { |i| print "x#{i+1}".center(20) }
    print "Paklaida".center(25)
    puts
  end
  
  def print_result_line(iteration, result, accuracy)
    print "#{iteration+1} \t "
    @rows_count.times { |i| print "#{result.[](i, 0)}".center(20) }
    print accuracy.to_s.center(25)
    puts
  end
  
  def solve
    build_matrices
    print_header
    
    z = []
    zz = []
    result_arr = []
    @rows_count.times { result_arr << 0 }
    
    iteration = 0
    while true do
      z[iteration] = @matrix_A * Matrix.rows(result_arr.zip) - @matrix_B      
      zz[iteration] = (z[iteration].t * z[iteration]).[](0, 0)
      
      r = @matrix_A * z[iteration]
      t = zz[iteration].to_f / (r.t * z[iteration]).[](0, 0)
      
      answer = Matrix.rows(result_arr.zip) - t * z[iteration]
      z[iteration+1] = z[iteration] - t * r
      
      accuracy = (z[iteration+1].t * z[iteration+1]).[](0, 0)
      print_result_line(iteration, answer, accuracy)      
      
      iteration += 1
      break if accuracy < @options[:epsilon] or iteration > 10_000
      result_arr = answer.to_a.flatten
    end
  end
end

DidziausioNuolydzio.new(ARGV).solve
