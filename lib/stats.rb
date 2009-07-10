module PwdumpAnalysis

class Stats
  def initialize(input_file, output_dir)
    @pwd_max_length = 0
    @pwd_min_length = 0
    @uid_max_length = 0
    @uid_min_length = 0

    @alpha_count    = 0
    @num_count      = 0
    @alphanum_count = 0

    @input_file = input_file
    @output_dir = output_dir

    scan_file(input_file)
  end

  def scan_file
    

  end

  def print_stats

  end

  def create_graphs 

  end
end

end
