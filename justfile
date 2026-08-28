default: pi

pi:
    PI_CODING_AGENT_DIR="{{justfile_directory()}}/.pi/agent" pi

# Update every tool managed by this repository.
update: pi-update

# Update Pi and its installed extensions.
pi-update:
    PI_CODING_AGENT_DIR="{{justfile_directory()}}/.pi/agent" pi update --all
