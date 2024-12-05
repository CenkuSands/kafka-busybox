#!/bin/bash

# Function to get user input
prompt_input() {
    local prompt="$1"
    local var_name="$2"
    read -p "$prompt: " $var_name
}

# Function to reset offsets
reset_offsets() {
    local group="$1"
    local topic="$2"
    local partition="$3"
    local offset="$4"
    local mode="$5"

    # Validate mode
    if [[ "$mode" != "execute" && "$mode" != "dry-run" ]]; then
        echo "Invalid mode. Please choose 'execute' or 'dry-run'."
        exit 1
    fi

    # Kafka consumer group offset reset command
    kafka-consumer-groups.sh --bootstrap-server 172.16.160.15:9093 \
        --command-config /opt/kafka/config/client.properties \
        --group "$group" \
        --topic "$topic:$partition" \
        --reset-offsets \
        --to-offset "$offset"\
        --"$mode"
}

# Main script
echo "Kafka Consumer Group Offset Reset Script"
echo "---------------------------------------"

# Prompt user for input
prompt_input "Enter the consumer group" group
prompt_input "Enter the topic name" topic
prompt_input "Enter the partition number" partition
prompt_input "Enter the to-offset number" offset
prompt_input "Choose mode ('execute' or 'dry-run')" mode

# Confirm user input
echo ""
echo "You entered:"
echo "  Consumer Group: $group"
echo "  Topic: $topic"
echo "  Partition: $partition"
echo "  Offset: $offset"
echo "  Mode: $mode"
echo ""

# Confirm before proceeding
read -p "Do you want to proceed? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Perform the offset reset
reset_offsets "$group" "$topic" "$partition" "$offset" "$mode"

# Completion message
if [[ "$mode" == "execute" ]]; then
    echo "Offsets have been reset."
else
    echo "Dry-run completed. No changes were made."
fi
