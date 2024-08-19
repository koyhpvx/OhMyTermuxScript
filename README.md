# OhMyTermuxScript
**A collection of scripts for [Termux](https://github.com/termux/termux-app)**

> [!IMPORTANT]
> To use a beautiful command line script execution interface, [gum](https://github.com/charmbracelet/gum) can be used with --gum or -g parameter added to the execution command. 

### Complete installation 

- From a clean install of Termux, paste the following code 
```bash
pkg update -y && pkg install git -y
git clone https://github.com/GiGiDKR/OhMyTermuxScript.git
cd OhMyTermuxScript && chmod +x ./*.sh
```
- Type `ls` to display the list of scripts, then type
```bash
./script_name.sh 
```


### Run a specific script 

- [Electron Node.js](https://github.com/electron/electron)
```bash
curl -sL https://raw.githubusercontent.com/GiGiDKR/OhMyTermuxScript/main/electron.sh -o electron.sh && chmod +x electron.sh && ./electron.sh
```

- Create [Symbolic Link](https://en.wikipedia.org/wiki/Symbolic_link] to external user directories
```bash
curl -sL https://raw.githubusercontent.com/GiGiDKR/OhMyTermuxScript/main/usersymlink.sh -o usersymlink.sh && chmod +x usersymlink.sh && ./usersymlink.sh
```

## Additional parameters
- Uninstall :
```bash
./script_name.sh -u
./script_name.sh --uninstall
```
- Installation using gum: 
```bash
./script_name.sh -g
./script_name.sh --gum
```
> [!TIP]
> These settings can be combined. 
