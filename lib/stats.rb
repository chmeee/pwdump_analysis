module PwdumpAnalysis

class Stats
  def initialize(input_file, output_dir)
    @pwds = Array.new

#    @pwd_max_length = 0
#    @pwd_min_length = 0
#    @uid_max_length = 0
#    @uid_min_length = 0

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

        if pass.decrypted?
          @pwd_hist[pass.pwd_length] = (@pwd_hist[pass.pwd_length].nil?) ? 1 : @pwd_hist[pass.pwd_length] + 1
          @uid_hist[pass.uid_length] = (@uid_hist[pass.uid_length].nil?) ? 1 : @uid_hist[pass.uid_length] + 1

          @alpha_cnt      += 1 if pass.is_alpha?
          @num_cnt        += 1 if pass.is_num?
          @alphanum_cnt   += 1 if pass.is_alphanum?
          @same_id_cnt    += 1 if pass.same_id?

          @pwd_max_length = 
            (@pwd_max_length.nil? or pass.pwd_length > @pwd_max_length) ? pass.pwd_length : @pwd_max_length
          @pwd_min_length = 
            (@pwd_min_length.nil? or pass.pwd_length < @pwd_min_length) ? pass.pwd_length : @pwd_min_length
          @uid_max_length = 
            (@uid_max_length.nil? or pass.uid_length > @uid_max_length) ? pass.uid_length : @uid_max_length
          @uid_min_length = 
            (@uid_min_length.nil? or pass.uid_length < @uid_min_length) ? pass.uid_length : @uid_min_length

          @found_cnt += 1
        end
      end

  end

  def print_stats
    puts "-------[ PWDUMP analysis ]-------"
    print_one_stat "Found",           @found_cnt
    print_one_stat "Not found",       @pwds.length - @found_cnt
    print_one_stat "Total",           @pwds.length, false
    puts "---------------------------------"
    print_one_stat "id == pwd",       @same_id_cnt, @found_cnt
    print_one_stat "id != pwd",       @found_cnt - @same_id_cnt, @found_cnt
    puts "---------------------------------"
    print_one_stat "Alphabetic",      @alpha_cnt, @found_cnt
    print_one_stat "Numeric",         @num_cnt, @found_cnt
    print_one_stat "Alphanum",        @alphanum_cnt, @found_cnt
    print_one_stat "Other",           @found_cnt - (@alpha_cnt + @num_cnt + @alphanum_cnt), @found_cnt
    puts "---------------------------------"
    print_one_stat "Max uid length",  @uid_max_length, false
    print_one_stat "Min uid length",  @uid_min_length, false
    print_one_stat "Max pwd length",  @pwd_max_length, false
    print_one_stat "Min pwd length",  @pwd_min_length, false
    puts "---------------------------------"
  end

  def print_one_stat(text, value, total=@pwds.length)
    if total == false
      printf " %-15s %5d\n", text+":", value
    else
      printf " %-15s %5d\t%6.2f%%\n", text+":", value, value * 100.0 / total
    end
  end

  def generate_graphs 
    require 'chartdirector'

    pwd_length_chart
    pwd_stats_chart
  end

  def generate_csv 
    print "generating graphs..."

    puts  "[DONE]"
  end

  def pwd_length_chart
    labels = ([@pwd_min_length, @uid_min_length].min..[@pwd_max_length, @uid_max_length].max).to_a
    uid = labels.map { |e| @uid_hist[e] }
    pwd = labels.map { |e| @pwd_hist[e] }
    
    c_pwd = ChartDirector::XYChart.new(320, 300)
    c_pwd.setPlotArea(50, 0, 250, 255, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent)

    c_pwd.addText(300, 0, "pwd", "timesbi.ttf", 12, 0xa07070).setAlignment(ChartDirector::TopRight)
    pwdLayer = c_pwd.addBarLayer(pwd, 0xf0c0c0)
    c_pwd.swapXY(true)
    pwdLayer.setBarGap(ChartDirector::TouchBar)
    pwdLayer.setBorderColor(ChartDirector::Transparent)
    pwdLayer.setAggregateLabelFormat("{value}")
    pwdLayer.setAggregateLabelStyle().setAlignment(ChartDirector::Right)

    c_pwd.addLineLayer(uid, ChartDirector::Transparent)
    c_pwd.yAxis().setLabelStyle("arialbd.ttf")

    tb = c_pwd.xAxis().setLabels(labels)
    tb.setSize(50, 0)
    tb.setAlignment(ChartDirector::Center)
    tb.setFontStyle("arialbd.ttf")
    c_pwd.xAxis().setTickLength(0)
    
    c_uid = ChartDirector::XYChart.new(280, 300, ChartDirector::Transparent)
    c_uid.setPlotArea(20, 0, 250, 255, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent)

    c_uid.addText(20, 0, "uid", "timesbi.ttf", 12, 0xaaaaff)
    uidLayer = c_uid.addBarLayer(uid, 0xaaaaff)
    c_uid.swapXY(true)
    c_uid.yAxis().setReverse()
    uidLayer.setBarGap(ChartDirector::TouchBar)

    uidLayer.setBorderColor(ChartDirector::Transparent)
    uidLayer.setAggregateLabelFormat("{value}")
    uidLayer.setAggregateLabelStyle().setAlignment(ChartDirector::Right)

    c_uid.addLineLayer(pwd, ChartDirector::Transparent)
    c_uid.yAxis().setLabelStyle("arialbd.ttf")

    m = ChartDirector::MultiChart.new(590, 320)
    m.addTitle("PWDUMP analysis", "arialbi.ttf")
    m.addChart(270, 25, c_pwd)
    m.addChart(0, 25, c_uid)
    m.makeChart("uid_pwd_length.png")
  end
  def pwd_stats_chart
    c_found = ChartDirector::XYChart.new(630, 150)
    c_found.setPlotArea(50, 0, 550, 130, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent)
    c_found.swapXY(true)
    found_layer = c_found.addBarLayer2(ChartDirector::Stack)
    found_layer.addDataSet([@found_cnt], 0xddaa77, "Found")
    found_layer.addDataSet([@pwds.length - @found_cnt], 0xaadd77, "Not found")
    found_layer.setBorderColor(ChartDirector::Transparent)
    found_layer.setDataLabelFormat("{value} ({percent}%)")
    found_layer.setDataLabelStyle().setAlignment(ChartDirector::Center)

    legendBox = c_found.addLegend(540, 10, true, "LiberationSans-Bold.ttf", 8)
    legendBox.setKeyBorder(ChartDirector::Transparent)
    legendBox.setBackground(ChartDirector::Transparent, ChartDirector::Transparent)

