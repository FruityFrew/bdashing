# [bd]ashing

An ever increasing set of ✨dashing✨ bash scripts for absolutelly random utilities.

## Table of Contents
* [git-tree](#git-tree)
* [grab](#grab)
* [clean-repeats](#clean-repeats)




## git-tree

Shows the tree structure of a git repository. The name of of files is followed
by counts for line changes for every file that has been edited.

Usage:
```
git-tree                # show repo-tree in current locaiton
git-tree <location>     # show repo-tree in a given location
```

## grab

Grabs lines from a given file and stores those in a clipboard. I tend to use it 
when I am inside of `neovim` and need to jump to anotehr program.

Usage:
```
grab <file-name>        # copy entire file
grab <file-name> x      # copy line x from file
grab <file-name> x y    # copy lines to y (inclusive ranges) 
```

## clean-repeats

Tool used to remove duplicate files from system.

Usage:
```
clean-repeats               # remove duplicate files in current directory
clean-repeats <location>    # remove duplicate files in a given location
```
