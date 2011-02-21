
The following files are used to initialize python shell environments.

- pythonrc.py

  It is the  file loaded at startup by the  regular python shell. It's
  location is either in ~/.pythonrc.py,  in a path defined by PYTHONSTARTUP
  env variable.

  See man python(1)

- ipythonrc

  Initial file to  configure ipython shell. It is  not a full featured
  python  file.    It's  location  is  either  (1)   current  dir  (2)
  IPYTHONDIR.


- ipy_user_conf.py

  Full featured  configuration python program for  ipython. Located in
  IPYTHONDIR.


- matplotlibrc

  Configuration file for the  python mathematical plot library.  It is
  activated  and confgured  by  default when  ipython  is called  with
  '-pylab' option.

  Loading path order is (1) current dir (2) .matplotlib/matplotlibrc

  See http://matplotlib.sourceforge.net/users/customizing.html
