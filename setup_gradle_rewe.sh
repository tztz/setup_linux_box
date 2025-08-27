#!/bin/bash

#
# Sets up Gradle configuration for REWE digital artifactory usage
# This script configures a template build.gradle file for Java projects
#

echo "Setting up Gradle with REWE artifactory configuration..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_GRADLE_TEMPLATE="$SCRIPT_DIR/build.gradle"
GRADLE_PROPS_TEMPLATE="$SCRIPT_DIR/gradle.properties.template"

echo "Build.gradle template location: $BUILD_GRADLE_TEMPLATE"
echo "Gradle properties template location: $GRADLE_PROPS_TEMPLATE"

if [ ! -f "$BUILD_GRADLE_TEMPLATE" ]; then
    echo "ERROR: build.gradle template not found at $BUILD_GRADLE_TEMPLATE"
    exit 1
fi

if [ ! -f "$GRADLE_PROPS_TEMPLATE" ]; then
    echo "ERROR: gradle.properties template not found at $GRADLE_PROPS_TEMPLATE"
    exit 1
fi

echo ""
echo "Templates are ready for use in your Java projects!"
echo ""
echo "To use in a new project:"
echo "1. Copy $BUILD_GRADLE_TEMPLATE to your project root as build.gradle"
echo "2. Copy $GRADLE_PROPS_TEMPLATE to your project root as gradle.properties"
echo "3. Update gradle.properties with your REWE artifactory credentials"
echo "4. Alternatively, set environment variables:"
echo "   export REWE_ARTIFACTORY_USERNAME='your-username'"
echo "   export REWE_ARTIFACTORY_PASSWORD='your-password-or-token'"
echo ""
echo "The build.gradle file is configured to:"
echo "- Use REWE digital artifactory for dependency resolution"
echo "- Publish artifacts to REWE artifactory"
echo "- Fall back to Maven Central if REWE artifactory is unavailable"
echo "- Handle authentication via environment variables or gradle.properties"
echo ""
echo "Run 'gradle showRepos' in your project to verify repository configuration."