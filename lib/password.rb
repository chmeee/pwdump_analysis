module PwdumpAnalysis

class Password
  def initialize(line)
    @uid     = ""
    @lm_hash = ""
    @nt_hash = ""
    @lm_pwd  = Array.new
    @nt_pwd  = ""

    @uid, id, @lm_hash, @nt_hash, @lm_pwd[0], @lm_pwd[1], @nt_pwd = line.split(':')
  end

  def is_alpha?
  # nt_pwd

  end

  def is_num?

  end

  def is_alphanum?

  end

  def pwd_length

  end

  def uid_length

  end

end

end
