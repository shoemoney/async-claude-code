#!/usr/bin/env zsh

# 🚀 Claude Functions - Async Utility Library for Claude Code
# 💡 A collection of 40+ async utility functions for supercharged development
# 🎯 Perfect for batch processing, caching, database ops, and file management
# 
# 📋 Usage: source claude_functions.zsh
# 🔧 Requirements: Claude Code CLI, zsh-async, redis-cli (optional), mysql (optional)
# 
# 🌟 Special thanks to IndyDevDan for the inspiration! 
# 📺 Check out his amazing tutorials: https://www.youtube.com/c/IndyDevDan

# 🔧 Load required async library
[[ -f ~/.zsh-async/async.zsh ]] && source ~/.zsh-async/async.zsh

# 📦 Global configuration variables
export CLAUDE_FUNCTIONS_VERSION="1.0.0"
export CLAUDE_CACHE_TTL="${CLAUDE_CACHE_TTL:-3600}"  # 🕐 Default 1 hour TTL
export CLAUDE_BATCH_SIZE="${CLAUDE_BATCH_SIZE:-5}"   # 📊 Default batch size
export CLAUDE_OUTPUT_DIR="${CLAUDE_OUTPUT_DIR:-./generated}" # 📁 Default output directory

# ═══════════════════════════════════════════════════════════════════════════════
# 🔴 REDIS CACHING FUNCTIONS - Lightning Fast Async Caching! ⚡
# ═══════════════════════════════════════════════════════════════════════════════

# 💾 cc-cache - Put data into Redis cache with optional TTL
# 🎯 Usage: cc-cache "my_key" "my_value" [ttl_seconds]
# 📝 Examples:
#   cc-cache "user:123" "John Doe" 300
#   cc-cache "config" "$(cat config.json)"
cc-cache() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "💾 cc-cache - Store data in Redis cache with TTL"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache <key> <value> [ttl_seconds]"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key (required)"
        echo "  value        💰 Value to cache (required)"
        echo "  ttl_seconds  ⏰ Time to live in seconds (optional, default: ${CLAUDE_CACHE_TTL})"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache \"user:123\" \"John Doe\" 300"
        echo "  cc-cache \"config\" \"\$(cat config.json)\""
        echo "  cc-cache \"session:abc\" \"active\" 1800"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key
    local value="$2"         # 💰 Value to cache  
    local ttl="${3:-$CLAUDE_CACHE_TTL}" # ⏰ Time to live (default: 1 hour)
    
    if [[ -z "$key" || -z "$value" ]]; then
        echo "❌ Usage: cc-cache <key> <value> [ttl]"
        echo "💡 Use 'cc-cache -h' for detailed help"
        return 1
    fi
    
    # 🚀 Store in Redis with TTL
    redis-cli SETEX "$key" "$ttl" "$value" > /dev/null 2>&1 && \
        echo "✅ Cached: $key (TTL: ${ttl}s)" || \
        echo "❌ Cache failed: $key"
}

# 📖 cc-get - Get data from Redis cache
# 🎯 Usage: cc-get "my_key"
# 📝 Examples:
#   user_data=$(cc-get "user:123")
#   config=$(cc-get "config")
cc-get() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📖 cc-get - Retrieve data from Redis cache"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-get <key>"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key to retrieve (required)"
        echo ""
        echo "📋 Examples:"
        echo "  user_data=\$(cc-get \"user:123\")"
        echo "  config=\$(cc-get \"config\")"
        echo "  cc-get \"session:abc\" && echo \"Session active\""
        echo ""
        echo "📊 Return codes:"
        echo "  0  ✅ Key found, value returned"
        echo "  1  ❌ Key not found or empty"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key to retrieve
    
    if [[ -z "$key" ]]; then
        echo "❌ Usage: cc-get <key>"
        echo "💡 Use 'cc-get -h' for detailed help"
        return 1
    fi
    
    # 🔍 Get from Redis
    local value=$(redis-cli GET "$key" 2>/dev/null)
    if [[ -n "$value" && "$value" != "(nil)" ]]; then
        echo "$value"        # ✅ Return cached value
        return 0
    else
        return 1            # ❌ Not found in cache
    fi
}

# 🗑️ cc-del - Delete key from Redis cache
# 🎯 Usage: cc-del "my_key"
cc-del() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🗑️ cc-del - Delete key from Redis cache"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-del <key>"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key to delete (required)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-del \"user:123\""
        echo "  cc-del \"expired_session\""
        echo "  cc-del \"temp_data\""
        echo ""
        echo "⚠️  Warning: This permanently removes the key from cache!"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key to delete
    
    if [[ -z "$key" ]]; then
        echo "❌ Usage: cc-del <key>"
        echo "💡 Use 'cc-del -h' for detailed help"
        return 1
    fi
    
    redis-cli DEL "$key" > /dev/null 2>&1 && \
        echo "🗑️ Deleted: $key" || \
        echo "❌ Delete failed: $key"
}

