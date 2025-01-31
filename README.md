# Devcontainer
DevContainer definition for full stack development, using Android Studio for android emulation

## Dependencies
DevPod, Docker

## How to run
1. Clone/download/copy the .devcontainer directory of this repository inside your project or in a parent directory. (Be sure to add it to your .gitignore if you put it inside your project)
2. Run devpod up . from the chosen directory

A new docker container will be created and accessible through ssh at `{directory}.devpod`. You can now connect to it using ssh, your desired code editor (that supports ssh connection) or run something from inside, like neovim.
