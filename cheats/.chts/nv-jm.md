## Keymaps.lua
| Mode| Keys      | Description                           |
|:--- |:---       |:---                                   |
| N   | <ldr>re   | Restart                               |
| N   | <ldr>up   | Update plugins                        |
| I   | jj        | Exit insert mode                      |
| N   | <ldr>d    | Del line w/o yank                     |
| N   | x         | Del char w/o yank                     |
| N   | <ldr>c    | Change char w/o yank                  |
| N   | <ldr>cc   | Change line w/o yank                  |
| N   | <ldr>mj   | Move line down 1                      |
| N   | <ldr>mk   | Move line up 1                        |
| V   | J         | Move lines dwn in vis select          |
| V   | K         | Move lines up in vis select           |
| V   | <         | Unindent and keep select              |
| V   | >         | Indent and keep select                |
| X   | p         | Paste over select w/o losing yank     |
| V   | <ldr>d    | Del select w/o yank                   |
| V   | x         | Del select w/o yank                   |
| V   | <ldr>c    | Change select w/o yank                |
| N   | <C-d>     | Scroll dwn 1/2 pg & center            |
| N   | <C-u>     | Scroll up 1/2 pg & center             |
| N   | H         | Go to non-blank start of line         |
| N   | L         | Go to end of line                     |
| N   | <ldr>sv   | Split window vertically               |
| N   | <ldr>sh   | Split window horizontally             |
| N   | <ldr>s    | Replace cursor word globally          |
| N   | n         | Next search result cursor centered    |
| N   | N         | Previous search result cursor centered|
| N   | <Esc>     | Clear search highlighting             |
| N   | <ldr>w    | Quick save buffer                     |
| N   | <ldr>cx   | Make file executable                  |

