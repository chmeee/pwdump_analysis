# PWDUMP Analysis #

This is a tool to extract information from pwdump-style files from Windows after
being cracked with [ophcrack][1]

  [1]: http://ophcrack.sourceforge.net

pwdump_analysis generates a text output with statistics about the found
passwords. Optionally it can create several graphs and output a CSV file to
process it with a spreadsheet. 

## Requirements ##

You will need, at least, [ChartDirector for ruby][2] (to create the graphs) and
[Trollop][3] (for the command-line options).

  [2]: http://www.advsofteng.com/cdruby.html
  [3]: http://trollop.rubyforge.org/

Note that this script does not require rubygems, as you may not be using it. If
you do you'll have to tell ruby so. The best way I think is through 

    export RUBYOPT="rubygems"

## Example ##

Output

    -------[ PWDUMP analysis ]-------
    Found:            976   96.83%
    Not found:         32    3.17%
    Total:           1008
    ---------------------------------
    id == pwd:        618   63.32%
    id != pwd:        358   36.68%
    ---------------------------------
    Alphabetic:       755   77.36%
    Numeric:           56    5.74%
    Alphanum:         163   16.70%
    Other:              2    0.20%
    ---------------------------------
    Max uid length:    20
    Min uid length:     3
    Max pwd length:    14
    Min pwd length:     4
    Mean pwd length:    7.23
    ---------------------------------


## TODO ##

* Re-factor pwd_stats_chart [DONE]
* Change default colors of charts
* Add CSV output
* Create a rubygem
* Change hash password generation and include LM hash also
* Add capability to check certain passwords for certain users from a crafted
file
* Add comments!!!
