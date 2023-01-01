# WELCOME!!!
<!-- vim-markdown-toc GFM -->

* [use](#use)

<!-- vim-markdown-toc -->
![screenshot](./2022-12-04_19-08.png)
## use

**I using the archlinux so i can directly download language severs by pacman and other package manager,if you can't,use the mason plugin to install them and let them work**
1. Make usre you have installed te neovim(just to find corresponding distribution's way) and install other dependencies of other packages(**pip**,**nodejs**,**yarn** and others)

- Python3 install `pynvim`
```plaintext
pip install pynvim
```
- Nodejs install `neovim`
```plaintext
npm install -g neovim
```
- Install Nerd font(I use cousine)
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
5. Ok,that's all.And welcome you change or replace my plugins or configuration.
***Last but not least, if you find something wrong,try to complite the packer.lua file.You may find the problem disappear(if this isn't useful, try to read the woring message or delete the packer_compiled file)***
```plaintext
:PackerCompile
```
6. If you find the text can't highlight like before,try to run the next command,it always appear when you update the nvim-treesitter plugin,so you should update the config also
```plaintext
:TSUpdateSync
```
