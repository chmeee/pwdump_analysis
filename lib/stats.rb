module PwdumpAnalysis

class Stats
  def initialize(input_file, output_dir)
    @pwd_max_length = 0
    @pwd_min_length = 0
    @uid_max_length = 0
    @uid_min_length = 0

    @alpha_cnt      = 0
    @num_cnt        = 0
    @alphanum_cnt   = 0
    @decrypted_cnt  = 0

    @input_file = input_file
    @output_dir = output_dir

    scan_file
  end

  def scan_file
    open(@input_file) do |f|
      f.each do |line|
        pass = Password.new(line)

        @pwd_max_length = (pass.pwd_length > @pwd_max_length) ? pass.pwd_length : @pwd_max_length
        @pwd_min_length = (pass.pwd_length < @pwd_min_length) ? pass.pwd_length : @pwd_min_length
        @uid_max_length = (pass.uid_length > @uid_max_length) ? pass.uid_length : @uid_max_length
        @uid_min_length = (pass.uid_length < @uid_min_length) ? pass.uid_length : @uid_min_length

        @found_cnt += 1 if pass.decrypted?
      end
    end

  end

  def print_stats

  end

  def generate_graphs 

  end

  def generate_csv 

  end
end

end
