# Install NerdFonts
#mkdir -p ~/.local/share/fonts
#cd ~/.local/share/fonts
#curl -fLo "JetBrains Mono Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf?raw=true
#curl -fLo "JetBrains Mono Bold Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Bold/complete/JetBrains%20Mono%20Bold%20Nerd%20Font%20Complete.ttf?raw=true
#curl -fLo "JetBrains Mono Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Italic/complete/JetBrains%20Mono%20Italic%20Nerd%20Font%20Complete.ttf?raw=true
#curl -fLo "JetBrains Mono Bold Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/BoldItalic/complete/JetBrains%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete.ttf?raw=true
#echo Installed Fonts:
#ls -1


# Install kitty config
if [ ! "$(ls -A ~/.config/kitty)" ]; then
	rm -rf ~/.config/kitty/
	ln -sf `pwd`/kitty ~/.config/kitty
fi

# Install vim config

if [ ! "$(ls -A ~/.config/nvim)" ]; then
	rm -rf ~/.config/nvim/
	ln -sf `pwd`/vim ~/.config/nvim
fi
sh -c 'curl -fLo ~/.config/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

