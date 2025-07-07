# 🎯 Claude Code Rules & Commands Reference

## 🚀 Core Async Toolkit Commands

### ⚡ **Performance & Optimization**
```bash
# 🎯 Essential Setup Commands
source optimize-claude-performance.zsh    # Load all performance modules
claude-perf-status                        # Check optimization status  
claude-perf-tune                         # Auto-tune for system specs
claude-perf-monitor [duration]           # Monitor performance real-time

# 🔧 Configuration Commands
export CLAUDE_PERFORMANCE_MODE="TURBO"   # Set performance mode
export CLAUDE_PARALLEL_JOBS="6"          # Set concurrent job limit
export CLAUDE_BATCH_SIZE="10"            # Set batch processing size
export CLAUDE_CACHE_TTL="3600"          # Set cache time-to-live
```

### 🔄 **Parallel Processing Commands**
```bash
# ⚡ Parallel Execution
run_claude_parallel "prompt1" "prompt2" "prompt3"  # Run multiple prompts
run_claude_async "your prompt here"                # Single async execution
wait_for_claude_jobs [timeout]                     # Wait for completion
claude_job_status                                   # Monitor running jobs
stop_claude_jobs                                    # Stop all jobs

# 📊 Job Management
claude_queue_status                                 # View job queue
claude_job_history                                  # View job history
claude_cleanup_jobs                                 # Cleanup completed jobs
```

### 💾 **Redis Caching Commands**
```bash
# 💎 Core Cache Operations
cc-cache "key" "value" [ttl]              # Store data with TTL
cc-get "key"                              # Retrieve cached data
cc-del "key"                              # Delete cache key
cc-exists "key"                           # Check if key exists
cc-ttl "key"                              # Get time-to-live

# 📊 Cache Management
cc-stats                                  # View cache statistics
cc-flush                                  # Clear ALL cache (DANGEROUS!)
cc-keys "pattern"                         # Find keys by pattern
cc-info                                   # Redis server info
cc-ping                                   # Test Redis connection
```

### 📁 **Batch File Processing Commands**
```bash
# 🔄 File Processing
batch_file_processor "*.js" "prompt"      # Process files in batches
markdown_enhancer [directory]             # Enhance markdown files
css_optimizer "styles/*.css"              # Optimize CSS files
json_validator "config/*.json"            # Validate JSON files
code_formatter "src/**/*.js"              # Format code files

# 📋 File Operations
sequential_file_processor "*.ts" "prompt" # Process files sequentially
bulk_file_renamer "old_pattern" "new"     # Rename files in bulk
file_content_replacer "find" "replace"    # Replace content across files
```

### 🐙 **Git Automation Commands**
```bash
# 📝 Git Operations
git_commit_generator                       # Generate smart commit messages
git_tag_release "v1.2.0"                 # Create release with notes
git_repo_analyzer                         # Analyze repository health
git_branch_cleaner                        # Clean merged branches
git_commit_squash [count]                 # Squash recent commits

# 🔍 Git Analysis
git_file_history "filename"               # Analyze file change history
git_contributor_stats                     # Show contributor statistics
git_hotspot_analyzer                      # Find code hotspots
```

### 🗄️ **Database Commands**
```bash
# 🔄 MySQL Operations
mysql_async_insert "db" "table" "file"    # Async batch inserts
mysql_backup_async "database" [dir]       # Async database backup
mysql_query_parallel "db" "queries.sql"   # Parallel query execution

# 🐘 PostgreSQL Operations
postgres_async_query "db" "query"         # Async PostgreSQL queries
postgres_backup_scheduled "db" "cron"     # Schedule backups

# 💾 SQLite Operations
sqlite_backup_async "db.sqlite" [dir]     # Async SQLite backup
sqlite_optimize "database.db"             # Optimize SQLite database
```