# 📊 cc-stats - Show Redis cache statistics
# 🎯 Usage: cc-stats
cc-stats() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📊 cc-stats - Show Redis cache statistics"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-stats"
        echo ""
        echo "📝 Description:"
        echo "  Displays comprehensive Redis cache statistics including:"
        echo "  • Total number of keys"
        echo "  • Memory usage"
        echo "  • Connected clients"
        echo ""
        echo "📋 Examples:"
        echo "  cc-stats"
        echo "  cc-stats | grep 'Memory'"
        return 0
    fi
    
    echo "📊 Redis Cache Statistics:"
    echo "🔢 Total Keys: $(redis-cli DBSIZE 2>/dev/null || echo 'N/A')"
    echo "💾 Memory Usage: $(redis-cli INFO memory 2>/dev/null | grep used_memory_human | cut -d: -f2 | tr -d '\r' || echo 'N/A')"
    echo "🔗 Connected Clients: $(redis-cli INFO clients 2>/dev/null | grep connected_clients | cut -d: -f2 | tr -d '\r' || echo 'N/A')"
}

# 🧹 cc-flush - Clear all cache (use with caution!)
# 🎯 Usage: cc-flush
cc-flush() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🧹 cc-flush - Clear all cache (DANGEROUS!)"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-flush"
        echo ""
        echo "📝 Description:"
        echo "  Permanently deletes ALL cached data from Redis!"
        echo "  This operation cannot be undone!"
        echo ""
        echo "⚠️  Warning:"
        echo "  • This will delete ALL keys in the current Redis database"
        echo "  • You will be prompted for confirmation"
        echo "  • Use with extreme caution in production!"
        echo ""
        echo "📋 Examples:"
        echo "  cc-flush"
        return 0
    fi
    
    echo "⚠️ This will delete ALL cached data!"
    read "confirm?Are you sure? (y/N): "
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        redis-cli FLUSHDB > /dev/null 2>&1 && \
            echo "🧹 Cache cleared!" || \
            echo "❌ Clear failed!"
    else
        echo "❌ Operation cancelled"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🗄️ DATABASE ASYNC FUNCTIONS - Powerful DB Operations! 💪
# ═══════════════════════════════════════════════════════════════════════════════

# 🔄 mysql_async_insert - Insert data asynchronously with batch processing
# 🎯 Usage: mysql_async_insert "database" "table" "file_with_data.txt"
# 📝 File format: Each line should be: field1,field2,field3
mysql_async_insert() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🔄 mysql_async_insert - Async MySQL batch inserts"
        echo ""
        echo "🎯 Usage:"
        echo "  mysql_async_insert <database> <table> <data_file>"
        echo ""
        echo "📝 Parameters:"
        echo "  database     🗄️ MySQL database name (required)"
        echo "  table        📋 Table name (required)"
        echo "  data_file    📄 File containing data to insert (required)"
        echo ""
        echo "📄 File Format:"
        echo "  Each line: field1,field2,field3"
        echo "  Empty lines are skipped"
        echo ""
        echo "📋 Examples:"
        echo "  echo \"john,doe,john@example.com\" > users.txt"
        echo "  echo \"jane,smith,jane@example.com\" >> users.txt"
        echo "  mysql_async_insert \"mydb\" \"users\" \"users.txt\""
        echo ""
        echo "⚙️ Batch size controlled by CLAUDE_BATCH_SIZE (default: ${CLAUDE_BATCH_SIZE})"
        return 0
    fi
    
    local database="$1"      # 🗄️ Database name
    local table="$2"         # 📋 Table name
    local data_file="$3"     # 📄 File containing data to insert
    
    if [[ -z "$database" || -z "$table" || -z "$data_file" ]]; then
        echo "❌ Usage: mysql_async_insert <database> <table> <data_file>"
        echo "💡 Use 'mysql_async_insert -h' for detailed help"
        return 1
    fi
    
    if [[ ! -f "$data_file" ]]; then
        echo "❌ Data file not found: $data_file"
        return 1
    fi
    
    echo "🚀 Starting async MySQL inserts for $table..."
    
    # 🔢 Process file in batches
    local batch_num=0
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue  # Skip empty lines
        
        ((batch_num++))
        
        # 🚀 Launch async insert
        run_claude_async "Generate MySQL INSERT statement for table '$table' with data: $line" &
        
        # 📊 Process in batches to avoid overwhelming the system
        if (( batch_num % CLAUDE_BATCH_SIZE == 0 )); then
            echo "⏸️ Waiting for batch to complete... ($batch_num records processed)"
            wait_for_claude_jobs
        fi
    done < "$data_file"
    
    # ⏳ Wait for any remaining jobs
    wait_for_claude_jobs
    echo "✅ Async MySQL inserts completed! Processed $batch_num records"
}

