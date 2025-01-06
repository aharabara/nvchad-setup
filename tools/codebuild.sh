#!/bin/bash

# Ensure that aws and gum are installed
if ! command -v aws &>/dev/null; then
  gum style --foreground 9 "AWS CLI is not installed. Please install it and try again."
  exit 1
fi

if ! command -v gum &>/dev/null; then
  gum style --foreground 9 "Gum is not installed. Please install it from https://github.com/charmbracelet/gum and try again."
  exit 1
fi

# Fetch a list of CodeBuild projects
gum style --foreground 12 "Fetching list of CodeBuild projects..."
projects=$(aws codebuild list-projects --query 'projects' --output text)

# Let the user select a project
selected_project=$(gum choose $projects)

if [ -z "$selected_project" ]; then
  gum style --foreground 9 "No project selected. Exiting."
  exit 1
fi

gum style --foreground 10 "Selected project: $selected_project"

# Fetch the last 10 builds for the selected project
gum style --foreground 12 "Fetching last 10 builds for $selected_project..."
build_ids=$(aws codebuild list-builds-for-project --project-name "$selected_project" --sort-order DESCENDING --max-items 10 --query 'ids' --output text)

if [ -z "$build_ids" ]; then
  gum style --foreground 9 "No builds found for project $selected_project."
  exit 1
fi

# Show the build statuses
gum style --foreground 12 "Fetching build statuses..."
for build_id in $build_ids; do
  build_info=$(aws codebuild batch-get-builds --ids $build_id --query 'builds[0].{ID:id, Status:buildStatus}' --output text)
  gum style --foreground 10 "$build_info"
done

# Provide options to the user
gum style --foreground 12 "What would you like to do?"
action=$(gum choose "Start a new build" "Stop the last build" "Tail last build logs" "Exit")

case $action in
  "Start a new build")
    gum style --foreground 12 "Starting a new build for $selected_project..."
    aws codebuild start-build --project-name "$selected_project"
    gum style --foreground 10 "Build started successfully."
    ;;
  
  "Stop the last build")
    last_build_id=$(echo $build_ids | awk '{print $1}')
    gum style --foreground 12 "Stopping the last build: $last_build_id..."
    aws codebuild stop-build --id "$last_build_id"
    gum style --foreground 10 "Build stopped successfully."
    ;;
  
  "Tail last build logs")
    last_build_id=$(echo $build_ids | awk '{print $1}')
    gum style --foreground 12 "Tailing logs for the last build: $last_build_id..."
    aws codebuild batch-get-builds --ids "$last_build_id" --query 'builds[0].logs.deepLink' --output text | xargs -I {} open {}
    ;;
  
  "Exit")
    gum style --foreground 10 "Goodbye!"
    exit 0
    ;;
  
  *)
    gum style --foreground 9 "Invalid selection."
    ;;
esac
