default: pi

pi:
    PI_CODING_AGENT_DIR="{{justfile_directory()}}/.pi/agent" pi

update:
    PI_CODING_AGENT_DIR="{{justfile_directory()}}/.pi/agent" pi update --all
