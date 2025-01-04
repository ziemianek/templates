#!/bin/bash

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    log "Please source this script: source init_venv.sh <venv_name>"
    exit 1
fi

if [ -z "$1" ]; then
    log "No virtual environment name provided. Usage: source init_venv.sh <venv_name>"
    return 1
fi

VENV_NAME=$1

log "Starting virtual environment setup..."

# Check if the virtual environment already exists
if [ ! -d "$VENV_NAME" ]; then
    log "Virtual environment not found. Creating a new one..."
    
    # Create a Python3 virtual environment
    python3 -m venv "$VENV_NAME"
    if [ $? -ne 0 ]; then
        log "Failed to create virtual environment."
        return 1
    fi

    # Activate the virtual environment
    source "$VENV_NAME/bin/activate"
    if [ $? -ne 0 ]; then
        log "Failed to activate virtual environment."
        return 1
    fi

    log "Installing requirements from requirements.txt..."
    # Install requirements from requirements.txt
    pip install -r requirements.txt --force
    if [ $? -ne 0 ]; then
        log "Failed to install requirements."
        return 1
    fi

    log "Installing Ansible collections from ansible-collections.yaml..."
    # Install Ansible collections from ansible-collections.yaml
    ansible-galaxy collection install -r ansible-collections.yaml --force
    if [ $? -ne 0 ]; then
        log "Failed to install Ansible collections."
        return 1
    fi
else
    log "Virtual environment already exists. Activating it..."
    # Activate the virtual environment
    source "$VENV_NAME/bin/activate"
    if [ $? -ne 0 ]; then
        log "Failed to activate virtual environment."
        return 1
    fi
fi

log "Virtual environment setup completed successfully."
log "Run ''source $VENV_NAME/bin/activate'' to activate the virtual environment."
