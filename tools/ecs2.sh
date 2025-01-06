#!/bin/bash

# set -x

# Function to select AWS profile
select_profile() {
    PROFILE=$(gum choose $(aws configure list-profiles))
    export AWS_PROFILE="$PROFILE"
}

# Function to check AWS session
check_session() {
    SSO_ACCOUNT=$(gum spin --title="checking your session" -- aws sts get-caller-identity --query "account" --output text)
    if [ ${#SSO_ACCOUNT} -eq 12 ]; then
        gum style --foreground 118 "[x] Session still valid."
    else
        gum style --foreground 208 "[X] Session expired or invalid."
        aws sso login
    fi
}

# Function to select an option or auto-select if only one option is available
select_or_auto() {
    local options=$1
    local title=$2
    if [ $(echo "$options" | wc -l) -eq 1 ]; then
        echo "$options"
    else
        echo $(gum choose $options)
    fi
}

# Function to get clusters
get_clusters() {
    gum spin --title="Get clusters" -- aws ecs list-clusters --query="clusterArns" --output text | tr '\t' '\n'
}

# Function to get services for a selected cluster
get_services() {
    local cluster=$1
    gum spin --title="Get services for cluster '$cluster'" -- aws ecs list-services --cluster=$cluster --query="serviceArns" --output text | tr '\t' '\n'
}

# Function to get tasks for a selected service in a selected cluster
get_tasks() {
    local cluster=$1
    local service=$2
    gum spin --title="Get tasks for service '$service' in cluster '$cluster'" -- aws ecs list-tasks --cluster=$cluster --service-name=$service --query="taskArns" --output text | tr '\t' '\n'
}

# Function to describe task definition in JSON format
describe_task_definition() {
    local task_def_arn=$1
    aws ecs describe-task-definition --task-definition $task_def_arn --output json
}

# Function to force redeploy
force_redeploy() {
    local cluster=$1
    local service=$2
    local task_def_arn
    local enable_exec

    task_def_arn=$(gum choose $(aws ecs list-task-definitions --query "taskDefinitionArns" --output text | tr '\t' '\n'))
    if gum confirm "Enable 'execute-command' capability?"; then
        enable_exec="--enable-execute-command"
    fi

    gum spin --title="Initiate deployment" -- aws ecs update-service --cluster $cluster --service $service --task-definition $task_def_arn $enable_exec --force-new-deployment
    gum spin --title="Wait till deployment of '$service' service is done..." -- aws ecs wait services-stable --cluster $cluster --services $service
}

# Function to list task states
list_task_states() {
    local cluster=$1
    local service=$2
    aws ecs describe-tasks --cluster $cluster --tasks $(get_tasks $cluster $service) --output json | jq -r '.tasks[] | {taskArn: .taskArn, lastStatus: .lastStatus}'
}

# Function to check execute command capability and redeploy if necessary
check_and_redeploy() {
    local cluster=$1
    local service=$2
    local task=$3

    task_def_arn=$(aws ecs describe-tasks --cluster $cluster --tasks $task --query "tasks[0].taskDefinitionArn" --output text)
    exec_enabled=$(aws ecs describe-services --services $service --cluster $cluster --query "services[0].enableExecuteCommand" --output text)

    if [ "$exec_enabled" != "true" ]; then
       if gum confirm "Cannot connect. Redeploy with 'execute-command' capability?"; then
            gum spin --title="Initiate deployment" -- aws ecs update-service --cluster $cluster --service $service --task-definition $task_def_arn --enable-execute-command --force-new-deployment
        else
            gum style --foreground=221 "[!] Cannot connect to container, because service '$service' doesn't support 'execute-command' capability."
            exit 1
        fi

        gum spin --title="Wait till deployment of '$service' service is done..." -- aws ecs wait services-stable --cluster $cluster --services $service
    fi
}

# Main logic
main() {
    select_profile
    check_session

    set -e

    CLUSTERS=$(get_clusters)
    CLUSTER=$(select_or_auto "$CLUSTERS" "Selected cluster")

    SERVICES=$(get_services $CLUSTER)
    SERVICE=$(select_or_auto "$SERVICES" "Selected service")

    while true; do
        option=$(gum choose "Enter task" "Display tasks with current state" "Display task definition in JSON format" "Force redeploy" "Exit")
        case $option in
            "Enter task")
                TASKS=$(get_tasks $CLUSTER $SERVICE)
                TASK=$(select_or_auto "$TASKS" "Selected task")
                check_and_redeploy $CLUSTER $SERVICE $TASK
                CONTAINERS=$(gum spin --title="Fetch containers for task '$TASK'" -- aws ecs describe-tasks --cluster=$CLUSTER --tasks="$TASK" --output json | jq -r ".tasks[0].containers[].name")
                CONTAINER=$(select_or_auto "$CONTAINERS" "Selected container")
                aws ecs execute-command --cluster $CLUSTER --task $TASK --container $CONTAINER --interactive --command "bash"
                ;;
            "Display tasks with current state")
                list_task_states $CLUSTER $SERVICE
                ;;
            "Display task definition in JSON format")
                TASKS=$(get_tasks $CLUSTER $SERVICE)
                TASK=$(select_or_auto "$TASKS" "Selected task")
                TASK_DEF_ARN=$(aws ecs describe-tasks --cluster $CLUSTER --tasks $TASK --query "tasks[0].taskDefinitionArn" --output text)
                describe_task_definition $TASK_DEF_ARN
                ;;
            "Force redeploy")
                force_redeploy $CLUSTER $SERVICE
                ;;
            "Exit")
                break
                ;;
        esac
    done
}

main
