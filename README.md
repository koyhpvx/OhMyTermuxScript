# OhMyTermuxScript
A collection of scripts for Termux

By default [gum](https://github.com/charmbracelet/gum) is installed to provide a nice interface when running from the command line (can be disabled, see below "Additional script parameters") 

### Complete installation 

From a clean install of Termux :
````
pkg update -y && pkg install git -y
git clone https://github.com/GiGiDKR/OhMyTermuxScript.git
cd OhMyTermuxScript && chmod +x *.sh
````
Then to run a script, type: 
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
Installation without using gum: 
````
./script_name.sh --nogum (or -ng)
````
These settings can be combined. 
