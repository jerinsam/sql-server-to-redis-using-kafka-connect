##### To add a value permanently to PATH on Ubuntu, need to modify either the “/etc/profile” or “~/.profile” files.
# 1. /etc/profile – The profile file within the “/etc/” directory allows you to modify system-wide environment variables for logged-in users.
# 2. ~/.profile – The “.profile” file allows you to change the PATH variable for a specific user.

# execute below script to update the environmental variable path
nano ~/.profile

# Add following confluent-hub path to environmental variable
PATH="/home/jerin/learn/sql-server-to-redis-using-kafka-connect/install_and_config/3-confluent-hub-configure/confluent-hub/bin:$PATH"

# Close and save the editor
