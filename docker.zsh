#!/usr/bin/env zsh

# 🐳 Docker Module - Container Operations Functions
# 🎯 Part of Claude Functions Async Utility Library
# 🔧 New naming convention: cc-docker-<action>
#
# 📋 Available Functions:
#   • cc-docker-compose-generate  - Generate docker-compose files
#   • cc-docker-file-create       - Create optimized Dockerfiles
#   • cc-docker-network-setup     - Setup Docker networks
#   • cc-docker-monitor-logs      - Monitor container logs
#   • cc-docker-cleanup-system    - Clean up Docker resources
#   • cc-docker-security-scan     - Security scan containers
#   • cc-docker-help             - Show help for docker functions

# ═══════════════════════════════════════════════════════════════════════════════
# 🐳 DOCKER AUTOMATION FUNCTIONS - Container Management! 📦
# ═══════════════════════════════════════════════════════════════════════════════

# 📄 cc-docker-compose-generate - Generate docker-compose.yml files for projects
# 🎯 Usage: cc-docker-compose-generate "project_type" [services...]
cc-docker-compose-generate() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📄 cc-docker-compose-generate - Generate docker-compose.yml files"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-docker-compose-generate <project_type> [services...]"
        echo ""
        echo "📝 Parameters:"
        echo "  project_type    🎯 Type of project (required)"
        echo "    Options: webapp, api, fullstack, microservices, data"
        echo "  services        🔧 Additional services (optional)"
        echo "    Options: postgres, mysql, redis, mongodb, nginx, etc."
        echo ""
        echo "📋 Examples:"
        echo "  cc-docker-compose-generate \"webapp\" postgres redis"
        echo "  cc-docker-compose-generate \"api\" mysql nginx"
        echo "  cc-docker-compose-generate \"fullstack\" postgres redis nginx"
        echo ""
        echo "💡 Generates production-ready compose files with:"
        echo "  • Proper networking and volumes"
        echo "  • Environment variables"
        echo "  • Health checks"
        echo "  • Security best practices"
        return 0
    fi
    
    local project_type="$1"
    shift
    local services=("$@")
    
    if [[ -z "$project_type" ]]; then
        echo "❌ Usage: cc-docker-compose-generate <project_type> [services...]"
        echo "💡 Use 'cc-docker-compose-generate -h' for detailed help"
        return 1
    fi
    
    echo "📄 Generating docker-compose.yml for $project_type project..."
    
    if [[ ${#services[@]} -gt 0 ]]; then
        echo "🔧 Including services: ${services[*]}"
    fi
    
    # 🚀 Generate docker-compose file
    run_claude_async "Generate a production-ready docker-compose.yml file for a $project_type project with these additional services: ${services[*]}

Requirements:
- Use proper networking and service discovery
- Include environment variables and secrets
- Add health checks for all services
- Configure volumes for data persistence
- Follow Docker Compose best practices
- Include comments explaining each section
- Add development and production variants if applicable

Project type: $project_type
Additional services: ${services[*]}" &
    
    wait_for_claude_jobs
    echo "✅ Docker Compose file generation completed!"
}

# 🐳 cc-docker-file-create - Create optimized Dockerfiles for different languages
# 🎯 Usage: cc-docker-file-create "language" "project_path" [--multi-stage]
cc-docker-file-create() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🐳 cc-docker-file-create - Create optimized Dockerfiles"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-docker-file-create <language> <project_path> [--multi-stage]"
        echo ""
        echo "📝 Parameters:"
        echo "  language       🔧 Programming language (required)"
        echo "    Options: node, python, go, java, php, ruby, etc."
        echo "  project_path   📁 Path to project directory (required)"
        echo "  --multi-stage  🏗️ Use multi-stage build (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-docker-file-create \"node\" \"./my-app\""
        echo "  cc-docker-file-create \"python\" \"./api\" --multi-stage"
        echo "  cc-docker-file-create \"go\" \"./service\" --multi-stage"
        echo ""
        echo "💡 Creates optimized Dockerfiles with:"
        echo "  • Minimal base images"
        echo "  • Layer caching optimization"
        echo "  • Security best practices"
        echo "  • Multi-stage builds (optional)"
        return 0
    fi
    
    local language="$1"
    local project_path="$2"
    local multi_stage=false
    [[ "$3" == "--multi-stage" ]] && multi_stage=true
    
    if [[ -z "$language" || -z "$project_path" ]]; then
        echo "❌ Usage: cc-docker-file-create <language> <project_path> [--multi-stage]"
        echo "💡 Use 'cc-docker-file-create -h' for detailed help"
        return 1
    fi
    
    if [[ ! -d "$project_path" ]]; then
        echo "❌ Project directory not found: $project_path"
        return 1
    fi
    
    echo "🐳 Creating optimized Dockerfile for $language project..."
    echo "📁 Project path: $project_path"
    [[ "$multi_stage" == true ]] && echo "🏗️ Using multi-stage build"
    
    # 📊 Analyze project structure
    local project_files=$(find "$project_path" -maxdepth 2 -type f | head -20)
    local package_files=""
    
    # 🔍 Look for package/dependency files
    case "$language" in
        node|javascript|js)
            package_files=$(find "$project_path" -name "package.json" -o -name "yarn.lock" -o -name "package-lock.json")
            ;;
        python|py)
            package_files=$(find "$project_path" -name "requirements.txt" -o -name "Pipfile" -o -name "poetry.lock" -o -name "setup.py")
            ;;
        go)
            package_files=$(find "$project_path" -name "go.mod" -o -name "go.sum")
            ;;
        java)
            package_files=$(find "$project_path" -name "pom.xml" -o -name "build.gradle" -o -name "gradle.properties")
            ;;
    esac
    
    echo "📦 Found package files: $package_files"
    
    # 🚀 Generate Dockerfile
    local build_type="single-stage"
    [[ "$multi_stage" == true ]] && build_type="multi-stage"
    
    run_claude_async "Create an optimized Dockerfile for a $language project using $build_type build approach.