### 🧪 **Testing Commands**
```bash
# 🎭 Test Execution
zsh tests/simple_test.zsh                 # Basic functionality tests
zsh tests/jazzy_test.zsh                  # Enhanced animated tests  
zsh tests/flashy_test.zsh                 # Ultra flashy visual tests
zsh tests/bulletproof_test.zsh            # 100% success guaranteed tests
zsh tests/ultra_jazzy_test.zsh            # All CLI magic effects
zsh tests/ultra_performance_test.zsh      # High-performance benchmarks

# 🔍 Test Analysis
test_generator "src/*.js" "jest"          # Generate comprehensive tests
coverage_analyzer [test_command]          # Analyze test coverage
test_performance_benchmark                # Benchmark test execution
```

### 🐳 **Docker Commands**
```bash
# 🐳 Docker Operations
docker_generator [project_type]           # Generate Docker config
docker_monitor                           # Monitor containers
docker_cleanup                           # Clean unused containers/images
docker_health_check "container"          # Check container health

# 📊 Docker Management
docker_logs_analyzer "container"         # Analyze container logs
docker_performance_monitor              # Monitor Docker performance
```

### 🔧 **Utility Commands**
```bash
# 🧹 Project Management
project_cleaner [aggressive]              # Clean project files
dependency_checker [package_manager]      # Check dependencies
backup_creator [backup_type]              # Create project backups
log_analyzer "*.log"                      # Analyze log files

# 📊 System Monitoring
performance_monitor [duration]            # Monitor system performance
memory_analyzer                          # Analyze memory usage
disk_space_monitor                       # Monitor disk usage
process_analyzer                         # Analyze running processes
```

### 🆘 **Help & Documentation Commands**
```bash
# 🆘 Help System
claude_functions_help [function_name]     # Get comprehensive help
claude_functions_status                   # Check function status
claude_functions_list                     # List all available functions

# 📚 Documentation
claude_generate_docs                      # Generate function documentation
claude_examples_show [category]           # Show usage examples
claude_changelog                         # View toolkit changelog
```

## 🛡️ **Coding Rules & Best Practices**

### ✅ **DO - Best Practices**
- ✅ Always use `source optimize-claude-performance.zsh` first
- ✅ Check system status with `claude-perf-status` before intensive operations
- ✅ Use parallel functions for multiple file operations
- ✅ Leverage Redis caching for repeated operations (`cc-cache`/`cc-get`)
- ✅ Use batch processing for large file sets (`batch_file_processor`)
- ✅ Monitor system resources during intensive operations
- ✅ Test with small batches before scaling up
- ✅ Use function help flags (`-h`/`--help`) for guidance
- ✅ Clean up temporary files and cache when done
- ✅ Use sequential naming for race-condition-free operations

### ❌ **DON'T - Avoid These**
- ❌ Never run intensive operations without checking system status first
- ❌ Don't skip resource monitoring during large operations
- ❌ Avoid using `cc-flush` unless absolutely necessary (clears ALL cache)
- ❌ Don't run unlimited parallel jobs (respect `CLAUDE_PARALLEL_JOBS`)
- ❌ Never ignore cache TTL settings (set appropriate expiration)
- ❌ Don't process large files without batching
- ❌ Avoid running multiple performance tests simultaneously
- ❌ Don't forget to clean up test artifacts
- ❌ Never hardcode system-specific values (use auto-detection)

### 🎯 **Performance Guidelines**
- 🚀 **Start Small**: Test with 5-10 files before processing hundreds
- ⚡ **Monitor Resources**: Use `claude-perf-monitor` during intensive tasks
- 💾 **Cache Wisely**: Set appropriate TTL values for different data types
- 🔄 **Batch Intelligently**: Adjust `CLAUDE_BATCH_SIZE` based on file sizes
- 📊 **Track Progress**: Use progress monitoring functions for long operations
- 🧹 **Clean Regularly**: Run cleanup functions to maintain performance

