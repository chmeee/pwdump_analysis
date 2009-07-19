# PWDUMP Analysis #

This is a tool to extract information from pwdump-style files from Windows after
being cracked with [ophcrack][1]. You can generate this kind of file using tools
like pwdump[2] or fgdump[3].

  [1]: http://ophcrack.sourceforge.net
  [2]: http://
  [3]: http://

`pwdump_analysis` generates a text output with statistics about the found
passwords. Optionally it can create several graphs and output a CSV file to
process it with a spreadsheet. 

You can also list the _not found_ passwords in a different file, edit it, add
your guesses, and add them to the ophcrack file in the case they are correct
using `pwdump_analysis` with `--not-found` option.

## Requirements ##

You will need, at least, [ChartDirector for ruby][2] (to create the graphs) and
[Trollop][3] (for the command-line options).

  [2]: http://www.advsofteng.com/cdruby.html
  [3]: http://trollop.rubyforge.org/

Note that this script does not require rubygems, as you may not be using it. If
you do you'll have to tell ruby so. The best way I think is through 

    export RUBYOPT="rubygems"

## Usage ##

### Help ###

    Options:
          --input, -i <s>:   input file (default: STDIN)
         --output, -o <s>:   output directory (default: pwd)
             --graphs, -g:   generate graphs
                --csv, -c:   generate CSV
        --nt-hash, -n <s>:   generate hash from string
      --not-found, -t <s>:   file with passwords not found, with guesses
             --modify, -m:   modifies the original file if :not_found, otherwise
                             creates a file with -new
            --verbose, -v:   prints more information
            --list-nf, -l:   list not found passwords
               --help, -h:   Show this message


### Simple usage ###

To get the statistics from your cracked pwdump file from ophcrack-like apps, you
simply do:

    pwdump_analysis -i passwords_file.oph

This will give you an statistics output on the console (see **Example** below).

You can also send the file on the standard input like this:

    pwdump_analysis < passwords_file.oph

Or this:

    cat passwords_file1.oph password_file2.oph | pwdump_analysis

This last one would be one of the useless uses of cat[4], so be sure to use more
than one file :).

  [4]: http:// 

### Charts ###

To generate charts you add the `-g` switch, like this:

    pwdump_analysis -i passwords_file.oph -g

If you want them to be saved in a different directory you can use the `-o`
switch and provide it.

At the moment it will generate two charts:

* **uid_pwd_length**: a histogram of uid and password lengths
* **pwd_stats**: a multiple horizontal bar charts on found passwords
characteristics

### CSV ###

In the case you don't like my charts or that you want to mess with the password
data, you can generate CSV files with the `-c` switch, like this:

    pwdump_analysis -i passwords_file.oph -c

If you want them to be saved in a different directory you can use the `-o`
switch and provide it.

At the moment it will generate two files:

* **uid_pwd_length**: a histogram of uid and password lengths
* **pwd_stats**: the same data from the stats output in CSV style (no percents)

### Generating individual NT hashes ###

For passwords not guessed by the cracking program but that you think you know
it, you can generate the NT hash to compare them manually, like this:

    $ pwdump_analysis -n worlds_end_inn
    098118D67EC42EF2E6DB1D53EDFAA5DA

### Adding guesses ###

If you want to provided guesses for the passwords not guessed by the cracking
app, you can do the following:

    $ pwdump_analysis -i passwords_file.oph -l
    $ vim passwords_file.oph-not_found

     ... add the passwords you think you can guess, you can delete the rest ...

    $ pwdump_analysis -i passwords_file.oph -t passwords_file.oph-not_found

The `-l` switch generates a file + `-not_found` from the original input file
with the not guessed passwords. In the case that input is the standard input,
the not guessed passwords will go to the standard output.

The last command will generate a new stats output considering the guessed
passwords if they were right. You can also add other switches like `-g` or `-c`
to generate the new charts and CSV files.

If you provide the `-m` switch, it will modify the original `password_file.oph`,
otherwise it will create a new file with `-new` at the end.

If you want to see the result of checking your guesses, you can provide the `-v`
switch and you will get the list with '[OK]' or '[NO]' depending on the result.

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
* Add CSV output [DONE]
* Create a rubygem
* Change hash password generation and include LM hash also
* Add capability to check certain passwords for certain users from a crafted
file [DONE]
* Add capability to list not_found passwords [DONE]
* Add comments!!!
