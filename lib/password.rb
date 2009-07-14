module PwdumpAnalysis

class Password
  attr_reader :uid

  def initialize(line)
    @lm_pwd  = Array.new

    @uid, @id, @lm_hash, @nt_hash, @lm_pwd[0], @lm_pwd[1], @nt_pwd = line.split(':')

    if @nt_pwd.nil?
      @nt_pwd = ""
    else
      @nt_pwd.chomp!
    end
  end

  def pwd
    @nt_pwd
  end

  def pwd=(pwd)
    @nt_pwd = pwd
  end

  def is_alpha?
    @nt_pwd =~ /^[a-zñA-ZÑ]+$/
  end

  def is_num?
    @nt_pwd =~ /^[0-9]+$/
  end

  def is_alphanum?
    @nt_pwd =~ /[a-zñA-ZÑ]+/ and @nt_pwd =~ /[0-9]+/ and @nt_pwd !~ /[^a-zñA-ZÑ0-9]+/
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

  def same_id?
    @uid == @nt_pwd
  end

  def to_s
    [@uid, @id, @lm_hash, @nt_hash, @lm_pwd[0], @lm_pwd[1], @nt_pwd].join(':')
  end

end

end
