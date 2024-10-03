# My [zsh](https://zsh.sourceforge.io/)configuration

- [zshguide](https://zsh.sourceforge.io/Guide/zshguide.html)
- [Archlinux zsh](https://wiki.archlinux.org/index.php/Zsh)

## Plugins

- [ZIM:FW](https://www.github.com/zimfw/zimfw) -- Modular, customizable, and blazing fast Zsh framework.
- [zsh-completions](https://github.com/zsh-users/zsh-completions) -- Additional completion definitions for Zsh.
- [completion](https://www.github.com/zimfw/completion) -- Enables and configures smart and extensive tab completion.
- [environment](https://www.github.com/zimfw/environment) -- Sets generic Zsh built-in environment options.
- [input](https://www.github.com/zimfw/input) -- Applies correct bindkeys for input events.
- [run-help](https://www.github.com/zimfw/run-help) -- Figures out where to get the best help, and gets it.
- [git](https://www.github.com/zimfw/git) -- Provides nice git aliases and functions.
- [termtitle](https://www.github.com/zimfw/termtitle) -- Sets a custom terminal title.
- [duration-info](https://www.github.com/zimfw/duration-info) -- Exposes to prompts how long the last command took to execute.
- [git-info](https://www.github.com/zimfw/git-info) -- Exposes git repository status information to prompts.
- [prompt-pwd](https://www.github.com/zimfw/prompt-pwd) -- Formats the current working directory to be used by prompts.
- [fzf-tab](https://www.github.com/Aloxaf/fzf-tab) -- Replace zsh's default completion selection menu with fzf!
- [zsh-autosuggestions](https://www.github.com/zsh-users/zsh-autosuggestions) -- Fish-like autosuggestions for Zsh.
- [zsh-history-substring-search](https://www.github.com/zsh-users/zsh-history-substring-search) -- Fish-like history search (up arrow) for Zsh, must be sourced after zsh-users/zsh-syntax-highlighting
- [fast-syntax-highlighting](https://www.github.com/zdharma/fast-syntax-highlighting) -- Feature rich syntax highlighting for Zsh.
- [k](https://www.github.com/supercrabtree/k) -- Directory listings for zsh with git features
- [zsh-autopair](https://www.github.com/hlissner/zsh-autopair) -- Auto-close and delete matching delimiters in zsh
- [zfm](https://www.github.com/pabloariasal/zfm) -- Zsh Fuzzy Marks
- [zsh-z](https://www.github.com/agkozak/zsh-z) -- Jump quickly to directories that you have visited "frecently." A native ZSH port of zsh.
- [gitster](https://www.github.com/zimfw/gitster) -- A Zim fork of shashankmehta's gitster prompt theme

### Keyboard Shortcuts

|  Shortcut  | Action                                                                                                                                                                                              |
| :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `alt` `h`  | execute `run-help` for the current command                                                                                                                                                          |
| `ctrl` `v` | Edit command line with `$EDITOR`                                                                                                                                                                    |
|   `tab`    | trigger `fzf-tab` <br> `tab` `shift-tab` select/deselect multiple results<br> `ctrl` `h` get possible context for a command<br>`[` / `]` switch between groups<br>`/` trigger continuous completion |
| `ctrl` `i` | accept the suggestion                                                                                                                                                                               |
| `ctrl` `u` | history-substring-search-up                                                                                                                                                                         |
| `ctrl` `e` | history-substring-search-down                                                                                                                                                                       |
| `ctrl` `t` | `fzf-file-widget`: Paste the selected files and directories onto the command-line                                                                                                                   |
| `ctrl` `r` | `fzf-history-widget`: Paste the selected command from history onto the command-line                                                                                                                 |
| `ctrl` `d` | `fzf-cd-widget`: cd into the selected directory                                                                                                                                                     |
| `ctrl` `t` | `fzf-text-in-file`: Search for text in files                                                                                                                                                        |
| `ctrl` `g` | run `lazygit`                                                                                                                                                                                       |
| `ctrl` `n` | run `lazynpm`                                                                                                                                                                                       |

## Keyboard Shortcuts in `VI mode`

|  Shortcut  | Action                        |
| :--------: | :---------------------------- |
|    `k`     | vi-insert                     |
|    `K`     | vi-insert-bol                 |
|    `n`     | vi-backward-char              |
|    `i`     | vi-forward-char               |
|    `N`     | vi-beginning-of-line          |
|    `I`     | vi-end-of-line                |
|    `e`     | down-line-or-history          |
|    `u`     | up-line-or-history            |
| `ctrl` `u` | history-substring-search-up   |
| `ctrl` `e` | history-substring-search-down |
|    `l`     | vi-undo-change                |
|    `L`     | undo                          |
|    `r`     | redo                          |
|    `=`     | vi-repeat-search              |
|    `h`     | vi-forward-word-end           |

## Aliase

| Shortcut | Action                                                                   |
| :------: | :----------------------------------------------------------------------- |
|   `k`    | `k -a`                                                                   |
|   `c`    | `clear`                                                                  |
|   `cs`   | `calcurse`                                                               |
| `cdiff`  | `colordiff`                                                              |
|   `kk`   | `nvim .gitignore`                                                        |
|   `lg`   | `lazygit`                                                                |
|   `lo`   | `lsof -p $(fps) +w`                                                      |
|   `ra`   | `yazi`                                                                   |
|  `sra`   | `sudo -E yazi`                                                           |
|   `s`    | `neofetch --kitty ~/MK/Wallpaper`                                        |
|   `g`    | `onefetch`                                                               |
|  `sudo`  | `sudo -E`                                                                |
|   `t`    | `tmux`                                                                   |
|   `ta`   | `tmux a`                                                                 |
|  `vim`   | `nvim`                                                                   |
|   `gc`   | `git config credential.helper store`                                     |
|   `gg`   | `git clone`                                                              |
|   `gs`   | `git config credential.helper store`                                     |
|   `cf`   | `/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME`              |
|  `cfg`   | `lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME`                   |
|  `cfs`   | `/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME status -u -s` |
