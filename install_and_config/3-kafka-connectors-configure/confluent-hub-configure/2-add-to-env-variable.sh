##### To add a value permanently to PATH on Ubuntu, need to modify either the “/etc/profile” or “~/.profile” files.
# 1. /etc/profile – The profile file within the “/etc/” directory allows you to modify system-wide environment variables for logged-in users.
# 2. ~/.profile – The “.profile” file allows you to change the PATH variable for a specific user.

# Open the .profile file in nano editor
nano ~/.profile

# Add the following line to update the PATH environment variable
# (Place this line at the end of the file)
export PATH="/home/jerin/learn/sql-server-to-redis-using-kafka-connect/install_and_config/3-confluent-hub-configure/confluent-hub/bin:$PATH"

# Save and close the file (in nano, you can do this by pressing Ctrl+O to save and Ctrl+X to exit)

# Source the .profile to apply the changes immediately
source ~/.profile

# Optional: Verify the update by checking the PATH variable
echo $PATH
