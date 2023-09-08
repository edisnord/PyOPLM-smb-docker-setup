# PyOPLM-smb-docker-setup
A docker-compose setup for running an SMB server and PyOPLM side by side, with PyOPLM being automatically configured to mount the SMB server's OPL Directory as it's opl_dir

Environment variables (to be supplied in a .env file at the root of this repo):
- INPUT: Arguments to be passed to PyOPLM on container run
- SMB_PORT: Port on which the SMB server will be exposed at on the host device
- OPL_SMB_DIR: The Open PS2 Loader base directory located on your system
