EModule
=======

EModule (Emacs Module) - is a small add-on to Emacs that helps manage personal
configuration by splitting it into manageable modules.  It goes beyond simply
splitting configuration across multiple files by also managing the installation
and removal of packages.

This was inspired by Spacemacs' automatic package management with layers.
However, adding additional configuration to an existing layer, or creating a
new layer required some ramp-up in how they work.  By developing something
simpler, the hope was to have something close in simplicity to just writing a
basic init file, with the additional benefit of automatic package installation
and removal.

Usage
-----

Import the package:

::

   (add-to-list 'load-path "~/.emacs.d/emodule")
   (require 'emodule)

Define one or more modules in the modules directory (by default
``~/.emacs.d/modules``).  The module ``MODULE``, is expected to be defined in a
file called ``MODULE.el`` which will define the list of required packages in
``emodule/MODULE-packages`` and any accompanying initialisation in the function
``emodule/MODULE-init``.

Now simply invoke the ``emodule/init`` function from your main init file

::

   (emodule/init '(MODULE
                   ...))

Which will install all the required packages (including all dependencies),
remove any packages that are no longer required (i.e. packages that are no
longer explicitly listed as required and are not a dependency of some other
required package), and invoke all the initialisation functions.

There is also ``emodule/init-debug``, which will skip installing/removing
packages so you can comment out modules to help you in debugging your init
file.
