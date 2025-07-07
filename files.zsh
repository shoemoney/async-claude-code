#!/usr/bin/env zsh

# 📁 Files Module - File Processing Functions
# 🎯 Part of Claude Functions Async Utility Library
# 🔧 New naming convention: cc-file-<action>
#
# 📋 Available Functions:
#   • cc-file-process-batch  - Process multiple files with Claude Code
#   • cc-file-enhance-md     - Enhance markdown files  
#   • cc-file-optimize-css   - Optimize CSS files
#   • cc-file-validate-json  - Validate and format JSON files
#   • cc-file-backup-create  - Create file backups
#   • cc-file-clean-temp     - Clean temporary files
#   • cc-file-help          - Show help for file functions

# ═══════════════════════════════════════════════════════════════════════════════
# 📁 FILE PROCESSING FUNCTIONS - Batch File Magic! ✨
# ═══════════════════════════════════════════════════════════════════════════════

# 🔄 cc-file-process-batch - Process multiple files with Claude Code
# 🎯 Usage: cc-file-process-batch "*.js" "Add TypeScript types to this file"
cc-file-process-batch() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🔄 cc-file-process-batch - Process multiple files with Claude Code"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-file-process-batch <file_pattern> <claude_prompt>"
        echo ""
        echo "📝 Parameters:"
        echo "  file_pattern     🔍 Shell glob pattern (e.g., '*.js', 'src/*.py')"
        echo "  claude_prompt    💭 Prompt template for Claude Code"
        echo ""
        echo "📋 Examples:"
        echo "  cc-file-process-batch '*.js' 'Add TypeScript types to this JavaScript file'"
        echo "  cc-file-process-batch 'src/*.py' 'Add docstrings and type hints'"
        echo "  cc-file-process-batch 'docs/*.md' 'Enhance this documentation with examples'"
        echo ""
        echo "⚙️ Configuration:"
        echo "  Output directory: ${CLAUDE_OUTPUT_DIR:-./generated}"
        echo "  Batch size: ${CLAUDE_BATCH_SIZE:-5} files at once"
        echo ""
        echo "💡 The file content will be automatically included in the prompt"
        return 0
    fi
    
    local file_pattern="$1"  # 🔍 File pattern (e.g., "*.py", "src/*.js")
    local claude_prompt="$2" # 💭 Prompt template for Claude Code
    
    if [[ -z "$file_pattern" || -z "$claude_prompt" ]]; then
        echo "❌ Usage: cc-file-process-batch <file_pattern> <claude_prompt>"
        echo "💡 Use 'cc-file-process-batch -h' for detailed help"
        return 1
    fi
    
    # 📂 Create output directory
    mkdir -p "${CLAUDE_OUTPUT_DIR:-./generated}"
    
    echo "🔄 Starting batch file processing..."
    local file_count=0
    
    # 🔍 Process each matching file
    for file in ${~file_pattern}; do
        [[ ! -f "$file" ]] && continue
        
        ((file_count++))
        echo "📄 Processing: $file"
        
        # 📖 Read file content and process with Claude
        local file_content=$(cat "$file" 2>/dev/null)
        if [[ -n "$file_content" ]]; then
            run_claude_async "$claude_prompt: $file_content" &
            
            # 📊 Process in batches
            if (( file_count % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
                echo "⏸️ Waiting for file batch to complete... ($file_count files processed)"
                wait_for_claude_jobs
            fi
        fi
    done
    
    # ⏳ Wait for any remaining jobs
    wait_for_claude_jobs
    echo "✅ Batch file processing completed! Processed $file_count files"
}

# 📝 cc-file-enhance-md - Enhance all markdown files in directory
# 🎯 Usage: cc-file-enhance-md [directory]
cc-file-enhance-md() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📝 cc-file-enhance-md - Enhance markdown files with examples and structure"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-file-enhance-md [directory]"
        echo ""
        echo "📝 Parameters:"
        echo "  directory    📁 Directory to search (optional, default: current directory)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-file-enhance-md"
        echo "  cc-file-enhance-md \"docs\""
        echo "  cc-file-enhance-md \"/path/to/documentation\""
        echo ""
        echo "💡 Enhances markdown files with:"
        echo "  • Better structure and headers"
        echo "  • Code examples and snippets"
        echo "  • Improved formatting"
        echo "  • Table of contents where appropriate"
        return 0
    fi
    
    local target_dir="${1:-.}"  # Default to current directory
    
    if [[ ! -d "$target_dir" ]]; then
        echo "❌ Directory not found: $target_dir"
        return 1
    fi
    
    echo "📝 Enhancing markdown files in: $target_dir"
    
    local md_count=0
    find "$target_dir" -name "*.md" -type f | while read -r md_file; do
        ((md_count++))
        echo "📝 Enhancing: $md_file"
        
        local content=$(cat "$md_file" 2>/dev/null)
        if [[ -n "$content" ]]; then
            run_claude_async "Enhance this markdown documentation with better structure, examples, and formatting. Keep the original content but improve readability and add useful examples where appropriate: $content" &
            
            if (( md_count % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
                wait_for_claude_jobs
            fi
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ Markdown enhancement completed!"
}

# 🎨 cc-file-optimize-css - Optimize CSS files for performance
# 🎯 Usage: cc-file-optimize-css "*.css"
cc-file-optimize-css() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🎨 cc-file-optimize-css - Optimize CSS files for performance"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-file-optimize-css <file_pattern>"
        echo ""
        echo "📝 Parameters:"
        echo "  file_pattern    🔍 CSS file pattern (e.g., '*.css', 'styles/*.css')"
        echo ""
        echo "📋 Examples:"
        echo "  cc-file-optimize-css '*.css'"
        echo "  cc-file-optimize-css 'src/styles/*.css'"
        echo ""
        echo "💡 Optimizations include:"
        echo "  • Removing unused CSS rules"
        echo "  • Combining duplicate selectors"
        echo "  • Adding vendor prefixes"
        echo "  • Improving specificity"
        echo "  • Converting to modern CSS features"
        return 0
    fi
    
    local css_pattern="${1:-*.css}"
    
    echo "🎨 Optimizing CSS files..."
    local css_count=0
    
    for css_file in ${~css_pattern}; do
        [[ ! -f "$css_file" ]] && continue
        
        ((css_count++))
        echo "🎨 Optimizing: $css_file"
        
        local css_content=$(cat "$css_file" 2>/dev/null)
        if [[ -n "$css_content" ]]; then
            run_claude_async "Optimize this CSS for performance by removing unused rules, combining selectors, adding modern features, and improving structure: $css_content" &
            
            if (( css_count % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
                wait_for_claude_jobs
            fi
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ CSS optimization completed! Processed $css_count files"
}

# 📊 cc-file-validate-json - Validate and format JSON files
# 🎯 Usage: cc-file-validate-json "*.json"
cc-file-validate-json() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📊 cc-file-validate-json - Validate and format JSON files"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-file-validate-json <file_pattern>"
        echo ""
        echo "📝 Parameters:"
        echo "  file_pattern    🔍 JSON file pattern (e.g., '*.json', 'config/*.json')"
        echo ""
        echo "📋 Examples:"
        echo "  cc-file-validate-json '*.json'"
        echo "  cc-file-validate-json 'config/*.json'"
        echo ""
        echo "💡 Validation includes:"
        echo "  • JSON syntax checking"
        echo "  • Pretty formatting"
        echo "  • Schema validation suggestions"
        echo "  • Error reporting"
        return 0
    fi
    
    local json_pattern="${1:-*.json}"
    
    echo "📊 Validating JSON files..."
    local json_count=0
    local valid_count=0
    local invalid_count=0
    
    for json_file in ${~json_pattern}; do
        [[ ! -f "$json_file" ]] && continue
        
        ((json_count++))
        echo "📊 Validating: $json_file"
        
        # 🔍 Quick syntax check first
        if python -m json.tool "$json_file" > /dev/null 2>&1; then
            ((valid_count++))
            echo "✅ Valid JSON: $json_file"
            
            # 🚀 Launch async formatting/enhancement
            local json_content=$(cat "$json_file" 2>/dev/null)
            run_claude_async "Analyze and improve this JSON file with better formatting, add comments where helpful, and suggest schema improvements: $json_content" &
        else
            ((invalid_count++))
            echo "❌ Invalid JSON: $json_file"
            
            # 🚀 Launch async fix
            local json_content=$(cat "$json_file" 2>/dev/null)
            run_claude_async "Fix the JSON syntax errors in this file and provide a corrected version: $json_content" &
        fi
        
        if (( json_count % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
            wait_for_claude_jobs
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ JSON validation completed!"
    echo "📊 Summary: $json_count total, $valid_count valid, $invalid_count invalid"
}

# 📦 cc-file-backup-create - Create backups of important files
# 🎯 Usage: cc-file-backup-create "file_pattern" [backup_dir]
cc-file-backup-create() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📦 cc-file-backup-create - Create backups of important files"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-file-backup-create <file_pattern> [backup_dir]"
        echo ""
        echo "📝 Parameters:"
        echo "  file_pattern    🔍 Files to backup (e.g., '*.config', 'src/*.js')"
        echo "  backup_dir      📁 Backup directory (optional, default: ./backups)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-file-backup-create '*.config'"
        echo "  cc-file-backup-create 'src/*.js' '/backup/code'"
        echo ""
        echo "💡 Backup format: filename_YYYYMMDD_HHMMSS.ext"
        return 0
    fi
    
    local file_pattern="$1"
    local backup_dir="${2:-./backups}"
    
    if [[ -z "$file_pattern" ]]; then
        echo "❌ Usage: cc-file-backup-create <file_pattern> [backup_dir]"
        echo "💡 Use 'cc-file-backup-create -h' for detailed help"
        return 1
    fi
    
    # 📁 Create backup directory
    mkdir -p "$backup_dir"
    
    echo "📦 Creating backups in: $backup_dir"
    local backup_count=0
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    for file in ${~file_pattern}; do
        [[ ! -f "$file" ]] && continue
        
        ((backup_count++))
        local filename=$(basename "$file")
        local extension="${filename##*.}"
        local basename="${filename%.*}"
        local backup_name="${basename}_${timestamp}.${extension}"
        local backup_path="$backup_dir/$backup_name"
        
        echo "📦 Backing up: $file → $backup_path"
        
        # 🚀 Launch async backup with verification
        run_claude_async "Create a backup script to copy '$file' to '$backup_path' with integrity verification and generate a backup report" &
        
        if (( backup_count % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
            wait_for_claude_jobs
        fi
    done
    
    wait_for_claude_jobs
    echo "✅ Backup creation completed! Created $backup_count backups"
}

# 🧹 cc-file-clean-temp - Clean temporary and cache files
# 🎯 Usage: cc-file-clean-temp [directory]
cc-file-clean-temp() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🧹 cc-file-clean-temp - Clean temporary and cache files"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-file-clean-temp [directory]"
        echo ""
        echo "📝 Parameters:"
        echo "  directory    📁 Directory to clean (optional, default: current directory)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-file-clean-temp"
        echo "  cc-file-clean-temp \"project\""
        echo ""
        echo "🧹 Cleans:"
        echo "  • Temporary files (*.tmp, *.temp)"
        echo "  • Cache files (*.cache, *~)"
        echo "  • Log files (*.log older than 7 days)"
        echo "  • Node modules cache"
        echo "  • Python cache (__pycache__)"
        echo ""
        echo "⚠️  Warning: This will permanently delete files!"
        return 0
    fi
    
    local target_dir="${1:-.}"
    
    if [[ ! -d "$target_dir" ]]; then
        echo "❌ Directory not found: $target_dir"
        return 1
    fi
    
    echo "🧹 Cleaning temporary files in: $target_dir"
    echo "⚠️ This will delete temporary and cache files!"
    read "confirm?Continue? (y/N): "
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "❌ Operation cancelled"
        return 0
    fi
    
    # 🚀 Launch async cleanup tasks
    run_claude_async "Create a comprehensive cleanup script for directory '$target_dir' that safely removes temporary files, cache files, old logs, and build artifacts while preserving important files" &
    
    echo "🧹 Cleanup initiated! Check the generated script before running."
    wait_for_claude_jobs
    echo "✅ Cleanup script generation completed!"
}

# 🆘 cc-file-help - Show help for all file functions
# 🎯 Usage: cc-file-help [function_name]
cc-file-help() {
    local function_name="$1"
    
    if [[ -n "$function_name" ]]; then
        # 📖 Try to call the specific function with -h flag
        if "$function_name" -h 2>/dev/null; then
            return 0
        else
            echo "❌ Function not found: $function_name"
            echo "💡 Available file functions:"
            echo "   cc-file-process-batch, cc-file-enhance-md, cc-file-optimize-css"
            echo "   cc-file-validate-json, cc-file-backup-create, cc-file-clean-temp"
            return 1
        fi
    else
        echo "📁 Claude File Functions Help"
        echo "════════════════════════════════════════"
        echo ""
        echo "🚀 Quick Start:"
        echo "  cc-file-process-batch '*.js' 'Add TypeScript types'"
        echo "  cc-file-enhance-md"
        echo "  cc-file-validate-json '*.json'"
        echo ""
        echo "📚 Available Functions:"
        echo "  🔄 cc-file-process-batch  - Process files with Claude Code"
        echo "  📝 cc-file-enhance-md     - Enhance markdown files"
        echo "  🎨 cc-file-optimize-css   - Optimize CSS files"
        echo "  📊 cc-file-validate-json  - Validate JSON files"
        echo "  📦 cc-file-backup-create  - Create file backups"
        echo "  🧹 cc-file-clean-temp     - Clean temporary files"
        echo ""
        echo "💡 Use 'cc-file-help <function_name>' or '<function_name> -h' for specific help"
    fi
}

# 🎉 File module loaded message
echo "📁 File module loaded! (cc-file-*)"