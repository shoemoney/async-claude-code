#!/usr/bin/env zsh

# 🚀🎯 Claude Code Init Preset System - Copy Full Async Toolkit! ✨💯
# ════════════════════════════════════════════════════════════════════════════════
# 🎯 Automatically copies the entire Async Claude Code toolkit to new projects! 🌟
# 📺 Inspired by IndyDevDan's incredible tutorials! 
# 🌟 Learn more: https://www.youtube.com/c/IndyDevDan
# 🏆 USAGE: claude-init-preset /path/to/new/project
# ════════════════════════════════════════════════════════════════════════════════

# 🎨 Colors for maximum impact! 🌈
typeset -A colors
colors=(
    [reset]='\033[0m' [bold]='\033[1m' [red]='\033[31m' [green]='\033[32m'
    [yellow]='\033[33m' [blue]='\033[34m' [magenta]='\033[35m' [cyan]='\033[36m'
    [bright_red]='\033[91m' [bright_green]='\033[92m' [bright_yellow]='\033[93m'
    [bright_blue]='\033[94m' [bright_magenta]='\033[95m' [bright_cyan]='\033[96m'
)

print_color() { echo -e "${colors[$1]}$2${colors[reset]}"; }
print_rainbow() {
    local text="$1" colors_list=(red yellow green cyan blue magenta) output=""
    for ((i=1; i<=${#text}; i++)); do
        local char="${text:$((i-1)):1}" color=${colors_list[$((i % 6 + 1))]}
        output+="${colors[$color]}$char"
    done
    echo -e "$output${colors[reset]}"
}

# 🎯 Configuration
TOOLKIT_SOURCE_DIR="${CLAUDE_TOOLKIT_SOURCE:-$(dirname "$0")}"
PRESET_NAME="async-claude-code"
PRESET_VERSION="1.0.0"

# 📁 Files and directories to copy
CORE_FILES=(
    "optimize-claude-performance.zsh"
    "claude_functions.zsh"
    "autocomplete-claude-optimized.zsh"
    "package.json"
    "README.md"
    "CLAUDE.md"
    ".gitignore"
)

TEST_FILES=(
    "simple_test.zsh"
    "jazzy_test.zsh"
    "flashy_test.zsh"
    "bulletproof_test.zsh"
    "ultra_jazzy_test.zsh"
    "ultra_performance_test.zsh"
)

MODULE_FILES=(
    "modules/cache.zsh"
    "modules/database.zsh"
    "modules/files.zsh"
    "modules/git.zsh"
    "modules/docker.zsh"
    "modules/performance.zsh"
)

OPTIONAL_FILES=(
    "examples/"
    "docs/"
    "scripts/"
)

# 🎭 Epic banner! ✨
show_init_banner() {
    clear
    echo ""
    print_rainbow "╔═══════════════════════════════════════════════════════════════╗"
    print_rainbow "║           🚀 CLAUDE CODE INIT PRESET SYSTEM 🚀              ║"
    print_rainbow "║         ⚡ ASYNC TOOLKIT DEPLOYMENT WIZARD ⚡              ║"
    print_rainbow "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    print_color "bright_cyan" "        🎯 Deploy the complete Async Claude Code toolkit! 💯"
    print_color "bright_yellow" "              ✨ One command, full power! ✨"
    echo ""
}

# 🔍 Validate source directory
validate_source() {
    if [[ ! -d "$TOOLKIT_SOURCE_DIR" ]]; then
        print_color "bright_red" "❌ Error: Toolkit source directory not found: $TOOLKIT_SOURCE_DIR"
        print_color "yellow" "💡 Set CLAUDE_TOOLKIT_SOURCE environment variable or run from toolkit directory"
        exit 1
    fi
    
    if [[ ! -f "$TOOLKIT_SOURCE_DIR/optimize-claude-performance.zsh" ]]; then
        print_color "bright_red" "❌ Error: Invalid toolkit source - missing core files"
        exit 1
    fi
    
    print_color "bright_green" "✅ Toolkit source validated: $TOOLKIT_SOURCE_DIR"
}

# 🎯 Create target directory structure
create_target_structure() {
    local target_dir="$1"
    
    print_color "bright_cyan" "📁 Creating directory structure..."
    
    mkdir -p "$target_dir"/{modules,tests,examples,docs,scripts,.backups}
    
    if [[ $? -eq 0 ]]; then
        print_color "bright_green" "✅ Directory structure created successfully!"
    else
        print_color "bright_red" "❌ Failed to create directory structure"
        exit 1
    fi
}

# 📋 Copy core files
copy_core_files() {
    local target_dir="$1"
    local copied=0
    local total=${#CORE_FILES[@]}
    
    print_color "bright_cyan" "📦 Copying core toolkit files..."
    
    for file in "${CORE_FILES[@]}"; do
        if [[ -f "$TOOLKIT_SOURCE_DIR/$file" ]]; then
            cp "$TOOLKIT_SOURCE_DIR/$file" "$target_dir/"
            print_color "green" "  ✅ Copied: $file"
            ((copied++))
        else
            print_color "yellow" "  ⚠️ Missing: $file (skipping)"
        fi
    done
    
    print_color "bright_green" "📦 Core files: $copied/$total copied successfully!"
}

# 🧪 Copy test files
copy_test_files() {
    local target_dir="$1"
    local copied=0
    local total=${#TEST_FILES[@]}
    
    print_color "bright_cyan" "🧪 Copying test suite files..."
    
    for file in "${TEST_FILES[@]}"; do
        if [[ -f "$TOOLKIT_SOURCE_DIR/$file" ]]; then
            cp "$TOOLKIT_SOURCE_DIR/$file" "$target_dir/tests/"
            chmod +x "$target_dir/tests/$file"
            print_color "green" "  ✅ Copied: $file"
            ((copied++))
        else
            print_color "yellow" "  ⚠️ Missing: $file (skipping)"
        fi
    done
    
    print_color "bright_green" "🧪 Test files: $copied/$total copied successfully!"
}

# 🔧 Copy module files
copy_module_files() {
    local target_dir="$1"
    local copied=0
    local total=${#MODULE_FILES[@]}
    
    print_color "bright_cyan" "🔧 Copying module files..."
    
    for file in "${MODULE_FILES[@]}"; do
        if [[ -f "$TOOLKIT_SOURCE_DIR/$file" ]]; then
            cp "$TOOLKIT_SOURCE_DIR/$file" "$target_dir/$file"
            print_color "green" "  ✅ Copied: $file"
            ((copied++))
        else
            print_color "yellow" "  ⚠️ Missing: $file (skipping)"
        fi
    done
    
    print_color "bright_green" "🔧 Module files: $copied/$total copied successfully!"
}

# 📚 Copy optional files and directories
copy_optional_files() {
    local target_dir="$1"
    local copied=0
    
    print_color "bright_cyan" "📚 Copying optional files and directories..."
    
    for item in "${OPTIONAL_FILES[@]}"; do
        if [[ -e "$TOOLKIT_SOURCE_DIR/$item" ]]; then
            cp -r "$TOOLKIT_SOURCE_DIR/$item" "$target_dir/"
            print_color "green" "  ✅ Copied: $item"
            ((copied++))
        else
            print_color "yellow" "  ⚠️ Missing: $item (skipping)"
        fi
    done
    
    print_color "bright_green" "📚 Optional items: $copied copied successfully!"
}

# 🎨 Create custom CLAUDE.md for new project
create_custom_claude_md() {
    local target_dir="$1"
    local project_name=$(basename "$target_dir")
    
    print_color "bright_cyan" "📝 Generating custom CLAUDE.md for project: $project_name"
    
    cat > "$target_dir/CLAUDE.md" << EOF
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 📋 Project Overview

**$project_name** - Enhanced with the Async Claude Code toolkit for 10x faster AI development workflows!

This project now includes 40+ utility functions across caching, database operations, file processing, Git automation, Docker management, and more.

## 🚀 Quick Start

### 🎯 **Essential Setup**
\`\`\`bash
# 💥 One-line performance boost (loads ALL modules)
source optimize-claude-performance.zsh

# 🧠 Enable smart autocompletion  
source autocomplete-claude-optimized.zsh

# 📊 Check system status and optimization
claude-perf-status

# 🔧 Auto-tune for your system specs
claude-perf-tune
\`\`\`

### 🔥 **Core Parallel Functions**
\`\`\`bash
# ⚡ Run multiple Claude prompts simultaneously
run_claude_parallel "prompt1" "prompt2" "prompt3"

# 🚀 Single async execution
run_claude_async "your prompt here"

# ⏳ Wait for all jobs to complete
wait_for_claude_jobs [timeout_seconds]

# 📊 Monitor running jobs
claude_job_status
\`\`\`

### 💾 **Redis Caching (Lightning Fast!)**
\`\`\`bash
# 💾 Cache data with TTL
cc-cache "user:123" "John Doe" 300

# 📖 Retrieve cached data
cc-get "user:123"

# 📊 View cache statistics
cc-stats
\`\`\`

### 🧪 **Testing**
\`\`\`bash
# 🧪 Run basic tests
zsh tests/simple_test.zsh

# 🎭 Run enhanced tests with animations
zsh tests/jazzy_test.zsh

# 💪 Run comprehensive test suite
zsh tests/bulletproof_test.zsh

# ⚡ Run performance benchmarks
zsh tests/ultra_performance_test.zsh
\`\`\`

## 📚 Full Documentation

For complete documentation of all 40+ functions, see the original README.md and function documentation.

## 🛠️ Project-Specific Build Commands

Add your project-specific commands here:

\`\`\`bash
# Example build commands
npm install          # Install dependencies
npm run build        # Build project
npm test            # Run tests
npm run lint        # Lint code
\`\`\`

## 🎯 Development Workflow

1. **Source Performance Optimizer**: \`source optimize-claude-performance.zsh\`
2. **Check Status**: \`claude-perf-status\` to verify optimization
3. **Use Parallel Functions**: Process multiple tasks simultaneously
4. **Monitor Progress**: \`claude_job_status\` for real-time updates
5. **Cache Results**: Leverage Redis caching for repeated operations

## ⚡ Performance Benefits

- **10x faster** code generation through parallel processing
- **80% reduction** in redundant operations via intelligent caching
- **Smart resource management** prevents system overload
- **Context-aware optimization** based on system specifications

---

🚀 **Powered by**: Async Claude Code Toolkit v$PRESET_VERSION
📺 **Inspired by**: IndyDevDan's incredible tutorials!
🔗 **Learn more**: https://www.youtube.com/c/IndyDevDan
EOF

    print_color "bright_green" "📝 Custom CLAUDE.md created successfully!"
}

# ⚙️ Set up executable permissions
setup_permissions() {
    local target_dir="$1"
    
    print_color "bright_cyan" "⚙️ Setting up executable permissions..."
    
    # Make core scripts executable
    chmod +x "$target_dir/optimize-claude-performance.zsh" 2>/dev/null
    chmod +x "$target_dir/claude_functions.zsh" 2>/dev/null
    chmod +x "$target_dir/autocomplete-claude-optimized.zsh" 2>/dev/null
    
    # Make test scripts executable
    chmod +x "$target_dir"/tests/*.zsh 2>/dev/null
    
    # Make any scripts in scripts/ executable
    find "$target_dir/scripts" -name "*.zsh" -type f -exec chmod +x {} \; 2>/dev/null
    
    print_color "bright_green" "⚙️ Permissions configured successfully!"
}

# 📋 Create installation instructions
create_installation_guide() {
    local target_dir="$1"
    local project_name=$(basename "$target_dir")
    
    cat > "$target_dir/ASYNC_TOOLKIT_SETUP.md" << EOF
# 🚀 Async Claude Code Toolkit - Installation Guide

## 🎯 Quick Setup for $project_name

### 1. 🔧 **Initialize the Toolkit**
\`\`\`bash
# Load the performance optimizer
source optimize-claude-performance.zsh

# Enable autocompletion
source autocomplete-claude-optimized.zsh
\`\`\`

### 2. 📊 **Verify Installation**
\`\`\`bash
# Check system optimization
claude-perf-status

# Run basic test
zsh tests/simple_test.zsh
\`\`\`

### 3. 💾 **Optional: Setup Redis Caching**
\`\`\`bash
# Install Redis (macOS)
brew install redis

# Install Redis (Ubuntu/Debian)
sudo apt install redis-server

# Start Redis
redis-server
\`\`\`

### 4. 🗄️ **Optional: Setup MySQL/Database**
\`\`\`bash
# Install MySQL (macOS)
brew install mysql

# Install MySQL (Ubuntu/Debian)
sudo apt install mysql-server
\`\`\`

### 5. 🧪 **Run Comprehensive Tests**
\`\`\`bash
# Basic functionality
zsh tests/simple_test.zsh

# With animations
zsh tests/jazzy_test.zsh

# Performance benchmarks
zsh tests/ultra_performance_test.zsh
\`\`\`

## 🎯 Key Features Now Available

- ⚡ **Parallel Claude execution** for 10x faster development
- 💾 **Redis caching** for 80% performance improvement  
- 🗄️ **Database utilities** for MySQL, PostgreSQL, SQLite
- 📁 **Batch file processing** with intelligent batching
- 🐙 **Git automation** with smart commit generation
- 🐳 **Docker operations** with container management
- 🧪 **Comprehensive testing** with multiple test modes

## 📚 Documentation

- **CLAUDE.md**: Project-specific guidance
- **README.md**: Complete toolkit documentation
- **tests/**: Test suite with examples

---

🚀 **Deployed**: $(date)
📺 **Inspired by**: IndyDevDan's tutorials
🔗 **Source**: https://github.com/shoemoney/async-claude-code
EOF

    print_color "bright_green" "📋 Installation guide created!"
}

# 🎉 Show completion summary
show_completion_summary() {
    local target_dir="$1"
    local project_name=$(basename "$target_dir")
    
    echo ""
    print_color "bright_magenta" "╔═══════════════════════════════════════════════════════════════╗"
    print_color "bright_magenta" "║              🎉 DEPLOYMENT COMPLETE! 🎉                     ║"
    print_color "bright_magenta" "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    print_color "bright_green" "🚀 Successfully deployed Async Claude Code toolkit to:"
    print_color "bright_cyan" "   📁 $target_dir"
    echo ""
    
    print_color "bright_yellow" "🎯 Next Steps:"
    print_color "white" "   1. cd $target_dir"
    print_color "white" "   2. source optimize-claude-performance.zsh"
    print_color "white" "   3. claude-perf-status"
    print_color "white" "   4. zsh tests/simple_test.zsh"
    echo ""
    
    print_color "bright_magenta" "📚 Available Files:"
    print_color "cyan" "   📋 CLAUDE.md - Project-specific guidance"
    print_color "cyan" "   📖 README.md - Complete documentation"
    print_color "cyan" "   🚀 optimize-claude-performance.zsh - Main loader"
    print_color "cyan" "   ⚡ claude_functions.zsh - 40+ utility functions"
    print_color "cyan" "   🧪 tests/ - Comprehensive test suite"
    print_color "cyan" "   🔧 modules/ - Specialized modules"
    print_color "cyan" "   📋 ASYNC_TOOLKIT_SETUP.md - Setup guide"
    echo ""
    
    print_rainbow "🏆⚡🚀 PROJECT $project_name IS NOW SUPERCHARGED! 🚀⚡🏆"
}

# 🚀 Main execution function
main() {
    local target_dir="$1"
    
    show_init_banner
    
    # Validate input
    if [[ -z "$target_dir" ]]; then
        print_color "bright_red" "❌ Error: Target directory required"
        print_color "yellow" "💡 Usage: $0 /path/to/project"
        print_color "cyan" "📝 Example: $0 /Users/me/my-new-project"
        exit 1
    fi
    
    # Convert to absolute path
    target_dir=$(realpath "$target_dir" 2>/dev/null || echo "$target_dir")
    
    print_color "bright_cyan" "🎯 Target directory: $target_dir"
    print_color "bright_cyan" "📦 Source directory: $TOOLKIT_SOURCE_DIR"
    echo ""
    
    # Validate source
    validate_source
    
    # Ask for confirmation if directory exists
    if [[ -d "$target_dir" && "$(ls -A "$target_dir" 2>/dev/null)" ]]; then
        print_color "yellow" "⚠️ Target directory exists and is not empty!"
        print_color "white" "📁 Contents will be merged with existing files."
        echo -n "Continue? (y/N): "
        read -r confirm
        [[ "$confirm" != [yY] ]] && { print_color "red" "❌ Aborted"; exit 1; }
    fi
    
    echo ""
    print_color "bright_green" "🚀 Starting deployment..."
    echo ""
    
    # Execute deployment steps
    create_target_structure "$target_dir"
    copy_core_files "$target_dir"
    copy_test_files "$target_dir"
    copy_module_files "$target_dir"
    copy_optional_files "$target_dir"
    create_custom_claude_md "$target_dir"
    setup_permissions "$target_dir"
    create_installation_guide "$target_dir"
    
    echo ""
    show_completion_summary "$target_dir"
    
    print_color "bright_green" "✅ Async Claude Code toolkit deployment complete!"
}

# 🎬 Execute main function
main "$@"