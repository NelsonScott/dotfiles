# Dotfiles

Dotfiles I use, only uploading the ones I configured.  
I mostly use zsh, I barely use bash. I uploaded bashrc & bash_profile mostly for posterity.

## Installation

I manage these with manual symlinks, but the repo includes a Dotbot config if you prefer automation.

### Manual installation (what I actually do)
```bash
git clone git@github.com:NelsonScott/dotfiles.git && cd dotfiles
ln -s zshrc ~/.zshrc
ln -s vimrc ~/.vimrc
ln -s gitconfig ~/.gitconfig
ln -s bin ~/.local/bin
# etc...
```
## Dotbot installation (if you want automation)
You'll need to add Dotbot as a submodule first:
```bash
cd ~/Documents/dotfiles
git submodule add https://github.com/anishathalye/dotbot
cp dotbot/tools/git-submodule/install .
./install
```

## Structure

- `bin/` - Executable scripts (gets symlinked to ~/.local/bin)
- Config files - Individual dotfiles for various programs

## License
[MIT](https://choosealicense.com/licenses/mit/)