## MD filetype Mappings
| Mode | Keys         | Description                      |
|:---  |:---          |:---                              |
| N    | <lldr>tc     | Toggle conceal level             |    
| N    | Q            | Format current paragraph         |
| N    | ]]           | Go to next header                |
| N    | [[           | Go to previous header            |
| N    | <lldr>bl     | Make list item                   |
| N    | <lldr>p      | Preview Markdown with glow       |
| N    | <lldr>mp     | Preview with Glow                |
| N    | <lldr>ta     | Align Markdown table             |
| I    | <lldr>m3     | Insert markdown table-3 skeleton |
| I    | <lldr>m2     | Insert markdown table-2 skeleton |
| I    | <C-j>        | Jump to next table cell          |
| I    | <C-o>        | Add new blank table row below    |

## MiniBasics Added Keymaps
| Keys  | Modes | Description                                   |
|:------|:------|:--------------------------------------------  |
| j     | N, V  | Move down by visible lines with no [count]    |
| k     | N, V  | Move up by visible lines with no [count]      |
| go    | N     | Add [count] empty lines after cursor          |
| gO    | N     | Add [count] empty lines before cursor         |
| gy    | N, V  | Copy to system clipboard                      |
| gp    | N, V  | Paste from system clipboard                   |
| gV    | N     | Visually select latest changed or yanked text |
| g/    | V     | Search inside current visual selection        |
| *     | V     | Search forward for current visual selection   |
| #     | V     | Search backward for current visual selection  |
| <C-s> | N,V,I | Save and go to Normal mode                    |

## mappings: Option_toggle
config.mappings.option_toggle_prefix default is '\'
| Suffix | Toggle                                     |
|:---    |:---                                        |
| `b`    |'background'                                |
| `c`    |'cursorline'                                |
| `C`    |'cursorcolumn'                              |
| `d`    | diagnostic (via vim.diagnostic functions)  |
| `h`    |'hlsearch' (v:hlsearch to be precise)       |
| `i`    |'ignorecase'                                |
| `l`    |'list'                                      |
| `n`    |'number'                                    |
| `r`    |'relativenumber'                            |
| `s`    |'spell'                                     |
| `w`    |'wrap'                                      |

## Direction maps
| Map       | Action                            |
|:---       |:---                               |
|`<C-h>`    | focus left window                 |
|`<C-j>`    | focus below window                |
|`<C-k>`    | focus above window                |
|`<C-l>`    | focus right window                |
|`<C-left>` | decrease window width             |
|`<C-down>` | decrease window height            |
|`<C-up>`   | increase window height            |
|`<C-right>`| increase window width             |
|`<M-h>`    | move cursor left.  Modes: I,T,C   |
|`<M-j>`    | move cursor down.  Modes: I,T     |
|`<M-k>`    | move cursor up.    Modes: I,T     |
|`<M-l>`    | move cursor right. Modes: I,T,C   |

## ui-extra options
|List of affected Options|                                     |
|:---                    |:---                                 |
|'list'                  | Display of tabs, ending space       |
|'listchars'             | Which chars for display of hidden   |
|'pumblend'              | 0-100 transparancy for popups       |
|'pumheight'             | Max items in popups; 0=avail space  |
|'winblend'              | 0-100 transparency floating windows |
|Runs `:syntax on`       | see :syntax-on)                     |

## N-mode vim basics
|Keys  |Action                                             |
|:---  |:---                                               |
|x     |del char @cursor                                   |
|a,A   |Append after char, end of line (ins)               |
|b,B   |Backwrd to start prior word, White-space word      |
|d     |Delete [count] [motion]                            |
|i,I   |Insert before cursor, line                         |
|w,W   |word - start of next, White-space word [motion]    |
|e,E   |end - current word, End white-space word [motion]  |
|o,O   |Open line below,above @ (ins)                      |
|0,^   |Start of line, first non-blank as [motion]         |
|9     |Num b4 motion (w,e,hjkl) as [count]                |
|$     |End of line as [motion]                            |
|u,U   |Undo last cmd (stack), all on line                 |
|<C-r> |Redo undo (stack)                                  |
|p,P   |Paste last cp/del below,above (stack)              |
|r,R   |Replace char, from char @cursor (ins for R)        |
|c     |Change [count] [motion] (ins)                      |
|f     |Find <key>                                         |
|q     |Record macro at following <reg>, end with q        |
|y     |yank [count] [motion]                              |
|gg    |top of file                                        |
|G     |bottom of file                                     |
|9G    |9[count] of file                                   |
|<C-g> |show loc in file and relative(%)                   |
|/ x   |search for x phrase fwd                            |
|? x   |search for x phrase backwd                         |
|  n,N |next match in direction, backwd of direct          |
|<C-o> |back to prior spot                                 |
|<C-i> |go fwd a spot                                      |
|%     |find matching ] } )                                |

## Command mode basics (preceding :)
|Keys           |Description                               |
|:---           |:---                                      |
|s/old/new/     |sub first old in line                     |
|s/old/new/g    |sub global in line                        |
|#,#s/old/new/g |sub global line-range #,#                 |
|               |    can select range in visual mode       |
|%s/old/new/g   |sub global full file                      |
|%s/old/new/gc  |sub global file w/confirm each sub        |
|! x            |execute terminal cmd x                    |
|w x            |save buffer as file x                     |
|'<,'>w x       |save visual selection as file x           |
|'<,'>d         |delete visual selection                   |
|r x            |retrieve (import) x above @               |
|r !x           |retrieve output of terminal cmd x         |
|<x><C-d>       |completions for <x>                       |
|<x><tab>       |completions list for <x>                  |
|<C-n> or <tab> |next match on completions list            |
|<C-p> or <S-tb>|previous match on completions list        |
|w ++p x        |save buffer, creating dir hierarchy       |
|<C-w><C-w>     |jump to another window                    |

## Tips, tricks and samples
|Keys                  |Description                        |
|:---                  |:---                               |
|'<,'>:norm I#<sp>     |Comment all selected lines         |
|viw, vaw              |visual inside, around word select  |
|   i,a                |for "({  c (chg), y (ynk), d (del) | 
|:.,.+3!sort           |!cli sort, 4 rows start current(.) |
|:!!jq .               |format json (on current line)      |
|:g/TODO/d             |delete TODO in searched lines      |
|:g/^$/d               |delete empty lines                 |
|:g/error/t$           |copy error lines to end of buffer  |

## Misc sequences
'<,'>:norm I0. gv to reselect prior  g<C-a> number rows

