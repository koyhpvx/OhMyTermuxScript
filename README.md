# OhMyTermuxScript
A collection of scripts for Termux

> [!IMPORTANT]
> To use a beautiful command line script execution interface [gum](https://github.com/charmbracelet/gum) can be used with --gum or -g parameter.

### Complete installation 

From a clean install of Termux, paste the following code 
```bash
pkg update -y && pkg install git -y
git clone https://github.com/GiGiDKR/OhMyTermuxScript.git
cd OhMyTermuxScript && chmod +x ./*.sh
```
Type `ls` to display the list of scripts, then type
```bash
./script_name.sh 
```


### Run a specific script 

Electron Node.js
```bash
curl -sL https://raw.githubusercontent.com/GiGiDKR/OhMyTermuxScript/main/electron.sh -o electron.sh && chmod +x electron.sh && ./electron.sh
```

Create user directories (Symlink) 
```bash
curl -sL https://raw.githubusercontent.com/GiGiDKR/OhMyTermuxScript/main/usersymlink.sh -o usersymlink.sh && chmod +x usersymlink.sh && ./usersymlink.sh
```

## Additional script parameters
Uninstall :
```bash
./script_name.sh --uninstall (or -u)
```
Installation using gum: 
```bash
./script_name.sh --gum (or -g)
```
> [!TIP]
> These settings can be combined. 
