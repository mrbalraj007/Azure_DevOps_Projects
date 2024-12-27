#!/bin/bash

# Define the repository and tag pattern for images created by the result pipeline
REPOSITORY="your_image_repository"  # Replace with your actual image repository
TAG_PATTERN="result*"  # Adjust the tag pattern as needed

# List and remove Docker images matching the criteria
docker images --format '{{.Repository}}:{{.Tag}}' | grep "${REPOSITORY}:${TAG_PATTERN}" | while read -r image; do
    echo "Removing Docker image: $image"
    docker rmi "$image"
done

echo "Cleanup of Docker images completed."