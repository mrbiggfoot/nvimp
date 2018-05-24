# nvimp
My neovim configuration.

## Prerequisites

- [vim-plug](https://github.com/junegunn/vim-plug)
- [exuberant-ctags with protobuf support](https://github.com/mrbiggfoot/exuberant-ctags)
- [ripgrep](https://github.com/BurntSushi/ripgrep)

Create the `~/.ctags` file for golang support:
```
--langdef=go
--langmap=go:.go
--regex-go=/func([ \t]+\([^)]+\))?[ \t]+([a-zA-Z0-9_]+)/\2/f,func/
--regex-go=/var[ \t]+([a-zA-Z_][a-zA-Z0-9_]+)/\1/v,var/
--regex-go=/type[ \t]+([a-zA-Z_][a-zA-Z0-9_]+)/\1/t,type/
```

## Environment

- [iterm2](https://www.iterm2.com)
