
# User Guide for Kafka Consumer Group Offset Reset Script

## Introduction
The `consumer-group-reset.sh` script is a command-line utility designed to reset the offsets for a Kafka consumer group. 
This tool helps users manage Kafka consumer group offsets by allowing them to reset the offset for a specific topic, partition, and group to a user-defined value.

---

## Prerequisites
1. **Kafka CLI Tools**: Ensure the Kafka CLI tools (e.g., `kafka-consumer-groups.sh`) are available and correctly configured in the environment.
2. **Kafka Connection**:
   - The Kafka broker's address must be accessible from the environment running this script.
   - Ensure the `client.properties` file is available and correctly configured for authentication (if required).
3. **Permissions**: The user running the script must have permissions to reset consumer group offsets in the Kafka cluster.

---

## Environment Variables
This script uses two environment variables for flexibility:

1. **BROKER**: The Kafka broker's address. Example: `172.16.160.15:9093`.
2. **COMMAND_CONFIG**: Path to the Kafka client configuration file. Example: `/opt/kafka/config/client.properties`.

---

## Usage
Run the script by executing the following command:

```bash
./consumer-group-reset.sh
```

The script will guide you through the process with prompts.

---

## User Prompts
The script will prompt you for the following inputs:

1. **Consumer Group**:
   - Enter the name of the consumer group whose offsets you want to reset.

2. **Topic Name**:
   - Specify the topic associated with the consumer group.

3. **Partition Number**:
   - Provide the partition number for the topic.

4. **Offset**:
   - Enter the offset to which you want to reset. Examples:
     - `0`: Start from the earliest offset.
     - Any positive integer.

5. **Mode**:
   - Choose one of the following modes:
     - `dry-run`: Preview the changes without applying them.
     - `execute`: Apply the offset reset.

---

## Example

### Sample Run
```bash
./consumer-group-reset.sh
```

#### Prompts and Inputs:
```plaintext
Kafka Consumer Group Offset Reset Script
---------------------------------------
Enter the consumer group: my-consumer-group
Enter the topic name: my-topic
Enter the partition number: 0
Enter the to-offset number: 100
Choose mode ('execute' or 'dry-run'): dry-run

You entered:
  Consumer Group: my-consumer-group
  Topic: my-topic
  Partition: 0
  Offset: 100
  Mode: dry-run

Do you want to proceed? (yes/no): yes

Dry-run completed. No changes were made.
```

---

## Output
1. **Dry-Run Mode**: The script displays what changes would be made without applying them.
2. **Execute Mode**: The script resets the consumer group offset and confirms the changes.

---

## Error Handling
1. **Invalid Mode**:
   - If the mode is not `execute` or `dry-run`, the script exits with an error.
2. **Broker Connection Issues**:
   - Ensure the `BROKER` environment variable points to a reachable Kafka broker.
3. **Authentication Issues**:
   - Verify that the `COMMAND_CONFIG` file contains valid credentials and configuration.
4. **Invalid Inputs**:
   - The script validates the inputs and prompts errors if the values are incorrect.

---

## Tips for Administrators
1. Predefine `BROKER` and `COMMAND_CONFIG` environment variables in your environment:
   ```bash
   export BROKER="172.16.160.15:9093"
   export COMMAND_CONFIG="/opt/kafka/config/client.properties"
   ```
2. Distribute the script to users with the preconfigured environment to simplify their workflow.

---

## FAQs

1. **Can I reset offsets for multiple partitions simultaneously?**
   - No, this script handles one partition at a time. For multiple partitions, run the script separately for each partition.

2. **What happens if I enter an invalid offset?**
   - The Kafka CLI will throw an error, and the script will terminate.

3. **How do I reset to the latest offset?**
   - Use the offset value `-1` to reset to the latest offset.

---

## Support
If you encounter issues, contact your Kafka administrator or refer to the Kafka CLI documentation for more details.