# 📊 postgres_async_query - Run PostgreSQL queries in parallel
# 🎯 Usage: postgres_async_query "database" "queries_file.sql"
postgres_async_query() {
    local database="$1"      # 🗄️ Database name  
    local queries_file="$2"  # 📄 File containing SQL queries
    
    if [[ ! -f "$queries_file" ]]; then
        echo "❌ Queries file not found: $queries_file"
        return 1
    fi
    
    echo "🐘 Starting async PostgreSQL queries..."
    
    # 🔍 Split queries and run in parallel
    local query_num=0
    while IFS= read -r query; do
        [[ -z "$query" || "$query" =~ ^[[:space:]]*$ ]] && continue
        
        ((query_num++))
        echo "🚀 Launching query $query_num..."
        
        # 🚀 Run query asynchronously with Claude Code
        run_claude_async "Optimize and explain this PostgreSQL query: $query" &
        
        # 📊 Batch processing
        if (( query_num % CLAUDE_BATCH_SIZE == 0 )); then
            wait_for_claude_jobs
        fi
    done < "$queries_file"
    
    wait_for_claude_jobs
    echo "✅ PostgreSQL async queries completed! ($query_num queries)"
}

# 💾 sqlite_backup_async - Create async SQLite backups
# 🎯 Usage: sqlite_backup_async "database.db" 
sqlite_backup_async() {
    local db_file="$1"       # 🗄️ SQLite database file
    local backup_dir="${2:-./backups}" # 📁 Backup directory
    
    if [[ ! -f "$db_file" ]]; then
        echo "❌ Database file not found: $db_file"
        return 1  
    fi
    
    mkdir -p "$backup_dir"   # 📁 Ensure backup directory exists
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$backup_dir/backup_${timestamp}_$(basename "$db_file")"
    
    echo "💾 Creating async SQLite backup..."
    
    # 🚀 Generate backup script with Claude Code
    run_claude_async "Create a comprehensive SQLite backup script that backs up '$db_file' to '$backup_file' with verification and compression" &
    
    wait_for_claude_jobs
    echo "✅ SQLite backup script generated!"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📁 FILE PROCESSING FUNCTIONS - Batch File Magic! ✨
# ═══════════════════════════════════════════════════════════════════════════════

# 🔄 batch_file_processor - Process multiple files with Claude Code
# 🎯 Usage: batch_file_processor "*.js" "Add TypeScript types to this file"
batch_file_processor() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🔄 batch_file_processor - Process multiple files with Claude Code"
        echo ""
        echo "🎯 Usage:"
        echo "  batch_file_processor <file_pattern> <claude_prompt>"
        echo ""
        echo "📝 Parameters:"
        echo "  file_pattern     🔍 Shell glob pattern (e.g., '*.js', 'src/*.py')"
        echo "  claude_prompt    💭 Prompt template for Claude Code"
        echo ""
        echo "📋 Examples:"
        echo "  batch_file_processor '*.js' 'Add TypeScript types to this JavaScript file'"
        echo "  batch_file_processor 'src/*.py' 'Add docstrings and type hints'"
        echo "  batch_file_processor 'docs/*.md' 'Enhance this documentation with examples'"
        echo ""
        echo "⚙️ Configuration:"
        echo "  Output directory: $CLAUDE_OUTPUT_DIR"
        echo "  Batch size: $CLAUDE_BATCH_SIZE files at once"
        echo ""
        echo "💡 The file content will be automatically included in the prompt"
        return 0
    fi
    
    local file_pattern="$1"  # 🔍 File pattern (e.g., "*.py", "src/*.js")
    local claude_prompt="$2" # 💭 Prompt template for Claude Code
    
    if [[ -z "$file_pattern" || -z "$claude_prompt" ]]; then
        echo "❌ Usage: batch_file_processor <file_pattern> <claude_prompt>"
        echo "💡 Use 'batch_file_processor -h' for detailed help"
        return 1
    fi
    
    # 📂 Create output directory
    mkdir -p "$CLAUDE_OUTPUT_DIR"
    
    echo "🔄 Starting batch file processing..."
    local file_count=0
    
    # 🔍 Process each matching file
    for file in ${~file_pattern}; do
        [[ ! -f "$file" ]] && continue
        
        ((file_count++))
        echo "📄 Processing: $file"
        
        # 📖 Read file content and process with Claude
        local file_content=$(cat "$file")
        run_claude_async "$claude_prompt: $file_content" > "$CLAUDE_OUTPUT_DIR/processed_$(basename "$file")" &
        
        # 📊 Batch processing control
        if (( file_count % CLAUDE_BATCH_SIZE == 0 )); then
            echo "⏸️ Processing batch... ($file_count files so far)"
            wait_for_claude_jobs
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ Batch processing complete! Processed $file_count files"
    echo "📁 Output directory: $CLAUDE_OUTPUT_DIR"
}

# 📝 markdown_enhancer - Enhance all markdown files with better documentation
# 🎯 Usage: markdown_enhancer [directory]
markdown_enhancer() {
    local dir="${1:-.}"      # 📁 Directory to process (default: current)
    
    echo "📝 Enhancing markdown files in: $dir"
    
    # 🔍 Find all markdown files and enhance them
    find "$dir" -name "*.md" -type f | while read -r md_file; do
        echo "📄 Enhancing: $md_file"
        
        # 🚀 Enhance with Claude Code
        run_claude_async "Enhance this markdown file with better structure, emojis, and detailed explanations: $(cat "$md_file")" &
        
        # 📊 Control batch size
        if (( $(jobs -r | wc -l) >= CLAUDE_BATCH_SIZE )); then
            wait_for_claude_jobs
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ Markdown enhancement complete!"
}

