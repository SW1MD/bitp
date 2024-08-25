import sys
import os
import json
import base64
import hashlib

CONFIG_FILE = 'bitp_config.json'

def print_help():
    print("bitp - A quick access command-line tool")
    print("Usage: bitp [command] [args]")
    print("\nAvailable commands:")
    print("  help                   - Show this help message")
    print("  encode [text]          - Base64 encode text")
    print("  decode [base64]        - Base64 decode text")
    print("  hash [text]            - Generate SHA-256 hash of text")
    print("  set [number] [command] - Set a speed dial command (1-9)")
    print("  [number]               - Run a speed dial command (1-9)")
    print("  list                   - List all speed dial commands")
    print("  sdir [number]          - Save current directory to d[number] (1-9)")
    print("  d[number]              - Navigate to saved directory (1-9)")

def encode_base64(text):
    return base64.b64encode(text.encode()).decode()

def decode_base64(encoded_text):
    return base64.b64decode(encoded_text).decode()

def hash_text(text):
    return hashlib.sha256(text.encode()).hexdigest()

def load_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as f:
            config = json.load(f)
    else:
        config = {}
    
    if 'speed_dial' not in config:
        config['speed_dial'] = {}
    if 'saved_dirs' not in config:
        config['saved_dirs'] = {}
    
    return config

def save_config(config):
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)

def set_speed_dial(number, command):
    config = load_config()
    config['speed_dial'][number] = command
    save_config(config)
    print(f"Speed dial {number} set to: {command}")

def run_speed_dial(number):
    config = load_config()
    if number in config['speed_dial']:
        command = config['speed_dial'][number]
        print(f"Running: {command}")
        if command.startswith('cd '):
            # Special handling for cd command
            path = command[3:].strip()
            print(f"CD:{path}")  # This will be caught by the batch file
        else:
            os.system(command)
    else:
        print(f"No command set for speed dial {number}")

def list_speed_dials():
    config = load_config()
    if config['speed_dial']:
        print("Speed dial commands:")
        for number, command in config['speed_dial'].items():
            print(f"  {number}: {command}")
    else:
        print("No speed dial commands set")

def save_directory(number):
    current_dir = os.getcwd()
    config = load_config()
    config['saved_dirs'][number] = current_dir
    save_config(config)
    print(f"Current directory saved to d{number}: {current_dir}")

def navigate_to_saved_directory(number):
    config = load_config()
    if number in config['saved_dirs']:
        path = config['saved_dirs'][number]
        print(f"CD:{path}")  # This will be caught by the batch file
    else:
        print(f"No directory saved for d{number}")

def main():
    if len(sys.argv) < 2:
        print_help()
        return

    command = sys.argv[1]
    args = sys.argv[2:]

    if command == "help":
        print_help()
    elif command == "encode":
        print(encode_base64(' '.join(args)))
    elif command == "decode":
        print(decode_base64(' '.join(args)))
    elif command == "hash":
        print(hash_text(' '.join(args)))
    elif command == "set":
        if len(args) >= 2 and args[0].isdigit() and 1 <= int(args[0]) <= 9:
            set_speed_dial(args[0], ' '.join(args[1:]))
        else:
            print("Invalid set command. Usage: set [number 1-9] [command]")
    elif command == "list":
        list_speed_dials()
    elif command == "sdir":
        if len(args) == 1 and args[0].isdigit() and 1 <= int(args[0]) <= 9:
            save_directory(args[0])
        else:
            print("Invalid sdir command. Usage: sdir [number 1-9]")
    elif command.startswith("d") and len(command) == 2 and command[1].isdigit() and 1 <= int(command[1]) <= 9:
        navigate_to_saved_directory(command[1])
    elif command.isdigit() and 1 <= int(command) <= 9:
        run_speed_dial(command)
    else:
        print(f"Unknown command: {command}")
        print_help()

if __name__ == "__main__":
    main()