#!/bin/zsh

set -e

paruinstall() {
	
	#sudo pacman -S git && \
		#sudo pacman -S --needed base-devel && \
		#git clone https://aur.archlinux.org/paru.git && \
		#cd paru && \
		#makepkg -si && \
		#cd .. && \
		#rm -rf paru
}


stow_conf() {

	for i in $(ls -d */);
	do stow ${i%%/};
	done
}

vim_conf() {
	echo "a"
}

zsh_conf() {
	
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
	chsh -s /bin/zsh
	if [ -d $HOME/.oh-my-zsh ]
		then
		mv $HOME/.oh-my-zsh $HOME/.config/oh-my-zsh;
	fi
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-history-substring-search
}

tmux_conf() {

	git clone https://github.com/tmux-plugins/tpm ../.config/tmux/plugins/tpm
}

pkgs() {

	#paru -S $(cat ./pkg.txt);
}


echo "INSTALLING AUR HELPER AND PACKAGES" && paruinstall && pkgs;
echo "STOWING CONFIG FILES" && stow_conf;
echo "INSTALLING ZSH PLUGINS" && zsh_conf;
echo "INSTALLING TMUX PACKAGES" && tmux_conf;
