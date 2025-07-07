# 🚀 Async Claude Code Toolkit - Installation Guide

## 🎯 Quick Installation Options

### **Option 1: Clone & Use Directly** ⚡
```bash
# Clone the repository
git clone https://github.com/shoemoney/async-claude-code.git
cd async-claude-code

# Load the toolkit immediately
source optimize-claude-performance.zsh

# Check status
claude-perf-status

# Run tests
zsh tests/simple_test.zsh
```

### **Option 2: Copy to New Project** 📦
```bash
# Clone the toolkit
git clone https://github.com/shoemoney/async-claude-code.git

# Copy to your project
./async-claude-code/claude-init-preset.zsh /path/to/your/project

# Navigate to your project
cd /path/to/your/project

# Load the toolkit
source optimize-claude-performance.zsh
```

### **Option 3: Global Claude Code Integration** 🌐
```bash
# Clone the repository
git clone https://github.com/shoemoney/async-claude-code.git
cd async-claude-code

# Install globally for Claude Code
./install-preset-system.zsh

# Now use with any Claude Code /init command
claude init --preset=async-claude-code /path/to/new/project
```

---

## 🔧 **Detailed Installation Steps**

### 📋 **Prerequisites**
- **Zsh shell** (default on macOS, available on Linux)
- **Claude Code CLI** - [Install here](https://docs.anthropic.com/claude-code)
- **Git** (for cloning the repository)

### 🎯 **Optional Dependencies** (for full functionality)
```bash
# Redis (for 80% faster caching)
brew install redis        # macOS
sudo apt install redis    # Ubuntu/Debian

# MySQL (for database operations)
brew install mysql        # macOS
sudo apt install mysql-server  # Ubuntu/Debian

# Node.js (for enhanced test animations)
brew install node         # macOS
sudo apt install nodejs npm    # Ubuntu/Debian

# Docker (for container operations)
# Install from: https://docker.com
```

---

## 🚀 **Method 1: Direct Repository Usage**

### Step 1: Clone and Setup
```bash
# Clone the repository
git clone https://github.com/shoemoney/async-claude-code.git
cd async-claude-code

# Make scripts executable (if needed)
chmod +x *.zsh tests/*.zsh
```

### Step 2: Load the Toolkit
```bash
# Load all performance modules
source optimize-claude-performance.zsh

# Enable autocompletion
source autocomplete-claude-optimized.zsh
```

### Step 3: Verify Installation
```bash
# Check system optimization status
claude-perf-status

# Auto-tune for your system
claude-perf-tune

# Run basic tests
zsh tests/simple_test.zsh
```

### Step 4: Start Using! 🎉
```bash
# Example: Parallel Claude execution
run_claude_parallel "Explain this function" "Add error handling" "Write tests"

# Example: Cache some data
cc-cache "mykey" "myvalue" 3600

# Example: Process files in batches
batch_file_processor "*.js" "Add TypeScript types to this file"
```

---

## 📦 **Method 2: Copy Toolkit to Existing Project**

### Step 1: Get the Deployment Script
```bash
# Clone the toolkit repository
git clone https://github.com/shoemoney/async-claude-code.git
```

### Step 2: Deploy to Your Project
```bash
# Copy entire toolkit to your project
./async-claude-code/claude-init-preset.zsh /path/to/your/project

# Or copy to current directory
./async-claude-code/claude-init-preset.zsh .
```

### Step 3: What Gets Copied
The script copies all these files to your project:
```
your-project/
├── optimize-claude-performance.zsh      # 🚀 Main loader
├── claude_functions.zsh                 # ⚡ 40+ functions
├── autocomplete-claude-optimized.zsh    # 🧠 Tab completion
├── CLAUDE.md                           # 📋 Project guidance
├── claude-rules-commands.md            # 🎯 Complete reference
├── README.md                           # 📚 Full documentation
├── package.json                        # 📦 Node.js dependencies
├── .gitignore                          # 🚫 Git exclusions
├── tests/                              # 🧪 Test suite
│   ├── simple_test.zsh                 # Basic tests
│   ├── jazzy_test.zsh                  # Animated tests
│   ├── bulletproof_test.zsh            # 100% success tests
│   ├── ultra_jazzy_test.zsh            # All CLI effects
│   └── ultra_performance_test.zsh      # Performance benchmarks
├── modules/                            # 🔧 Specialized modules
│   ├── cache.zsh                       # Redis operations
│   ├── database.zsh                    # Database utilities
│   ├── files.zsh                       # File processing
│   ├── git.zsh                         # Git automation
│   └── docker.zsh                      # Docker operations
└── .backups/                           # 🗂️ Backup directory
```

### Step 4: Load and Use
```bash
cd /path/to/your/project

# Load the toolkit
source optimize-claude-performance.zsh

# Check status
claude-perf-status

# Start using the functions!
```

---

## 🌐 **Method 3: Global Claude Code Integration**

### Step 1: Clone and Install Globally
```bash
# Clone the repository
git clone https://github.com/shoemoney/async-claude-code.git
cd async-claude-code

# Install the preset system globally
./install-preset-system.zsh
```

### Step 2: What Gets Installed
The installer creates:
```
~/.claude/
├── presets.json                        # 📋 Preset registry
├── presets/async-claude-code/          # 📦 Preset directory
│   ├── toolkit/                        # 🔧 Full toolkit copy
│   ├── templates/                      # 📝 CLAUDE.md template
│   ├── config/                         # ⚙️ Preset configuration
│   └── init.zsh                        # 🚀 Initialization script
└── ASYNC_PRESET_USAGE.md               # 📚 Usage guide
```

### Step 3: Use with Claude Code
```bash
# Initialize any new project with the toolkit
claude init --preset=async-claude-code /path/to/new/project

# Or initialize current directory
claude init --preset=async-claude-code .

# The toolkit is automatically deployed and ready to use!
```

### Step 4: Verify Global Installation
```bash
# Check if preset is registered
cat ~/.claude/presets.json

# View usage guide
cat ~/.claude/ASYNC_PRESET_USAGE.md

# Test the preset
zsh ~/.claude/presets/async-claude-code/init.zsh ./test-project
```

---

## 🧪 **Verification & Testing**

### Basic Functionality Test
```bash
# Load the toolkit
source optimize-claude-performance.zsh

# Check system status
claude-perf-status

# Run basic tests
zsh tests/simple_test.zsh
```

### Performance Test
```bash
# Run performance benchmarks
zsh tests/ultra_performance_test.zsh

# Monitor system resources
claude-perf-monitor 30
```

### Visual Test (requires Node.js)
```bash
# Install Node.js dependencies
npm install

# Run ultra jazzy tests with all CLI effects
zsh tests/ultra_jazzy_test.zsh
```

### Cache Test (requires Redis)
```bash
# Start Redis server
redis-server

# Test caching functions
cc-cache "test" "Hello World" 300
cc-get "test"
cc-stats
```

---

## 🔧 **Configuration & Customization**

### Environment Variables
```bash
# Performance settings
export CLAUDE_PERFORMANCE_MODE="TURBO"    # CONSERVATIVE/STANDARD/TURBO
export CLAUDE_PARALLEL_JOBS="6"           # Number of concurrent jobs
export CLAUDE_BATCH_SIZE="10"             # Files per batch
export CLAUDE_CACHE_TTL="3600"           # Cache time-to-live (seconds)

# Directories
export CLAUDE_OUTPUT_DIR="./generated"    # Output directory
export CLAUDE_REDIS_HOST="localhost"      # Redis server host

# Timeouts
export CLAUDE_TIMEOUT="300"              # Operation timeout (seconds)
```

### Auto-tuning
```bash
# Let the system auto-detect optimal settings
claude-perf-tune

# Check what was configured
claude-perf-status
```

---

## 🆘 **Troubleshooting**

### Common Issues

**1. "Command not found" errors**
```bash
# Make sure scripts are executable
chmod +x *.zsh tests/*.zsh

# Load the toolkit
source optimize-claude-performance.zsh
```

**2. Redis connection errors**
```bash
# Start Redis server
redis-server

# Or install Redis
brew install redis        # macOS
sudo apt install redis    # Linux
```

**3. MySQL connection errors**
```bash
# Start MySQL
brew services start mysql     # macOS
sudo systemctl start mysql    # Linux

# Create test databases (optional)
mysql -u root -p -e "CREATE DATABASE test_db;"
```

**4. Performance issues**
```bash
# Check system resources
claude-perf-monitor 10

# Reduce parallel jobs
export CLAUDE_PARALLEL_JOBS="2"

# Use conservative mode
export CLAUDE_PERFORMANCE_MODE="CONSERVATIVE"
```

**5. Permission errors**
```bash
# Fix file permissions
chmod +x *.zsh tests/*.zsh modules/*.zsh

# Check directory permissions
ls -la
```

### Getting Help
```bash
# Function-specific help
claude_functions_help [function_name]

# List all functions
claude_functions_list

# Check function status
claude_functions_status

# View examples
claude_examples_show [category]
```

---

## 🎯 **Quick Start Commands**

### Essential Commands
```bash
source optimize-claude-performance.zsh   # Load toolkit
claude-perf-status                       # Check status
run_claude_parallel "p1" "p2" "p3"      # Parallel execution
cc-cache "key" "value" 3600             # Cache data
batch_file_processor "*.js" "prompt"    # Process files
zsh tests/simple_test.zsh               # Run tests
```

### Emergency Commands
```bash
stop_claude_jobs                        # Stop all jobs
cc-flush                                # Clear cache
claude_cleanup_jobs                     # Clean artifacts
project_cleaner aggressive              # Deep clean
```

---

## 📚 **Next Steps**

1. 📖 **Read the documentation**: Check out `claude-rules-commands.md` for complete command reference
2. 🧪 **Run tests**: Try different test suites to see all features
3. 🎯 **Customize**: Set environment variables for your workflow
4. 🚀 **Start coding**: Use parallel functions for 10x faster development!

---

🚀 **Powered by**: Async Claude Code Toolkit  
📺 **Inspired by**: IndyDevDan's incredible tutorials  
🔗 **Repository**: https://github.com/shoemoney/async-claude-code  
🆘 **Support**: Open an issue on GitHub