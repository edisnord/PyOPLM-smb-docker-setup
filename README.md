# PyOPLM-smb-docker-setup
A docker-compose setup for running an SMB server and [PyOPLM](https://github.com/edisnord/PyOPLM) side by side, with PyOPLM being automatically configured to mount the SMB server's OPL Directory as it's opl_dir

Environment variables (to be supplied in a .env file at the root of this repo):
- INPUT: Default arguments to be passed to PyOPLM on container run
- SMB_PORT: Port on which the SMB server will be exposed at on the host device (445 by default)
- OPL_SMB_DIR: The Open PS2 Loader base directory located on your system

## Usage

There are two scripts, one is a Bash script (pyoplm.sh) and one is a PowerShell script
(pyoplm.ps1) for Windows users. If you want to have the command `pyoplm` added to your PowerShell terminals as an Alias in Windows so you can use it on your terminal without referencing the script, run the file `install.ps1`. You can interact with those scripts as if you are interacting
with PyOPLM. Make sure to not put them in a directory different from the one where the
PyOPLM image and the docker-compose.yml file is located, as they depend on them being in
the same directory.

To run a containerized SMB server, just run `docker compose up ps2smb`, but you need to disable `lanmanservice` on Windows and reboot your PC to run the container at port 445. This service handles file sharing and remote printing, so disabling it will ultimately make those things not work until enabled again. The variable OPL_SMB_DIR in the .env file is both taken into account by PyOPLM as the opl directory and the SMB server as the directory to share with the PS2.

Remember to occasionally rebuild the image for PyOPLM using the `pyoplm update` command as the program is under active development and improvements, features and bugfixes may be added in future versions. If you don't rebuild the image you will only have the version of PyOPLM which you downloaded the first time the run script ran.

## Artwork storage support

Currently limited to online storages, local storage will require you to mount your local storage
directory on the PyOPLM container, then make your pyoplm.ini in the OPL directory point
to where you mounted your storage.

## TODO:
- Make bintools work from the PyOPLM scripts in this repo (probably by generalizing file mounting for all commands and not just for the add command like i have done)

Pull requests are more than appreciated.
