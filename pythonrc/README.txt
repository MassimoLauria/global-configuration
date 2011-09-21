
The following files are used to initialize python shell environments.

- pythonrc.py (CPython interpreter)

  It is the  file loaded at startup by the  regular python shell. It's
  location is either in ~/.pythonrc.py,  in a path defined by PYTHONSTARTUP
  env variable.

  See man python(1)





- ipython_config.py (ipython >= 0.11)
- ipython_qtconsole_config.py (ipython >= 0.11)

  Since ipython  0.11 more features are in  configuration files. These
  are  configuration  for  "default"  profile  in  both  terminal  and
  qtconsole command line.

  Located in IPYTHONDIR/profile_default/


- matplotlibrc (MISSING)

  Configuration file for the  python mathematical plot library.  It is
  activated  and confgured  by  default when  ipython  is called  with
  '-pylab' option.

  Loading path order is (1) current dir (2) .matplotlib/matplotlibrc

  See http://matplotlib.sourceforge.net/users/customizing.html



OLDER IPYTHON'S


- ipythonrc (ipython <= 0.9, MISSING)

  Initial file to  configure ipython shell. It is  not a full featured
  python  file.    It's  location  is  either  (1)   current  dir  (2)
  IPYTHONDIR.

  Ipython 0.9 is still used in Sagemath.



- ipy_user_conf.py (ipython 0.10)

  Full featured configuration python program for ipython up to version
  0.10 . Located in IPYTHONDIR.

  Ipython 0.10 is default in Ubuntu 11.04