#    c_found.yAxis().setColors(ChartDirector::Transparent, ChartDirector::Transparent)
#    c_found.makeChart("pwd_found.png")

    c_same = ChartDirector::XYChart.new(630, 150)
    c_same.setPlotArea(50, 0, 550, 130, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent)
    c_same.swapXY(true)
    same_layer = c_same.addBarLayer2(ChartDirector::Stack)
    same_layer.addDataSet([@same_id_cnt], 0xddaa77, "id == pwd")
    same_layer.addDataSet([@found_cnt - @same_id_cnt], 0xaadd77, "id != pwd")
    same_layer.addDataSet([@pwds.length - @found_cnt], ChartDirector::Transparent)
    same_layer.setBorderColor(ChartDirector::Transparent)
    same_layer.setDataLabelFormat("{value} ({percent}%)")
    same_layer.setDataLabelStyle().setAlignment(ChartDirector::Center)

    legendBox = c_same.addLegend(540, 10, true, "LiberationSans-Bold.ttf", 8)
    legendBox.setKeyBorder(ChartDirector::Transparent)
    legendBox.setBackground(ChartDirector::Transparent, ChartDirector::Transparent)

#    c_same.makeChart("same_id.png")

    c_quality = ChartDirector::XYChart.new(630, 150)
    c_quality.setPlotArea(50, 0, 550, 130, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent,
      ChartDirector::Transparent, ChartDirector::Transparent)
    c_quality.swapXY(true)
    quality_layer = c_quality.addBarLayer2(ChartDirector::Stack)
    quality_layer.addDataSet([@alpha_cnt], 0xddaa77, "Alphabetic")
    quality_layer.addDataSet([@num_cnt], 0xffff99, "Numeric")
    quality_layer.addDataSet([@alphanum_cnt], 0xffff33, "Alphanumeric")
    quality_layer.addDataSet([@found_cnt - (@alpha_cnt + @num_cnt + @alphanum_cnt)], 0xaadd77, "Other")
    quality_layer.addDataSet([@pwds.length - @found_cnt], ChartDirector::Transparent)
    quality_layer.setBorderColor(ChartDirector::Transparent)
    quality_layer.setDataLabelFormat("{value} ({percent}%)")
    quality_layer.setDataLabelStyle().setAlignment(ChartDirector::Center)

    legendBox = c_quality.addLegend(540, 10, true, "LiberationSans-Bold.ttf", 8)
    legendBox.setKeyBorder(ChartDirector::Transparent)
    legendBox.setBackground(ChartDirector::Transparent, ChartDirector::Transparent)
    
#    c_quality.makeChart("pwd_quality.png")

    m = ChartDirector::MultiChart.new(690, 620)
    m.addTitle("PWDUMP analysis", "arialbi.ttf")
    m.addChart(0, 25, c_found)
    m.addChart(0, 225, c_same)
    m.addChart(0, 425, c_quality)
    m.makeChart("pwd_stats.png")
  end
end

end
