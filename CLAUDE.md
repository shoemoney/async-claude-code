# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 📋 Project Overview

This is a **Zsh-based async toolkit** that enables parallel Claude Code execution for dramatically faster AI development workflows. The project provides 40+ utility functions across caching, database operations, file processing, Git automation, Docker management, and more.

## 🚀 Common Commands

### 🎯 **Essential Setup**
```bash
# 💥 One-line performance boost (loads ALL modules)
source optimize-claude-performance.zsh

# 🧠 Enable smart autocompletion  
source autocomplete-claude-optimized.zsh

# 📊 Check system status and optimization
claude-perf-status

# 🔧 Auto-tune for your system specs
claude-perf-tune

# 📈 Monitor performance in real-time
claude-perf-monitor [duration_seconds]
```

### 🔥 **Core Parallel Functions**
```bash
# ⚡ Run multiple Claude prompts simultaneously
run_claude_parallel "prompt1" "prompt2" "prompt3"

# 🚀 Single async execution
run_claude_async "your prompt here"

# ⏳ Wait for all jobs to complete
wait_for_claude_jobs [timeout_seconds]

# 📊 Monitor running jobs
claude_job_status

# 🛑 Stop all running jobs  
stop_claude_jobs
```

### 💾 **Redis Caching (Lightning Fast!)**
```bash
# 💾 Cache data with TTL
cc-cache "user:123" "John Doe" 300

# 📖 Retrieve cached data
cc-get "user:123"

# 🗑️ Delete cache key
cc-del "user:123"

# 📊 View cache statistics
cc-stats

# 🧹 Clear all cache (DANGEROUS!)
cc-flush
```

### 📁 **Batch File Processing**
```bash
# 🔄 Process files in batches
batch_file_processor "*.js" "Add TypeScript types to this file"

# 📝 Enhance all markdown files
markdown_enhancer [directory]

# 🎨 Optimize CSS files
css_optimizer "styles/*.css"

# 🔧 Validate JSON files
json_validator "config/*.json"
```

### 🐙 **Git Automation**
```bash
# 📝 Generate smart commit messages
git_commit_generator

# 🏷️ Create release notes and tags
git_tag_release "v1.2.0"

# 🔍 Analyze repository health
git_repo_analyzer
```

### 🧪 **Testing & Quality**
```bash
# 🧪 Generate comprehensive tests
test_generator "src/*.js" "jest"

# 🔍 Analyze test coverage
coverage_analyzer [test_command]

# 🔐 Run security audit
security_scanner [scan_type]

# 📊 Monitor system performance
performance_monitor [duration_seconds]
```

### 🐳 **Docker Operations**
```bash
# 🐳 Generate Docker configuration
docker_generator [project_type]

# 📊 Monitor containers
docker_monitor
```

### 🗄️ **Database Operations**
```bash
# 🔄 Async MySQL batch inserts
mysql_async_insert "database" "table" "data_file.txt"

# 🐘 Parallel PostgreSQL queries
postgres_async_query "database" "queries.sql"

# 💾 Async SQLite backups
sqlite_backup_async "database.db" [backup_dir]
```

### 🔧 **Utilities**
```bash
# 🧹 Clean project files
project_cleaner [aggressive]

# 📋 Check dependencies
dependency_checker [package_manager]

# 📦 Create backups
backup_creator [backup_type]

# 📊 Analyze logs
log_analyzer "*.log"
```

### 🆘 **Help & Status**
```bash
# 🆘 Get comprehensive help
claude_functions_help [function_name]

# 📊 Check function status
claude_functions_status

# 💡 All functions support help flags
cc-cache -h
batch_file_processor --help
```

## 🏗️ Architecture & Key Components

### 📦 **Modular Architecture**
- **Core Optimizer**: `optimize-claude-performance.zsh` - Main loader and performance tuner
- **Function Library**: `claude_functions.zsh` - 40+ utility functions with built-in help
- **Specialized Modules**: Individual `.zsh` files for cache, database, files, git, docker operations
- **Test Suite**: Multiple test scripts (`*_test.zsh`) for validation
- **Autocompletion**: `autocomplete-claude-optimized.zsh` for tab completion