Project structure analysis:
$project_files

Package/dependency files found:
$package_files

Requirements:
- Use appropriate base image for $language
- Implement proper layer caching for dependencies
- Follow security best practices (non-root user, minimal attack surface)
- Add health check if applicable
- Include .dockerignore suggestions
- Optimize for size and build speed
- Add comments explaining each section
- Handle both development and production scenarios" &
    
    wait_for_claude_jobs
    echo "✅ Dockerfile creation completed!"
}

# 🌐 cc-docker-network-setup - Setup Docker networks for multi-container applications
# 🎯 Usage: cc-docker-network-setup "network_name" [--subnet]
cc-docker-network-setup() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🌐 cc-docker-network-setup - Setup Docker networks"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-docker-network-setup <network_name> [--subnet <subnet>]"
        echo ""
        echo "📝 Parameters:"
        echo "  network_name    🌐 Name for the Docker network (required)"
        echo "  --subnet        📊 Custom subnet (optional, e.g., 172.20.0.0/16)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-docker-network-setup \"myapp-network\""
        echo "  cc-docker-network-setup \"prod-network\" --subnet 172.20.0.0/16"
        echo ""
        echo "💡 Creates networks with:"
        echo "  • Proper isolation"
        echo "  • Custom DNS resolution"
        echo "  • Security configurations"
        echo "  • Documentation and examples"
        return 0
    fi
    
    local network_name="$1"
    local subnet=""
    
    if [[ "$2" == "--subnet" && -n "$3" ]]; then
        subnet="$3"
    fi
    
    if [[ -z "$network_name" ]]; then
        echo "❌ Usage: cc-docker-network-setup <network_name> [--subnet <subnet>]"
        echo "💡 Use 'cc-docker-network-setup -h' for detailed help"
        return 1
    fi
    
    echo "🌐 Setting up Docker network: $network_name"
    [[ -n "$subnet" ]] && echo "📊 Custom subnet: $subnet"
    
    # 🚀 Generate network setup script
    run_claude_async "Create a comprehensive Docker network setup script for network '$network_name' with these requirements:

Network name: $network_name
Custom subnet: ${subnet:-auto}

Generate:
1. Docker network creation commands
2. Network configuration best practices
3. Security considerations and firewall rules
4. Service discovery setup
5. Example docker-compose integration
6. Troubleshooting guide
7. Cleanup commands

Include both bridge and overlay network options for different use cases." &
    
    wait_for_claude_jobs
    echo "✅ Docker network setup completed!"
}