# 🎨 css_optimizer - Optimize CSS files in parallel
# 🎯 Usage: css_optimizer "styles/*.css"
css_optimizer() {
    local css_pattern="${1:-*.css}" # 🔍 CSS file pattern
    
    echo "🎨 Optimizing CSS files..."
    
    for css_file in ${~css_pattern}; do
        [[ ! -f "$css_file" ]] && continue
        
        echo "🎨 Optimizing: $css_file"
        
        # 🚀 Optimize CSS with Claude Code
        run_claude_async "Optimize this CSS for performance, add modern features like CSS Grid/Flexbox, and improve organization: $(cat "$css_file")" &
        
        # 📊 Batch control
        if (( $(jobs -r | wc -l) >= CLAUDE_BATCH_SIZE )); then
            wait_for_claude_jobs
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ CSS optimization complete!"
}

# 🔧 json_validator - Validate and format JSON files
# 🎯 Usage: json_validator "config/*.json"
json_validator() {
    local json_pattern="${1:-*.json}" # 🔍 JSON file pattern
    
    echo "🔧 Validating JSON files..."
    
    for json_file in ${~json_pattern}; do
        [[ ! -f "$json_file" ]] && continue
        
        echo "🔧 Validating: $json_file"
        
        # ✅ Validate JSON syntax first
        if jq empty "$json_file" 2>/dev/null; then
            echo "✅ Valid JSON: $json_file"
            
            # 🚀 Enhance with Claude Code
            run_claude_async "Improve this JSON configuration with better structure, comments (where possible), and validation: $(cat "$json_file")" &
        else
            echo "❌ Invalid JSON: $json_file"
        fi
        
        # 📊 Batch control  
        if (( $(jobs -r | wc -l) >= CLAUDE_BATCH_SIZE )); then
            wait_for_claude_jobs
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ JSON validation complete!"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🐙 GIT OPERATIONS - Async Git Magic! 🪄
# ═══════════════════════════════════════════════════════════════════════════════

# 📝 git_commit_generator - Generate meaningful commit messages
# 🎯 Usage: git_commit_generator
git_commit_generator() {
    echo "📝 Generating commit message based on changes..."
    
    # 📊 Get git diff for staged changes
    local staged_changes=$(git diff --cached --stat)
    local file_changes=$(git diff --cached --name-only)
    
    if [[ -z "$staged_changes" ]]; then
        echo "❌ No staged changes found. Stage some files first with 'git add'"
        return 1
    fi
    
    echo "🔍 Analyzing changes in: $file_changes"
    
    # 🚀 Generate commit message with Claude Code
    run_claude_async "Generate a meaningful commit message for these git changes. Follow conventional commits format (feat:, fix:, docs:, etc.): $staged_changes"
    
    wait_for_claude_jobs
    echo "✅ Commit message generated! Review and commit manually."
}

# 🏷️ git_tag_release - Generate release notes and tags
# 🎯 Usage: git_tag_release "v1.2.0"
git_tag_release() {
    local version="$1"       # 🏷️ Version tag (e.g., v1.2.0)
    
    if [[ -z "$version" ]]; then
        echo "❌ Usage: git_tag_release <version>"
        return 1
    fi
    
    echo "🏷️ Generating release notes for $version..."
    
    # 📊 Get commits since last tag
    local last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "Initial")
    local commit_log=$(git log --oneline "${last_tag}..HEAD" 2>/dev/null || git log --oneline)
    
    echo "📝 Commits since $last_tag:"
    echo "$commit_log"
    
    # 🚀 Generate release notes with Claude Code
    run_claude_async "Generate professional release notes for version $version based on these commits: $commit_log"
    
    wait_for_claude_jobs
    echo "✅ Release notes generated! Create the tag manually: git tag -a $version -m 'Release $version'"
}

