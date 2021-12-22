# Dotfiles
My dotfiles on my Arch Linux with XMonad system.

## Installation

### Dependencies

You must install the following
```fish
sudo pacman -S xmonad xmonad-contrib xmobar xterm dmenu 
```

It is also recommended that you install the following
```fish
sudo pacman -S firefox vim pulsemixer calc htop scrot xclip conky dunst nitrogen numlockx picom unclutter kdeconnect
```

And the following from the AUR
 - [spotify-tui](https://aur.archlinux.org/packages/spotify-tui/)

### XMobar usage
You will need to change two lines to reflect your own system
```vim
, iconRoot = "/home/user/.xmonad/xpm/" --default "."
, Run Com "/home/user/.xmonad/scripts/battstat" [] "battery" 20
```

