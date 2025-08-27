# Gradle REWE Artifactory Configuration

This repository includes templates for configuring Gradle projects to use REWE Digital's JFrog Artifactory.

## Files

- `build.gradle` - Template Gradle build file with REWE artifactory configuration
- `gradle.properties.template` - Template for Gradle properties with credential placeholders
- `setup_gradle_rewe.sh` - Setup script to help configure Gradle projects

## Usage

### For New Java Projects

1. Copy the template files to your project:
   ```bash
   cp build.gradle /path/to/your/project/
   cp gradle.properties.template /path/to/your/project/gradle.properties
   ```

2. Configure your REWE artifactory credentials in `gradle.properties`:
   ```properties
   reweArtifactoryUsername=your-username
   reweArtifactoryPassword=your-password-or-token
   ```

3. Alternatively, set environment variables:
   ```bash
   export REWE_ARTIFACTORY_USERNAME='your-username'
   export REWE_ARTIFACTORY_PASSWORD='your-password-or-token'
   ```

### Repository Configuration

The build.gradle template configures the following repositories in order:

1. **REWE Artifactory Public** - `https://artifactory.rewe-digital.com/artifactory/maven-public`
2. **REWE Artifactory Private** - `https://artifactory.rewe-digital.com/artifactory/maven-private`
3. **Maven Central** - Fallback for public dependencies

### Publishing

The template also configures publishing to REWE artifactory:
- Releases: `https://artifactory.rewe-digital.com/artifactory/maven-releases`

### Verification

Run the following command in your project to verify repository configuration:
```bash
gradle showRepos
```

## Security Notes

- Never commit `gradle.properties` with actual credentials to version control
- The template uses environment variables as a secure alternative to storing credentials in files
- The `.gitignore` file is configured to exclude `gradle.properties` while keeping the template

## Integration with Setup Script

This Gradle configuration is automatically set up when running the main `setup_linux_box.sh` script, which includes a section for "Setup Gradle with REWE artifactory configuration".