# Emacs Bedrock

Stepping stones to a better Emacs experience

**NOTICE:** This is a placeholder repository for people who like to start things on GitHub. See the [project homepage](https://codeberg.org/ashton314/emacs-bedrock) for the source.

## Synopsis

An *extremely* minimal Emacs starter kit uses just one external package by default, and only GNU-ELPA packages on an opt-in basis. Intended to be copied once and then modified as the user grows in knowledge and power.

 - [Project homepage](https://codeberg.org/ashton314/emacs-bedrock)

## Changelog

 - Development

   Change magit keybinding to standard `C-x g`; drop non-standard ones. (Thanks Vincent Conus!)

 - 1.2.0

   2023-09-21

   Add packages [Cape](https://github.com/minad/cape) (+ basic configuration) and wgrep. Add a binding for `consult-ripgrep`.

 - 1.1.0
 
   2023-09-08
   
   Rename "mixins" → "extras", as mixin has the flavor of being some kind of special thingy. "Extra" gets at the purpose of these files.

 - 1.0.0
 
   2023-09-04
   
   First "stable" release! Line number width improved, fix default load paths, expand Eglot and Vertico config, fix Corfu load.

 - 0.2.1

   2023-06-20
   
   Minor bug fixes; add Embark package.

 - 0.2.0
 
   2023-03-14
   
   Flesh out the `mixin/vim-like.el` so that there's *some* Vim configuration.

 - 0.1.0
 
   2023-01-17
   
   Begin work on `mixin/org.el`, turn on windmove-mode.

 - 0.0.2

   2023-01-03

   Reorganize to slim down `early-init.el` and add the first mixin files.

 - 0.0.1

   2023-01-03
 
   Initial "release".

## Authors

Creator and maintainer:

 - Ashton Wiersdorf https://lambdaland.org

Contributors:

 - George Kettleborough
 - Enzo Do Rosario
 - Ed Singleton
 - Vincent Conus
