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
    @pwds.find { |p| p.uid == uid }
  end

  def []=(uid, pwd)
    @pwds.map! do |p|
      p = (p.uid == uid) ? pwd : p
    end 
  end

  def each
    @pwds.each do |p|
      yield p
    end
  end

  def count
    @pwds.length
  end

  def to_file(file)
    if file.is_a?(String)
      file = open(file, "w")
    end
    @pwds.each { |p| file.puts p }
  end

  def merge(nf_pwdump, verbose)
    nf_pwdump.each do |nf_pwd|
      self[nf_pwd.uid] = nf_pwd if nf_pwd.correct_pwd?
      puts "#{nf_pwd.uid} #{nf_pwd.pwd.empty? ? "*"*8 : nf_pwd.pwd} #{nf_pwd.correct_pwd? ? "[OK]" : "[NO]"}" if verbose
    end
  end

end

end
