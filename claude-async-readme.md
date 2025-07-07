# Claude Code Async Runner

A powerful Zsh script that enables parallel execution of Claude Code commands using zsh-async, allowing you to run multiple AI-powered code generation tasks simultaneously.

## 🚀 Features

- **Parallel Execution** - Run multiple Claude Code prompts concurrently
- **Real-time Progress** - Monitor job status and completion in real-time
- **Batch Processing** - Process multiple prompts from files
- **Custom Callbacks** - Define custom handlers for job completion
- **Output Management** - Automatic output capture and file saving
- **Job Control** - Start, stop, and monitor running jobs
- **Error Handling** - Comprehensive error reporting and timeout support

## 📋 Requirements

- Zsh shell
- [zsh-async](https://github.com/mafredri/zsh-async)
- Claude Code command-line tool

## 🔧 Installation

1. Install zsh-async:
```bash
git clone https://github.com/mafredri/zsh-async ~/.zsh-async
```

2. Download the Claude Code Async Runner script:
```bash
# 🚀 Download the complete performance suite!
curl -O https://raw.githubusercontent.com/your-repo/optimize-claude-performance.zsh
curl -O https://raw.githubusercontent.com/your-repo/autocomplete-claude-optimized.zsh
```

3. Source both scripts in your shell:
```bash
# 🚀 ONE-LINE PERFORMANCE BOOST!
source optimize-claude-performance.zsh

# 🎯 Optional: Enable smart autocompletion
source autocomplete-claude-optimized.zsh
```

Or add them to your `.zshrc` for permanent availability:
```bash
echo 'source /path/to/optimize-claude-performance.zsh' >> ~/.zshrc
echo 'source /path/to/autocomplete-claude-optimized.zsh' >> ~/.zshrc
```

4. 🎉 **NEW!** Test the utility functions:
```bash
# Quick test of the new caching functions
cc-cache-set "hello" "world" 300
cc-cache-get "hello"
claude_functions_help
```

## 🎯 Quick Start

### Run Multiple Tasks in Parallel

```bash
run_claude_parallel \
    "Create a Python web scraper for news articles" \
    "Write a bash script to monitor disk usage" \
    "Generate a React component for user authentication"
```

### Check Job Status

```bash
claude_job_status
```

### Wait for Completion

```bash
wait_for_claude_jobs 60  # Wait up to 60 seconds
```

## 📚 Basic Usage

### Single Async Task
```bash
run_claude_async "Write a function to validate email addresses"
```

### Batch Processing from File
```bash
# Create a prompts file
cat > prompts.txt << EOF
Create a Python REST API client
Write unit tests for a calculator class
Generate documentation for a Node.js project
EOF

# Process all prompts
claude_batch_process prompts.txt ./outputs/
```

### Custom Output Handling
```bash
# Run with output saved to file
run_claude_with_handler \
    "Generate API documentation" \
    "api_docs.md" \
    "my_custom_callback"
```

## 🛠️ Available Functions

### 🔧 **Core Async Functions**
| Function | Description |
|----------|-------------|
| `run_claude_parallel` | Execute multiple prompts in parallel |
| `run_claude_async` | Run a single prompt asynchronously |
| `claude_job_status` | Display currently running jobs |
| `stop_claude_jobs` | Stop all running jobs |
| `wait_for_claude_jobs` | Block until all jobs complete |
| `claude_batch_process` | Process prompts from a file |
| `run_claude_with_handler` | Run with custom callback function |
| `claude_async_usage` | Display help information |

### 💎 **NEW: Claude Functions Utility Library (40+ Functions!)**

#### 💾 **Caching Functions**
| Function | Description | Example |
|----------|-------------|---------|
| `cc-cache-set` | Store data in Redis cache with TTL | `cc-cache-set "user:123" "John" 300` |
| `cc-cache-get` | Retrieve data from cache | `cc-cache-get "user:123"` |
| `cc-cache-del` | Delete cache entry | `cc-cache-del "user:123"` |
| `cc-cache-stats` | Show cache statistics | `cc-cache-stats` |
| `cc-cache-flush` | Clear all cache (with safety prompt) | `cc-cache-flush` |

#### 🗄️ **Database Functions**
| Function | Description | Example |
|----------|-------------|---------|
| `mysql_async_insert` | Batch MySQL inserts | `mysql_async_insert "db" "users" "data.txt"` |
| `postgres_async_query` | Parallel PostgreSQL queries | `postgres_async_query "db" "queries.sql"` |
| `sqlite_backup_async` | Async SQLite backups | `sqlite_backup_async "app.db"` |

#### 📁 **File Processing Functions**
| Function | Description | Example |
|----------|-------------|---------|
| `batch_file_processor` | Process files with Claude Code | `batch_file_processor "*.js" "Add types"` |
| `markdown_enhancer` | Enhance all markdown files | `markdown_enhancer` |
| `css_optimizer` | Optimize CSS files | `css_optimizer "*.css"` |
| `json_validator` | Validate and format JSON | `json_validator "*.json"` |

#### 🐙 **Git Functions**
| Function | Description | Example |
|----------|-------------|---------|
| `git_commit_generator` | Generate smart commit messages | `git_commit_generator` |
| `git_tag_release` | Generate release notes | `git_tag_release "v1.0.0"` |
| `git_repo_analyzer` | Repository health check | `git_repo_analyzer` |

#### 🧪 **Testing & Quality Functions**
| Function | Description | Example |
|----------|-------------|---------|
| `test_generator` | Generate comprehensive tests | `test_generator "src/*.js" "jest"` |
| `security_scanner` | Basic security audit | `security_scanner` |
| `performance_monitor` | Monitor system performance | `performance_monitor 60` |

#### 🆘 **Help Functions**
| Function | Description | Example |
|----------|-------------|---------|
| `claude_functions_help` | Show help for all functions | `claude_functions_help [function_name]` |
| `claude_functions_status` | Show system status | `claude_functions_status` |

## 📝 Example Workflow

```bash
# 1. Start multiple code generation tasks
run_claude_parallel \
    "Create a Python data pipeline for CSV processing" \
    "Write a bash deployment script with rollback" \
    "Generate TypeScript interfaces from JSON schema"

# 2. Check progress
claude_job_status

# 3. Wait for completion
wait_for_claude_jobs

# 4. Results are automatically displayed as each job completes
```

## ⚡ Performance Tips

- Run related but independent tasks in parallel to save time
- Use batch processing for large numbers of similar prompts
- Set appropriate timeouts for long-running tasks
- Monitor system resources when running many parallel jobs

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## 📄 License

This project is open source and available under the MIT License.

## 🔗 See Also

- [Detailed Instructions](instructions.md) - Comprehensive usage guide
- [Claude Code Documentation](https://www.anthropic.com/claude-code) - Official Claude Code docs
- [zsh-async Documentation](https://github.com/mafredri/zsh-async) - Async library documentation