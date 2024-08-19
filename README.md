# OhMyTermuxScript
A collection of scripts for Termux

To use a beautiful command line script execution interface [gum](https://github.com/charmbracelet/gum) can be used with --gum or -g parameter.

### Complete installation 

From a clean install of Termux :
````
pkg update -y && pkg install git -y
git clone https://github.com/GiGiDKR/OhMyTermuxScript.git
cd OhMyTermuxScript && chmod +x ./*.sh
````
Then to run a script, type `ls` to display them then enter: : 
````
./script_name.sh 
````


### Run a specific script 

Electron Node.js
````
curl -sL https://raw.githubusercontent.com/GiGiDKR/OhMyTermuxScript/main/electron.sh -o electron.sh && chmod +x electron.sh && ./electron.sh
````

Create user directories (Symlink) 
````
curl -sL https://raw.githubusercontent.com/GiGiDKR/OhMyTermuxScript/main/usersymlink.sh -o usersymlink.sh && chmod +x usersymlink.sh && ./usersymlink.sh
````

## Additional script parameters
Uninstall :
````
./script_name.sh --uninstall (or -u)
````
Installation using gum: 
````
./script_name.sh --gum (or -g)
````
These settings can be combined. 