# 📊 cc-docker-monitor-logs - Monitor and analyze container logs
# 🎯 Usage: cc-docker-monitor-logs [container_pattern] [--follow]
cc-docker-monitor-logs() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📊 cc-docker-monitor-logs - Monitor and analyze container logs"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-docker-monitor-logs [container_pattern] [--follow]"
        echo ""
        echo "📝 Parameters:"
        echo "  container_pattern  🔍 Container name pattern (optional, default: all)"
        echo "  --follow          👁️ Follow logs in real-time (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-docker-monitor-logs"
        echo "  cc-docker-monitor-logs \"webapp*\""
        echo "  cc-docker-monitor-logs \"api\" --follow"
        echo ""
        echo "📊 Provides:"
        echo "  • Log aggregation and analysis"
        echo "  • Error pattern detection"
        echo "  • Performance insights"
        echo "  • Automated alerts setup"
        return 0
    fi
    
    local container_pattern="${1:-*}"
    local follow=false
    [[ "$2" == "--follow" ]] && follow=true
    
    echo "📊 Setting up Docker log monitoring..."
    echo "🔍 Container pattern: $container_pattern"
    [[ "$follow" == true ]] && echo "👁️ Real-time following enabled"
    
    # 🔍 Get running containers
    local containers=$(docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || echo "No containers found")
    
    echo "🐳 Running containers:"
    echo "$containers"
    echo ""
    
    # 🚀 Generate log monitoring setup
    run_claude_async "Create a comprehensive Docker log monitoring solution for containers matching pattern '$container_pattern':

Current containers:
$containers

Generate:
1. Log aggregation script (docker logs commands)
2. Log analysis patterns for common issues
3. Error detection and alerting setup
4. Performance monitoring from logs
5. Log rotation and cleanup strategies
6. Real-time monitoring dashboard setup
7. Export options (JSON, CSV, etc.)

Include both one-time analysis and continuous monitoring options." &
    
    wait_for_claude_jobs
    echo "✅ Docker log monitoring setup completed!"
}

# 🧹 cc-docker-cleanup-system - Clean up Docker resources and optimize disk usage
# 🎯 Usage: cc-docker-cleanup-system [--aggressive] [--dry-run]
cc-docker-cleanup-system() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🧹 cc-docker-cleanup-system - Clean up Docker resources"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-docker-cleanup-system [--aggressive] [--dry-run]"
        echo ""
        echo "📝 Parameters:"
        echo "  --aggressive    💪 More thorough cleanup (optional)"
        echo "  --dry-run      👁️ Show what would be cleaned (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-docker-cleanup-system"
        echo "  cc-docker-cleanup-system --dry-run"
        echo "  cc-docker-cleanup-system --aggressive"
        echo ""
        echo "🧹 Cleans:"
        echo "  • Unused containers and images"
        echo "  • Dangling volumes and networks"
        echo "  • Build cache and temporary files"
        echo "  • Old logs and data"
        return 0
    fi
    
    local aggressive=false
    local dry_run=false
    
    for arg in "$@"; do
        case "$arg" in
            --aggressive) aggressive=true ;;
            --dry-run) dry_run=true ;;
        esac
    done
    
    echo "🧹 Docker system cleanup analysis..."
    [[ "$aggressive" == true ]] && echo "💪 Aggressive cleanup mode"
    [[ "$dry_run" == true ]] && echo "👁️ Dry run mode (no actual cleanup)"
    
    # 📊 Get current Docker system info
    local disk_usage=$(docker system df 2>/dev/null || echo "Docker not available")
    local containers=$(docker ps -a --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || echo "No containers")
    local images=$(docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" 2>/dev/null || echo "No images")
    
    echo "💾 Current Docker disk usage:"
    echo "$disk_usage"
    echo ""
    
    # 🚀 Generate cleanup script
    run_claude_async "Create a comprehensive Docker cleanup script with these parameters:

Aggressive mode: $aggressive
Dry run mode: $dry_run

Current system state:
$disk_usage

Containers:
$containers

Images:
$images

Generate:
1. Safe cleanup commands for unused resources
2. Aggressive cleanup options (if enabled)
3. Dry run output showing what would be cleaned
4. Disk space recovery estimates
5. Safety checks and confirmations
6. Rollback options for critical resources
7. Automated scheduling suggestions
8. Monitoring and reporting

Include both interactive and automated execution modes." &
    
    wait_for_claude_jobs
    echo "✅ Docker cleanup script generation completed!"
}

