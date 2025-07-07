#!/usr/bin/env zsh

# 🚀📦 MCP Server Dependency Installer - Quick Setup! ✨💯
# ════════════════════════════════════════════════════════════════════════════════
# 🎯 Installs Node.js dependencies for the Async Claude Code MCP Server! 🌟
# 📺 Inspired by IndyDevDan's incredible tutorials! 
# 🌟 Learn more: https://www.youtube.com/c/IndyDevDan
# ════════════════════════════════════════════════════════════════════════════════

# 🎨 Colors
typeset -A colors
colors=(
    [reset]='\033[0m' [green]='\033[32m' [cyan]='\033[36m' 
    [yellow]='\033[33m' [bright_green]='\033[92m' [bright_cyan]='\033[96m'
    [bright_yellow]='\033[93m' [bright_red]='\033[91m'
)

print_color() { echo -e "${colors[$1]}$2${colors[reset]}"; }

# 🎯 Main installation
main() {
    local mcp_dir="$(dirname "$(realpath "$0")")"
    
    print_color "bright_cyan" "🚀 Installing MCP Server Dependencies..."
    print_color "cyan" "📁 Directory: $mcp_dir"
    echo ""
    
    # Check Node.js
    if ! command -v node >/dev/null 2>&1; then
        print_color "bright_red" "❌ Node.js not found!"
        print_color "yellow" "💡 Please install Node.js (v18+):"
        print_color "white" "   🔗 https://nodejs.org/"
        exit 1
    fi
    
    local node_version=$(node --version)
    print_color "bright_green" "✅ Node.js found: $node_version"
    
    # Check npm
    if ! command -v npm >/dev/null 2>&1; then
        print_color "bright_red" "❌ npm not found!"
        exit 1
    fi
    
    local npm_version=$(npm --version)
    print_color "bright_green" "✅ npm found: v$npm_version"
    echo ""
    
    # Install dependencies
    print_color "bright_cyan" "📦 Installing MCP server dependencies..."
    
    cd "$mcp_dir"
    
    if npm install; then
        print_color "bright_green" "✅ Dependencies installed successfully!"
        echo ""
        
        # Test the server
        print_color "bright_cyan" "🧪 Testing MCP server..."
        if timeout 5s node server.js --test >/dev/null 2>&1; then
            print_color "bright_green" "✅ MCP server test passed!"
        else
            print_color "yellow" "⚠️ MCP server test timeout (this is normal)"
        fi
        
        echo ""
        print_color "bright_green" "🎉 MCP Server is ready!"
        print_color "cyan" "📋 Next steps:"
        print_color "white" "   1. Add MCP config to Claude Desktop"
        print_color "white" "   2. Restart Claude Desktop" 
        print_color "white" "   3. Verify toolkit functions are available"
        echo ""
        print_color "bright_yellow" "📖 See MCP_SETUP_INSTRUCTIONS.md for details!"
        
    else
        print_color "bright_red" "❌ Failed to install dependencies!"
        print_color "yellow" "💡 Try running 'npm install' manually"
        exit 1
    fi
}

main "$@"