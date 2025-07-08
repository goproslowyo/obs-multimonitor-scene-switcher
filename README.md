# obs-multimonitor-scene-switcher

This OBS plugin will auto-switch scenes based on which screen your mouse is on.

## Usage:

1) Make sure OBS is running with OBS WebSocket enabled (port 4455, password is randomly generated in OBS).

1) Create an OBS scene *FOR EACH* monitor you wish to switch to. Name them `Monitor1`, `Monitor2`, etc (or edit the code appropriately).

1) Open `main.py` and update `HOST`, `PORT`, and `PASSWORD` as needed.

1) Double-click `install_and_run.bat`.

1) It will install Python packages and launch the OBS scene switcher.

1) To stop, press `Ctrl + C` in the terminal.

## Credits

[TomKenchMusic](https://twitch.tv/TomKenchMusic) who brain-drizzled this idea while peeing.

@goproslowyo who brought Tom's pee-thoughts to life in ~40m.
