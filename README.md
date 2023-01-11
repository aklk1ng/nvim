## use

1. Make usre you have installed te neovim(just to find corresponding distribution's way) and install other dependencies of other packages(**pip**,**nodejs**,**yarn** and others)

- Python3 install `pynvim`
```plaintext
pip install pynvim
```
- Nodejs install `neovim`
```plaintext
npm install -g neovim
```
- Install Nerd font
[nerd font](https://www.nerdfonts.com/font-downloads) 
- Install yarn

**use the next commmand in neovim to check the neovim** 
```plaintext
:Checkhealth
```
2. **Clone the repository:**
```plaintext
cd ~/.config
git clone https://github.com/aklk1ng/nvim.git
```
3. Start your neovim and if'will start download all plugins automatically
4. Now waiting to download(**the internet may be the most problem**)
6. If you find the text can't highlight like before,try to run the next command,it always appear when you update the nvim-treesitter plugin,so you should update the config also
```plaintext
:TSUpdateSync
```
