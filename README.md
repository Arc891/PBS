# Push Before Shutdown (PBS)
Push before shutdown is a little script I made to have a pop-up ask you if you want to shutdown, or first push all your un-pushed changes form every repo you have on your system (that you would like to keep up to date between other devices). It works by finding all folders on your system which contian a .git/ directory, meaning that it is a repo, and then for each one asks you if you want to push the contents of this repo. It will save your answers in a file, and keep a backup in case you changed it by accident. Then, it will go through these repos, and show you what's left to commit. You can choose your specific files to commit, your message, and it will pull and then push (to avoid the push from aborting). You can also choose to go for a fast commit, which will simply add all changes, give them a "quick push before shutdown" commit message, and push.

To run this, simply run `push_and_shutdown.sh` for the rofi menu, or if you know you want to commit everything, run `push_all_repos.sh`. You can refer to the `push_and_shutdown.sh` script from your own polybar module or keyboard shortcut etc to run it at anytime and make it look good. 

The rofi design and colorscheme is from the standard powermenu module in the polybar config of the Bspwm version of EndeavourOS, all credit goes to them for the setup.