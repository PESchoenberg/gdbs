# gdbs - Guile Database System.


## Overview:

A very simple relational database system based on GNU Guile.


## Dependencies:

* GNU Guile - v3.0.0 or later ( https://www.gnu.org/software/guile/ )

* grsp - v1.1.7 or later ( https://github.com/PESchoenberg/grsp.git )


## Installation:

* Once you have all dependencies installed on your system, get gdbs, unpack 
it into a folder of your choice and cd into it.

* gdbs installs as a GNU Guile library. See GNU Guile's manual instructions for
details concerning your OS and distribution, but as an example, on Ubuntu you
would issue (depending on where you installed Guile):

      sudo mkdir /usr/share/guile/site/3.0/gdbs

      or

      sudo mkdir /usr/local/share/guile/site/3.0/gdbs

      then cd gdbs/src/scheme
      
      and 

      sudo cp *.scm -rv /usr/share/guile/site/3.0/gdbs

      or

      sudo cp *.scm -rv /usr/local/share/guile/site/3.0/gdbs

and that will do the trick.


## Uninstall:

* You just need to remove the gdbs folder (see above) and its subfolders.

* There are no other dependencies.


## Usage:

* Should be used as any other GNU Guile library; programs written with gdbs
should be written and compiled as any regular Guile program.

* See the examples contained in the /examples folder. These are self-explaining
and filled with comments. 

* As a general guide, in order to compile a gdb-based program - say example1.scm:

  * cd into the folder containing the program.

  * enter

    guile example1.scm

    to run it just as any regular GNU Guile program.

* gdbs is heavily based on matrix-related functions found in the grsp library, and
specifically on those founds on the following files:

  * gdbs acts as a top layer over grsp functions.

  * Therefore it is advisable to gain a general idea about those functions, since gdbs
  query language is Scheme itself.
  

## Credits and Sources:

* GNU contributors (2019). GNU's programming and extension language — GNU
Guile. [online] Gnu.org. Available at: https://www.gnu.org/software/guile/
[Accessed 2 Sep. 2019].

* Edronkin, P. (2019). grsp - Useful Scheme functions. [online] grsp.
Available at: https://peschoenberg.github.io/grsp/ [Accessed 26 Aug. 2019].

* URL of this project - https://github.com/PESchoenberg/gdb .

Please let me know if I forgot to add any credits or sources.


## Related reading material:

* TODO.

## License:

* LGPL-3.0-or-later.


