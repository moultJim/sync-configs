##zoxide##
  - z foo              # cd into highest ranked directory matching foo
  - z foo bar          # cd into highest ranked directory matching foo and bar
  - z foo /            # cd into a subdirectory starting with foo
  - z ~/foo            # z also works like a regular cd command
  - z foo/             # cd into relative path
  - z ..               # cd one level up
  - z -                # cd into previous directory
  - zi foo             # cd with interactive selection (using fzf)
  - z foo<SPACE><TAB>  # show interactive completions (bash 4.4+/fish/zsh only)


  
