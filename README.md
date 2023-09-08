# PyOPLM-smb-docker-setup
A docker-compose setup for running an SMB server and PyOPLM side by side, with PyOPLM being automatically configured to mount the SMB server's OPL Directory as it's opl_dir

Environment variables (to be supplied in a .env file at the root of this repo):
- INPUT: Default arguments to be passed to PyOPLM on container run
- SMB_PORT: Port on which the SMB server will be exposed at on the host device
- OPL_SMB_DIR: The Open PS2 Loader base directory located on your system

## Usage

There are two scripts, one is a Bash script (pyoplm.sh) and one is a PowerShell script
(pyoplm.ps1) for Windows users, you can interact with those scripts as if you are interacting
with PyOPLM, and they will manage both starting the SMB server and managing your OPL
directory. Make sure to not put them in a directory different from the one where the
PyOPLM image and the docker-compose.yml file is located, as they depend on them being in
the same directory.
