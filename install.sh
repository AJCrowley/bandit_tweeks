# install fortune if not already installed
brew install fortune
# copy content to new home
cp -r utilitylimb /usr/local/opt
# determine shell
if [ -n "$ZSH_VERSION" ]; then
    rcfile="~/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    rcfile="~/.bashrc"
fi
# write a call to fortune at the end of the rc file
echo 'fortune /usr/local/opt/utilitylimb' >> $rcfile
