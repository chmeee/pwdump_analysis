module PwdumpAnalysis

class Stats
  def initialize(input_file, output_dir)
    @pwds = Array.new

    @pwd_max_length = 0
    @pwd_min_length = 0
    @uid_max_length = 0
    @uid_min_length = 0

    @alpha_cnt      = 0
    @num_cnt        = 0
    @alphanum_cnt   = 0
    @same_id_cnt    = 0
    @found_cnt      = 0

    @pwd_hist = Hash.new
    @uid_hist = Hash.new

    @input_file = input_file
    @output_dir = output_dir

    scan_file
  end

  def scan_file
      @input_file.each do |line|
        pass = Password.new(line)

        @pwds << pass

        @pwd_hist[pass.pwd_length] = (@pwd_hist[pass.pwd_length].nil?) ? 1 : @pwd_hist[pass.pwd_length] + 1
        @uid_hist[pass.uid_length] = (@uid_hist[pass.uid_length].nil?) ? 1 : @uid_hist[pass.uid_length] + 1

        @alpha_cnt      += 1 if pass.is_alpha?
        @num_cnt        += 1 if pass.is_num?
        @alphanum_cnt   += 1 if pass.is_alphanum?
        @same_id_cnt    += 1 if pass.same_id?

        @pwd_max_length = (pass.pwd_length > @pwd_max_length) ? pass.pwd_length : @pwd_max_length
        @pwd_min_length = (pass.pwd_length < @pwd_min_length) ? pass.pwd_length : @pwd_min_length
        @uid_max_length = (pass.uid_length > @uid_max_length) ? pass.uid_length : @uid_max_length
        @uid_min_length = (pass.uid_length < @uid_min_length) ? pass.uid_length : @uid_min_length

        @found_cnt += 1 if pass.decrypted?
      end

  end

  def print_stats
    puts "-------[ PWDUMP analysis ]-------"
    print_one_stat "Found",       @found_cnt
    print_one_stat "Not found",   @pwds.length - @found_cnt
    print_one_stat "Total",       @pwds.length
    puts "---------------------------------"
    print_one_stat "id == pwd",   @same_id_cnt
    print_one_stat "id != pwd",   @pwds.length - @same_id_cnt
    puts "---------------------------------"
    print_one_stat "Alphabetic",  @alpha_cnt
    print_one_stat "Numeric",     @num_cnt
    print_one_stat "Alphanum",    @alphanum_cnt
    print_one_stat "Other",      @pwds.length - (@alpha_cnt + @num_cnt + @alphanum_cnt)
    puts "---------------------------------"
  end

  def print_one_stat(text, value)
    printf " %-15s %5d\t%6.2f%%\n", text+":", value, value * 100.0 / @pwds.length
  end

  def generate_graphs 
    print "generating graphs..."

    puts  "[DONE]"
  end

  def generate_csv 
    print "generating graphs..."

    puts  "[DONE]"
  end
end

end