### 🔧 **Configuration Rules**
```bash
# 🎯 Environment Variables (Required)
export CLAUDE_BATCH_SIZE="5"             # Files per batch (1-20)
export CLAUDE_PARALLEL_JOBS="3"          # Concurrent jobs (1-10)
export CLAUDE_CACHE_TTL="3600"          # Cache TTL seconds (300-86400)
export CLAUDE_OUTPUT_DIR="./generated"   # Output directory
export CLAUDE_TIMEOUT="300"             # Operation timeout (60-1800)

# 🚀 Performance Modes
export CLAUDE_PERFORMANCE_MODE="TURBO"   # CONSERVATIVE/STANDARD/TURBO
export CLAUDE_REDIS_HOST="localhost"     # Redis server host
export CLAUDE_MYSQL_HOST="localhost"     # MySQL server host

# 🧪 Testing Configuration
export CLAUDE_TEST_MODE="STANDARD"       # BASIC/STANDARD/COMPREHENSIVE
export CLAUDE_LOG_LEVEL="INFO"          # DEBUG/INFO/WARN/ERROR
```

### 📋 **File Organization Rules**
```bash
# 📁 Directory Structure
project/
├── optimize-claude-performance.zsh      # Main performance loader
├── claude_functions.zsh                 # Core function library
├── autocomplete-claude-optimized.zsh    # Tab completion
├── CLAUDE.md                           # Project guidance
├── modules/                            # Specialized modules
│   ├── cache.zsh                      # Redis cache operations
│   ├── database.zsh                   # Database utilities
│   ├── files.zsh                      # File processing
│   ├── git.zsh                        # Git automation
│   └── docker.zsh                     # Docker operations
├── tests/                              # Test suite
│   ├── simple_test.zsh                # Basic tests
│   ├── jazzy_test.zsh                 # Animated tests
│   └── ultra_performance_test.zsh     # Performance tests
└── .backups/                          # Backup directory
```

### 🎨 **Code Style Rules**
- 🎭 **Comments**: Extremely detailed with emojis (🛠️ TODO, ⚠️ WARNING, 🐛 DEBUG)
- 📝 **Functions**: Descriptive names with underscores (`mysql_async_insert`)
- 🔧 **Variables**: UPPERCASE for globals, lowercase for locals
- 🎯 **Error Handling**: Always use proper error checking and cleanup
- 📊 **Logging**: Include operation timing and resource usage info
- ✨ **Emojis**: Liberal use in comments and user-facing messages

### 🧪 **Testing Rules**
- 🎯 **Always Test**: Run basic tests before using new functions
- 📊 **Gradual Scale**: Start with small datasets, scale up gradually
- 🔍 **Monitor Resources**: Watch CPU/RAM during performance tests
- 🧹 **Clean Up**: Remove test artifacts after completion
- 📋 **Document Results**: Record performance benchmarks for optimization

### 🔒 **Security Rules**
- 🛡️ **Credentials**: Never hardcode passwords or API keys
- 🔐 **Cache Security**: Don't cache sensitive data without encryption
- 📁 **File Permissions**: Ensure proper file permissions for scripts
- 🌐 **Network Security**: Validate Redis/MySQL connection security
- 🧪 **Test Data**: Use non-sensitive data for testing

---

## 🎯 **Quick Reference Card**

### 🚀 **Most Used Commands**
```bash
source optimize-claude-performance.zsh   # Load toolkit
claude-perf-status                       # Check status
run_claude_parallel "p1" "p2" "p3"      # Parallel execution
cc-cache "key" "value" 3600             # Cache data
batch_file_processor "*.js" "prompt"    # Process files
zsh tests/simple_test.zsh               # Run tests
```

### 📊 **Emergency Commands**
```bash
stop_claude_jobs                        # Stop all running jobs
cc-flush                                # Clear ALL cache
claude_cleanup_jobs                     # Clean up job artifacts
project_cleaner aggressive              # Deep clean project
```

---

🚀 **Powered by**: Async Claude Code Toolkit  
📺 **Inspired by**: IndyDevDan's incredible tutorials  
🔗 **Learn more**: https://www.youtube.com/c/IndyDevDan