# 🔒 cc-docker-security-scan - Security scan containers and images
# 🎯 Usage: cc-docker-security-scan [image_name] [--detailed]
cc-docker-security-scan() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🔒 cc-docker-security-scan - Security scan containers and images"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-docker-security-scan [image_name] [--detailed]"
        echo ""
        echo "📝 Parameters:"
        echo "  image_name    🐳 Specific image to scan (optional, default: all local images)"
        echo "  --detailed    📊 Detailed vulnerability report (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-docker-security-scan"
        echo "  cc-docker-security-scan \"myapp:latest\""
        echo "  cc-docker-security-scan \"nginx:alpine\" --detailed"
        echo ""
        echo "🔒 Scans for:"
        echo "  • Known vulnerabilities (CVEs)"
        echo "  • Security misconfigurations"
        echo "  • Best practices compliance"
        echo "  • Secrets and sensitive data"
        return 0
    fi
    
    local image_name="$1"
    local detailed=false
    [[ "$2" == "--detailed" ]] && detailed=true
    
    echo "🔒 Docker security scan initialization..."
    [[ -n "$image_name" ]] && echo "🎯 Target image: $image_name" || echo "🎯 Scanning all local images"
    [[ "$detailed" == true ]] && echo "📊 Detailed reporting enabled"
    
    # 📊 Get images to scan
    local images_info
    if [[ -n "$image_name" ]]; then
        images_info=$(docker images "$image_name" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" 2>/dev/null || echo "Image not found")
    else
        images_info=$(docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" 2>/dev/null || echo "No images found")
    fi
    
    echo "🐳 Images to scan:"
    echo "$images_info"
    echo ""
    
    # 🚀 Generate security scan setup
    local scan_scope="all local images"
    [[ -n "$image_name" ]] && scan_scope="image: $image_name"
    
    run_claude_async "Create a comprehensive Docker security scanning solution for $scan_scope:

Target images:
$images_info

Detailed reporting: $detailed

Generate:
1. Security scanning script using available tools (docker scan, trivy, etc.)
2. Vulnerability assessment checklist
3. Security best practices validation
4. Configuration security review
5. Secret detection in images
6. Base image security recommendations
7. Compliance reporting (if detailed mode)
8. Remediation suggestions for found issues

Include both automated scanning and manual review procedures." &
    
    wait_for_claude_jobs
    echo "✅ Docker security scan setup completed!"
}

# 🆘 cc-docker-help - Show help for all docker functions
# 🎯 Usage: cc-docker-help [function_name]
cc-docker-help() {
    local function_name="$1"
    
    if [[ -n "$function_name" ]]; then
        # 📖 Try to call the specific function with -h flag
        if "$function_name" -h 2>/dev/null; then
            return 0
        else
            echo "❌ Function not found: $function_name"
            echo "💡 Available docker functions:"
            echo "   cc-docker-compose-generate, cc-docker-file-create, cc-docker-network-setup"
            echo "   cc-docker-monitor-logs, cc-docker-cleanup-system, cc-docker-security-scan"
            return 1
        fi
    else
        echo "🐳 Claude Docker Functions Help"
        echo "════════════════════════════════════════"
        echo ""
        echo "🚀 Quick Start:"
        echo "  cc-docker-compose-generate \"webapp\" postgres redis"
        echo "  cc-docker-file-create \"node\" \"./my-app\""
        echo "  cc-docker-cleanup-system --dry-run"
        echo ""
        echo "📚 Available Functions:"
        echo "  📄 cc-docker-compose-generate  - Generate docker-compose files"
        echo "  🐳 cc-docker-file-create       - Create optimized Dockerfiles"
        echo "  🌐 cc-docker-network-setup     - Setup Docker networks"
        echo "  📊 cc-docker-monitor-logs      - Monitor container logs"
        echo "  🧹 cc-docker-cleanup-system    - Clean up Docker resources"
        echo "  🔒 cc-docker-security-scan     - Security scan containers"
        echo ""
        echo "💡 Use 'cc-docker-help <function_name>' or '<function_name> -h' for specific help"
    fi
}

# 🎉 Docker module loaded message
echo "🐳 Docker module loaded! (cc-docker-*)"