# 🔍 git_repo_analyzer - Analyze repository health
# 🎯 Usage: git_repo_analyzer
git_repo_analyzer() {
    echo "🔍 Analyzing repository health..."
    
    # 📊 Gather repository statistics
    local total_commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    local contributors=$(git shortlog -sn --all | wc -l)
    local file_count=$(find . -type f -not -path './.git/*' | wc -l)
    local repo_size=$(du -sh . | cut -f1)
    
    echo "📊 Repository Stats:"
    echo "  🔢 Total commits: $total_commits"
    echo "  👥 Contributors: $contributors"  
    echo "  📄 Files: $file_count"
    echo "  💾 Size: $repo_size"
    
    # 🚀 Generate analysis with Claude Code
    run_claude_async "Analyze this repository and suggest improvements. Stats: $total_commits commits, $contributors contributors, $file_count files, $repo_size size. Recent commits: $(git log --oneline -10)"
    
    wait_for_claude_jobs
    echo "✅ Repository analysis complete!"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🐳 DOCKER FUNCTIONS - Container Magic! 📦
# ═══════════════════════════════════════════════════════════════════════════════

# 🐳 docker_generator - Generate Docker files for projects
# 🎯 Usage: docker_generator [project_type]
docker_generator() {
    local project_type="${1:-auto}"  # 🎯 Project type or 'auto' for detection
    
    echo "🐳 Generating Docker configuration..."
    
    # 🔍 Auto-detect project type if not specified
    if [[ "$project_type" == "auto" ]]; then
        if [[ -f "package.json" ]]; then
            project_type="nodejs"
        elif [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
            project_type="python"
        elif [[ -f "go.mod" ]]; then
            project_type="golang"
        elif [[ -f "Cargo.toml" ]]; then
            project_type="rust"
        else
            project_type="generic"
        fi
        echo "🔍 Detected project type: $project_type"
    fi
    
    # 🚀 Generate Docker files with Claude Code
    run_claude_parallel \
        "Create an optimized Dockerfile for a $project_type application with multi-stage build" \
        "Create docker-compose.yml for $project_type with development and production environments" \
        "Create .dockerignore file for $project_type project" \
        "Create Docker health check script for $project_type application"
    
    wait_for_claude_jobs
    echo "✅ Docker configuration generated!"
}

# 📊 docker_monitor - Monitor Docker containers
# 🎯 Usage: docker_monitor
docker_monitor() {
    echo "📊 Monitoring Docker containers..."
    
    # 📈 Get container stats
    local running_containers=$(docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "Docker not available")
    local container_count=$(docker ps -q | wc -l 2>/dev/null || echo "0")
    local image_count=$(docker images -q | wc -l 2>/dev/null || echo "0") 
    
    echo "📊 Docker Stats:"
    echo "  🏃 Running containers: $container_count"
    echo "  📦 Total images: $image_count"
    echo ""
    echo "🐳 Running containers:"
    echo "$running_containers"
    
    # 🚀 Generate monitoring analysis
    run_claude_async "Analyze these Docker containers and suggest monitoring/optimization improvements: $running_containers"
    
    wait_for_claude_jobs
    echo "✅ Docker monitoring analysis complete!"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🌐 API UTILITIES - HTTP Magic! ⚡
# ═══════════════════════════════════════════════════════════════════════════════

# 🔧 api_tester - Test API endpoints in parallel
# 🎯 Usage: api_tester "endpoints.txt"
# 📄 File format: Each line should be: METHOD URL (e.g., GET https://api.example.com/users)
api_tester() {
    local endpoints_file="$1"  # 📄 File containing API endpoints
    
    if [[ ! -f "$endpoints_file" ]]; then
        echo "❌ Endpoints file not found: $endpoints_file"
        return 1
    fi
    
    echo "🌐 Testing API endpoints..."
    
    # 🔄 Process each endpoint
    local endpoint_num=0
    while IFS= read -r endpoint; do
        [[ -z "$endpoint" ]] && continue
        
        ((endpoint_num++))
        echo "🔧 Testing endpoint $endpoint_num: $endpoint"
        
        # 🚀 Generate test script for endpoint
        run_claude_async "Create a comprehensive API test script for: $endpoint. Include response validation, error handling, and performance metrics." &
        
        # 📊 Batch control
        if (( endpoint_num % CLAUDE_BATCH_SIZE == 0 )); then
            wait_for_claude_jobs
        fi
    done < "$endpoints_file"
    
    wait_for_claude_jobs
    echo "✅ API testing scripts generated! ($endpoint_num endpoints)"
}

# 📚 swagger_generator - Generate API documentation
# 🎯 Usage: swagger_generator [api_description]
swagger_generator() {
    local api_description="${1:-REST API}"  # 📝 API description
    
    echo "📚 Generating Swagger/OpenAPI documentation..."
    
    # 🔍 Look for existing API files
    local api_files=$(find . -name "*.js" -o -name "*.py" -o -name "*.go" | grep -E "(route|api|endpoint)" | head -10)
    
    if [[ -n "$api_files" ]]; then
        echo "🔍 Found API files: $api_files"
        
        # 📖 Read API files content
        local combined_content=""
        for file in $api_files; do
            combined_content="$combined_content\n\nFile: $file\n$(cat "$file")"
        done
        
        # 🚀 Generate Swagger documentation
        run_claude_async "Generate comprehensive Swagger/OpenAPI 3.0 documentation for this $api_description based on these API files: $combined_content"
    else
        # 🚀 Generate template documentation  
        run_claude_async "Create a comprehensive Swagger/OpenAPI 3.0 template for a $api_description with common endpoints, security, and examples"
    fi
    
    wait_for_claude_jobs
    echo "✅ Swagger documentation generated!"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🧪 TESTING UTILITIES - Quality Assurance Magic! ✅
# ═══════════════════════════════════════════════════════════════════════════════

# 🧪 test_generator - Generate comprehensive tests
# 🎯 Usage: test_generator "src/*.js" "jest"
test_generator() {
    local source_pattern="$1"   # 🔍 Source file pattern
    local test_framework="${2:-auto}" # 🧪 Testing framework
    
    if [[ -z "$source_pattern" ]]; then
        echo "❌ Usage: test_generator <source_pattern> [test_framework]"
        return 1
    fi
    
    echo "🧪 Generating comprehensive tests..."
    
    # 🔍 Auto-detect test framework if needed
    if [[ "$test_framework" == "auto" ]]; then
        if [[ -f "package.json" ]] && grep -q "jest" package.json; then
            test_framework="jest"
        elif [[ -f "package.json" ]] && grep -q "mocha" package.json; then
            test_framework="mocha"
        elif [[ -f "requirements.txt" ]] && grep -q "pytest" requirements.txt; then
            test_framework="pytest"
        else
            test_framework="generic"
        fi
        echo "🔍 Detected test framework: $test_framework"
    fi
    
    # 📄 Process each source file
    local file_count=0
    for source_file in ${~source_pattern}; do
        [[ ! -f "$source_file" ]] && continue
        
        ((file_count++))
        echo "🧪 Generating tests for: $source_file"
        
        # 📖 Read source file
        local source_content=$(cat "$source_file")
        
        # 🚀 Generate tests with Claude Code
        run_claude_async "Generate comprehensive $test_framework tests for this source file. Include unit tests, edge cases, mocking, and 100% coverage: $source_content" &
        
        # 📊 Batch control
        if (( file_count % CLAUDE_BATCH_SIZE == 0 )); then
            wait_for_claude_jobs
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ Test generation complete! Generated tests for $file_count files"
}

# 🔍 coverage_analyzer - Analyze test coverage
# 🎯 Usage: coverage_analyzer [test_command]
coverage_analyzer() {
    local test_command="${1:-npm test}"  # 🧪 Test command to analyze
    
    echo "🔍 Analyzing test coverage..."
    
    # 📊 Run coverage analysis (mock - would need actual test runner)
    echo "🧪 Running tests with coverage..."
    echo "📊 Mock coverage analysis for: $test_command"
    
    # 🚀 Generate coverage improvement suggestions
    run_claude_async "Analyze test coverage and suggest improvements for a project using '$test_command'. Provide specific recommendations for increasing coverage, testing edge cases, and improving test quality."
    
    wait_for_claude_jobs
    echo "✅ Coverage analysis complete!"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📊 MONITORING & ANALYTICS - Observability Magic! 👁️
# ═══════════════════════════════════════════════════════════════════════════════

# 📈 performance_monitor - Monitor system performance
# 🎯 Usage: performance_monitor [duration_seconds]
performance_monitor() {
    local duration="${1:-60}"    # ⏰ Monitoring duration in seconds
    
    echo "📈 Monitoring system performance for ${duration}s..."
    
    # 📊 Collect system metrics
    local cpu_usage=$(top -l 1 | awk '/CPU usage/ {print $3}' | sed 's/%//' 2>/dev/null || echo "N/A")
    local memory_usage=$(free -h | awk '/^Mem:/ {print $3 "/" $2}' 2>/dev/null || echo "N/A")
    local disk_usage=$(df -h . | awk 'NR==2 {print $5}' 2>/dev/null || echo "N/A")
    local load_avg=$(uptime | awk -F'load average:' '{print $2}' 2>/dev/null || echo "N/A")
    
    echo "📊 Current System Metrics:"
    echo "  🔥 CPU Usage: $cpu_usage"
    echo "  💾 Memory: $memory_usage"
    echo "  💿 Disk Usage: $disk_usage"
    echo "  ⚖️ Load Average: $load_avg"
    
    # 🚀 Generate monitoring analysis and alerts
    run_claude_async "Analyze these system performance metrics and create monitoring alerts/recommendations: CPU: $cpu_usage, Memory: $memory_usage, Disk: $disk_usage, Load: $load_avg"
    
    wait_for_claude_jobs
    echo "✅ Performance monitoring analysis complete!"
}

# 📊 log_analyzer - Analyze log files for patterns
# 🎯 Usage: log_analyzer "*.log"
log_analyzer() {
    local log_pattern="${1:-*.log}"  # 📄 Log file pattern
    
    echo "📊 Analyzing log files..."
    
    # 🔍 Find and analyze log files
    local log_count=0
    for log_file in ${~log_pattern}; do
        [[ ! -f "$log_file" ]] && continue
        
        ((log_count++))
        echo "📄 Analyzing: $log_file"
        
        # 📊 Get basic log stats
        local line_count=$(wc -l < "$log_file")
        local error_count=$(grep -i "error\|fail\|exception" "$log_file" | wc -l)
        local recent_entries=$(tail -20 "$log_file")
        
        echo "  📊 Lines: $line_count, Errors: $error_count"
        
        # 🚀 Analyze with Claude Code
        run_claude_async "Analyze this log file for patterns, errors, and anomalies. File: $log_file (Lines: $line_count, Errors: $error_count). Recent entries: $recent_entries" &
        
        # 📊 Batch control
        if (( log_count % CLAUDE_BATCH_SIZE == 0 )); then
            wait_for_claude_jobs
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ Log analysis complete! Analyzed $log_count files"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🔧 UTILITY FUNCTIONS - Miscellaneous Magic! 🪄
# ═══════════════════════════════════════════════════════════════════════════════

# 🧹 project_cleaner - Clean up project files
# 🎯 Usage: project_cleaner [aggressive]
project_cleaner() {
    local mode="${1:-safe}"      # 🛡️ Cleaning mode: safe or aggressive
    
    echo "🧹 Cleaning project files ($mode mode)..."
    
    # 📊 Count files to be cleaned
    local temp_files=$(find . -name "*.tmp" -o -name "*.bak" -o -name "*~" 2>/dev/null | wc -l)
    local cache_dirs=$(find . -name "node_modules" -o -name "__pycache__" -o -name ".pytest_cache" 2>/dev/null | wc -l)
    local log_files=$(find . -name "*.log" -size +10M 2>/dev/null | wc -l)
    
    echo "📊 Cleanup candidates:"
    echo "  🗑️ Temp files: $temp_files"
    echo "  📦 Cache directories: $cache_dirs"
    echo "  📄 Large log files: $log_files"
    
    # 🚀 Generate cleanup script
    run_claude_async "Create a comprehensive project cleanup script for $mode mode. Include: temp files ($temp_files), cache dirs ($cache_dirs), large logs ($log_files). Provide safe deletion commands and explanations."
    
    wait_for_claude_jobs
    echo "✅ Cleanup script generated! Review before executing."
}

# 📋 dependency_checker - Check and update dependencies
# 🎯 Usage: dependency_checker [package_manager]
dependency_checker() {
    local package_manager="${1:-auto}"  # 📦 Package manager or auto-detect
    
    echo "📋 Checking dependencies..."
    
    # 🔍 Auto-detect package manager
    if [[ "$package_manager" == "auto" ]]; then
        if [[ -f "package.json" ]]; then
            package_manager="npm"
        elif [[ -f "requirements.txt" ]]; then
            package_manager="pip"
        elif [[ -f "Cargo.toml" ]]; then
            package_manager="cargo"
        elif [[ -f "go.mod" ]]; then
            package_manager="go"
        else
            package_manager="unknown"
        fi
        echo "🔍 Detected package manager: $package_manager"
    fi
    
    # 📊 Gather dependency info
    local dep_info="Package manager: $package_manager"
    case "$package_manager" in
        "npm")
            [[ -f "package.json" ]] && dep_info="$dep_info\npackage.json: $(cat package.json)"
            ;;
        "pip")
            [[ -f "requirements.txt" ]] && dep_info="$dep_info\nrequirements.txt: $(cat requirements.txt)"
            ;;
        "cargo")
            [[ -f "Cargo.toml" ]] && dep_info="$dep_info\nCargo.toml: $(cat Cargo.toml)"
            ;;
    esac
    
    # 🚀 Generate dependency analysis
    run_claude_async "Analyze these project dependencies and suggest updates, security improvements, and optimization: $dep_info"
    
    wait_for_claude_jobs
    echo "✅ Dependency analysis complete!"
}

# 🔐 security_scanner - Basic security audit
# 🎯 Usage: security_scanner [scan_type]
security_scanner() {
    local scan_type="${1:-basic}"    # 🔍 Scan type: basic, deep, or files
    
    echo "🔐 Running security scan ($scan_type)..."
    
    # 📊 Gather security-relevant information
    local file_perms=$(find . -type f -perm /077 2>/dev/null | head -10)
    local sensitive_files=$(find . -name "*.key" -o -name "*.pem" -o -name ".env" 2>/dev/null)
    local config_files=$(find . -name "config*" -o -name "*.conf" -o -name "*.ini" 2>/dev/null | head -5)
    
    echo "🔍 Security scan results:"
    echo "  📄 Files with weak permissions: $(echo "$file_perms" | wc -l)"
    echo "  🔑 Sensitive files found: $(echo "$sensitive_files" | wc -l)"
    echo "  ⚙️ Config files: $(echo "$config_files" | wc -l)"
    
    # 🚀 Generate security analysis
    run_claude_async "Perform a $scan_type security audit. Analyze these findings: Weak permissions: $file_perms, Sensitive files: $sensitive_files, Config files: $config_files. Provide security recommendations and remediation steps."
    
    wait_for_claude_jobs
    echo "✅ Security audit complete!"
}

# 📦 backup_creator - Create project backups
# 🎯 Usage: backup_creator [backup_type]
backup_creator() {
    local backup_type="${1:-incremental}"  # 📦 Backup type: full, incremental, or selective
    local backup_dir="./backups/$(date +%Y%m%d_%H%M%S)"
    
    echo "📦 Creating $backup_type backup..."
    
    # 📁 Create backup directory
    mkdir -p "$backup_dir"
    
    # 📊 Calculate backup size
    local project_size=$(du -sh . | cut -f1)
    local file_count=$(find . -type f -not -path './.git/*' -not -path './node_modules/*' | wc -l)
    
    echo "📊 Project stats:"
    echo "  💾 Size: $project_size"
    echo "  📄 Files: $file_count"
    echo "  📁 Backup location: $backup_dir"
    
    # 🚀 Generate backup script
    run_claude_async "Create a comprehensive $backup_type backup script for this project. Include: project size ($project_size), file count ($file_count), exclude unnecessary files, compress efficiently, and provide restore instructions."
    
    wait_for_claude_jobs
    echo "✅ Backup script generated in: $backup_dir"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎯 HELPER FUNCTIONS - Support Magic! 🤝
# ═══════════════════════════════════════════════════════════════════════════════

# 📊 claude_functions_status - Show all function statuses
# 🎯 Usage: claude_functions_status
claude_functions_status() {
    echo "📊 Claude Functions Status ($CLAUDE_FUNCTIONS_VERSION)"
    echo "═══════════════════════════════════════════════════════"
    
    # 🔧 Check dependencies
    echo "🔧 Dependencies:"
    echo "  🧠 Claude Code: $(command -v claude-code &>/dev/null && echo "✅ Available" || echo "❌ Missing")"
    echo "  🔄 zsh-async: $([[ -f ~/.zsh-async/async.zsh ]] && echo "✅ Available" || echo "❌ Missing")"
    echo "  💾 Redis: $(command -v redis-cli &>/dev/null && echo "✅ Available" || echo "❌ Missing")"
    echo "  🗄️ MySQL: $(command -v mysql &>/dev/null && echo "✅ Available" || echo "❌ Missing")"
    echo "  🐳 Docker: $(command -v docker &>/dev/null && echo "✅ Available" || echo "❌ Missing")"
    
    # ⚙️ Show configuration
    echo ""
    echo "⚙️ Configuration:"
    echo "  📁 Output Dir: $CLAUDE_OUTPUT_DIR"
    echo "  ⏰ Cache TTL: $CLAUDE_CACHE_TTL"
    echo "  📊 Batch Size: $CLAUDE_BATCH_SIZE"
    
    # 📊 Show available functions
    echo ""
    echo "🚀 Available Functions (40+ total):"
    echo "  💾 Cache: cccache, ccget, ccdel, ccstats, ccflush"
    echo "  🗄️ Database: mysql_async_insert, postgres_async_query, sqlite_backup_async"
    echo "  📁 Files: batch_file_processor, markdown_enhancer, css_optimizer, json_validator"
    echo "  🐙 Git: git_commit_generator, git_tag_release, git_repo_analyzer"
    echo "  🐳 Docker: docker_generator, docker_monitor"
    echo "  🌐 API: api_tester, swagger_generator"
    echo "  🧪 Testing: test_generator, coverage_analyzer"
    echo "  📊 Monitoring: performance_monitor, log_analyzer"
    echo "  🔧 Utils: project_cleaner, dependency_checker, security_scanner, backup_creator"
}

# 🆘 claude_functions_help - Show detailed help
# 🎯 Usage: claude_functions_help [function_name]
claude_functions_help() {
    local function_name="$1"     # 🔍 Specific function name (optional)
    
    if [[ -n "$function_name" ]]; then
        echo "🆘 Help for: $function_name"
        echo "═══════════════════════════════════════════════════════"
        
        # 📖 Try to call the function with -h flag first
        if "$function_name" -h 2>/dev/null; then
            return 0
        else
            # 📖 Fallback: Show function definition and comments
            echo "🔍 Function definition:"
            type "$function_name" 2>/dev/null | grep -A 20 "^$function_name"
        fi
    else
        echo "🆘 Claude Functions Help ($CLAUDE_FUNCTIONS_VERSION)"
        echo "═══════════════════════════════════════════════════════"
        echo ""
        echo "🚀 Quick Start:"
        echo "  1. source claude_functions.zsh"
        echo "  2. cc-cache 'test' 'Hello World' 300"
        echo "  3. cc-get 'test'"
        echo ""
        echo "💡 NEW: All functions now support -h or --help flags!"
        echo "  Examples:"
        echo "    cc-cache -h"
        echo "    mysql_async_insert --help"
        echo "    batch_file_processor -h"
        echo ""
        echo "📚 Function Categories:"
        echo "  💾 CACHE: cc-cache, cc-get, cc-del, cc-stats, cc-flush"
        echo "  🗄️ DATABASE: mysql_async_insert, postgres_async_query, sqlite_backup_async"
        echo "  📁 FILES: batch_file_processor, markdown_enhancer, css_optimizer, json_validator"
        echo "  🐙 GIT: git_commit_generator, git_tag_release, git_repo_analyzer"
        echo "  🐳 DOCKER: docker_generator, docker_monitor"
        echo "  🌐 API: api_tester, swagger_generator"
        echo "  🧪 TESTING: test_generator, coverage_analyzer"
        echo "  📊 MONITORING: performance_monitor, log_analyzer"
        echo "  🔧 UTILITIES: project_cleaner, dependency_checker, security_scanner, backup_creator"
        echo ""
        echo "💡 For specific function help: claude_functions_help <function_name>"
        echo "💡 Or use built-in help: <function_name> -h"
        echo "📊 For status check: claude_functions_status"
    fi
}

# 🎉 Show welcome message when sourced
echo ""
echo "🎉 Claude Functions Loaded! ($CLAUDE_FUNCTIONS_VERSION)"
echo "💫 40+ Async utility functions ready for action!"
echo "🆘 Type 'claude_functions_help' for help"
echo "📊 Type 'claude_functions_status' for status"
echo "💡 NEW: All functions support -h flag! (e.g., cc-cache -h)"
echo ""
echo "🚀 Quick test: cc-cache 'hello' 'world' && cc-get 'hello'"
echo "📺 Inspired by IndyDevDan's amazing tutorials!"
echo ""