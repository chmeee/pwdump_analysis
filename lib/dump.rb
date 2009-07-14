module PwdumpAnalysis

class Dump
  include Enumerable

  def initialize(input_file)
    @pwds = Array.new
    scan_file(input_file)
  end

  def scan_file(input_file)
    input_file.each do |line|
      pass = Password.new(line)
      @pwds << pass
    end
  end

  def [](uid)
    @pwds.find { |p| p.uid = uid }
  end

  def each
    @pwds.each do |p|
      yield p
    end
  end

  def count
    @pwds.length
  end

end

end