### 🎯 **Performance System**
- **Dual Mode Design**: Both async and parallel variants of core functions
- **Intelligent Batching**: Automatic batch size optimization based on system resources  
- **Resource Management**: CPU/RAM-aware job scheduling prevents system overload
- **Caching Layer**: Redis integration for 80% performance improvement
- **Retry Logic**: Exponential backoff for robust operation

### 🔧 **Configuration System**
```bash
# 🌐 Key Environment Variables
CLAUDE_BATCH_SIZE           # Files per batch (default: 5)
CLAUDE_PARALLEL_JOBS        # Concurrent jobs (default: 3)
CLAUDE_CACHE_TTL           # Cache TTL seconds (default: 3600)
CLAUDE_OUTPUT_DIR          # Output directory (default: ./generated)
CLAUDE_PERFORMANCE_MODE    # TURBO/STANDARD/CONSERVATIVE
CLAUDE_REDIS_HOST          # Redis host (default: localhost)
CLAUDE_TIMEOUT             # Operation timeout (default: 300s)
```

### 📊 **Auto-Detection Features**
- **System Specs**: CPU cores, RAM, load average for optimal configuration
- **Project Type**: Auto-detects Node.js, Python, Go, Rust projects
- **Package Manager**: npm, pip, cargo, go modules
- **Test Framework**: Jest, Mocha, pytest
- **Dependencies**: Redis, Docker, Git availability

## 🎯 Development Workflow

### 🚀 **Fast Development Pattern**
1. **Source Performance Optimizer**: `source optimize-claude-performance.zsh`
2. **Check Status**: `claude-perf-status` to verify optimization
3. **Use Parallel Functions**: Process multiple tasks simultaneously
4. **Monitor Progress**: `claude_job_status` for real-time updates
5. **Cache Results**: Leverage Redis caching for repeated operations

### 💡 **Best Practices**
- Start with `claude-perf-tune` for optimal system configuration
- Use batch processing for large file sets (`batch_file_processor`)
- Monitor system resources during intensive operations (`performance_monitor`)
- Leverage caching for repeated operations (`cc-cache`/`cc-get`)
- Test with small batches before scaling up
- Use function help flags (`-h`/`--help`) for guidance

### ⚡ **Performance Benefits**
- **10x faster** code generation through parallel processing
- **80% reduction** in redundant operations via intelligent caching
- **Smart resource management** prevents system overload
- **Context-aware optimization** based on system specifications
- **Modular loading** for faster startup times

## 🔧 Testing

```bash
# 🧪 Run basic functionality tests
zsh simple_test.zsh

# 🎭 Run enhanced tests with animations
zsh jazzy_test.zsh

# 🚀 Run comprehensive test suite
zsh ultra_jazzy_test.zsh

# 💪 Run bulletproof stress tests
zsh bulletproof_test.zsh

# ⚡ Run performance benchmarks
zsh ultra_performance_test.zsh
```

## 📚 Dependencies

### ✅ **Required**
- **Zsh Shell**: macOS default, available on Linux
- **Claude Code CLI**: [Installation guide](https://docs.anthropic.com/claude-code)
- **zsh-async**: `git clone https://github.com/mafredri/zsh-async ~/.zsh-async`

### 🎯 **Optional (Performance Enhancers)**
- **Redis**: For 80% faster caching (`brew install redis` or `apt install redis`)
- **Docker**: Container operations (`docker.com`)
- **MySQL/PostgreSQL**: Database functions
- **Node.js**: For package.json processing

## 💡 Tips

- Use `claude-perf-monitor` during heavy operations to watch system resources
- Set `CLAUDE_BATCH_SIZE` lower on resource-constrained systems
- Enable Redis caching for dramatic performance improvements
- Use sequential naming functions for race-condition-free file generation
- Leverage the help system: every function supports `-h` or `--help`
- Start with small test batches before scaling to large operations