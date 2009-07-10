module PwdumpAnalysis

class Password
  def initialize(line)
    @uid     = ""
    @lm_hash = ""
    @nt_hash = ""
    @lm_pwd  = Array.new
    @nt_pwd  = ""

    @uid, id, @lm_hash, @nt_hash, @lm_pwd[0], @lm_pwd[1], @nt_pwd = line.split(':')
    @nt_pwd.chomp!
  end

  def is_alpha?
    @nt_pwd ~ /[a-zñA-ZÑ]+/
  end

  def is_num?
    @nt_pwd ~ /[0-9]+/
  end

  def is_alphanum?
    @nt_pwd ~ /[a-zñA-ZÑ0-9]+/
  end

  def pwd_length
    @nt_pwd.length
  end

  def uid_length
    @uid.length
  end

  def decrypted?
    ! @nt_pwd.empty?
  end

end

end
