#!/usr/bin/env zsh

# 💾 Cache Module - Redis Caching Functions 
# 🎯 Part of Claude Functions Async Utility Library
# 🔧 New naming convention: cc-cache-<action>
# 
# 📋 Available Functions:
#   • cc-cache-set    - Store data in cache with TTL
#   • cc-cache-get    - Retrieve data from cache  
#   • cc-cache-del    - Delete key from cache
#   • cc-cache-stats  - Show cache statistics
#   • cc-cache-flush  - Clear all cache data
#   • cc-cache-help   - Show help for cache functions

# ═══════════════════════════════════════════════════════════════════════════════
# 🔴 REDIS CACHING FUNCTIONS - Lightning Fast Async Caching! ⚡
# ═══════════════════════════════════════════════════════════════════════════════

# 💾 cc-cache-set - Store data in Redis cache with TTL
# 🎯 Usage: cc-cache-set "my_key" "my_value" [ttl_seconds]
# 📝 Examples:
#   cc-cache-set "user:123" "John Doe" 300
#   cc-cache-set "config" "$(cat config.json)"
cc-cache-set() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "💾 cc-cache-set - Store data in Redis cache with TTL"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-set <key> <value> [ttl_seconds]"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key (required)"
        echo "  value        💰 Value to cache (required)"
        echo "  ttl_seconds  ⏰ Time to live in seconds (optional, default: ${CLAUDE_CACHE_TTL:-3600})"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-set \"user:123\" \"John Doe\" 300"
        echo "  cc-cache-set \"config\" \"\$(cat config.json)\""
        echo "  cc-cache-set \"session:abc\" \"active\" 1800"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key
    local value="$2"         # 💰 Value to cache  
    local ttl="${3:-${CLAUDE_CACHE_TTL:-3600}}" # ⏰ Time to live
    
    if [[ -z "$key" || -z "$value" ]]; then
        echo "❌ Usage: cc-cache-set <key> <value> [ttl]"
        echo "💡 Use 'cc-cache-set -h' for detailed help"
        return 1
    fi
    
    # 🚀 Store in Redis with TTL
    redis-cli SETEX "$key" "$ttl" "$value" > /dev/null 2>&1 && \
        echo "✅ Cached: $key (TTL: ${ttl}s)" || \
        echo "❌ Cache failed: $key"
}

# 📖 cc-cache-get - Retrieve data from Redis cache
# 🎯 Usage: cc-cache-get "my_key"
# 📝 Examples:
#   user_data=$(cc-cache-get "user:123")
#   config=$(cc-cache-get "config")
cc-cache-get() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📖 cc-cache-get - Retrieve data from Redis cache"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-get <key>"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key to retrieve (required)"
        echo ""
        echo "📋 Examples:"
        echo "  user_data=\$(cc-cache-get \"user:123\")"
        echo "  config=\$(cc-cache-get \"config\")"
        echo "  cc-cache-get \"session:abc\" && echo \"Session active\""
        echo ""
        echo "📊 Return codes:"
        echo "  0  ✅ Key found, value returned"
        echo "  1  ❌ Key not found or empty"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key to retrieve
    
    if [[ -z "$key" ]]; then
        echo "❌ Usage: cc-cache-get <key>"
        echo "💡 Use 'cc-cache-get -h' for detailed help"
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

# 🗑️ cc-cache-del - Delete key from Redis cache
# 🎯 Usage: cc-cache-del "my_key"
cc-cache-del() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🗑️ cc-cache-del - Delete key from Redis cache"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-del <key>"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key to delete (required)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-del \"user:123\""
        echo "  cc-cache-del \"expired_session\""
        echo "  cc-cache-del \"temp_data\""
        echo ""
        echo "⚠️  Warning: This permanently removes the key from cache!"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key to delete
    
    if [[ -z "$key" ]]; then
        echo "❌ Usage: cc-cache-del <key>"
        echo "💡 Use 'cc-cache-del -h' for detailed help"
        return 1
    fi
    
    redis-cli DEL "$key" > /dev/null 2>&1 && \
        echo "🗑️ Deleted: $key" || \
        echo "❌ Delete failed: $key"
}

# 📊 cc-cache-stats - Show Redis cache statistics
# 🎯 Usage: cc-cache-stats
cc-cache-stats() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📊 cc-cache-stats - Show Redis cache statistics"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-stats"
        echo ""
        echo "📝 Description:"
        echo "  Displays comprehensive Redis cache statistics including:"
        echo "  • Total number of keys"
        echo "  • Memory usage"
        echo "  • Connected clients"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-stats"
        echo "  cc-cache-stats | grep 'Memory'"
        return 0
    fi
    
    echo "📊 Redis Cache Statistics:"
    echo "🔢 Total Keys: $(redis-cli DBSIZE 2>/dev/null || echo 'N/A')"
    echo "💾 Memory Usage: $(redis-cli INFO memory 2>/dev/null | grep used_memory_human | cut -d: -f2 | tr -d '\r' || echo 'N/A')"
    echo "🔗 Connected Clients: $(redis-cli INFO clients 2>/dev/null | grep connected_clients | cut -d: -f2 | tr -d '\r' || echo 'N/A')"
}

# 🧹 cc-cache-flush - Clear all cache (DANGEROUS!)
# 🎯 Usage: cc-cache-flush
cc-cache-flush() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🧹 cc-cache-flush - Clear all cache (DANGEROUS!)"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-flush"
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
        echo "  cc-cache-flush"
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

# 🆘 cc-cache-help - Show help for all cache functions
# 🎯 Usage: cc-cache-help [function_name]
cc-cache-help() {
    local function_name="$1"
    
    if [[ -n "$function_name" ]]; then
        # 📖 Try to call the specific function with -h flag
        if "$function_name" -h 2>/dev/null; then
            return 0
        else
            echo "❌ Function not found: $function_name"
            echo "💡 Available cache functions: cc-cache-set, cc-cache-get, cc-cache-del, cc-cache-stats, cc-cache-flush"
            return 1
        fi
    else
        echo "💾 Claude Cache Functions Help"
        echo "════════════════════════════════════════"
        echo ""
        echo "🚀 Quick Start:"
        echo "  cc-cache-set 'user:123' 'John Doe' 300"
        echo "  cc-cache-get 'user:123'"
        echo "  cc-cache-stats"
        echo ""
        echo "📚 Available Functions:"
        echo "  💾 cc-cache-set    - Store data with TTL"
        echo "  📖 cc-cache-get    - Retrieve cached data"  
        echo "  🗑️ cc-cache-del     - Delete cache key"
        echo "  📊 cc-cache-stats  - Show statistics"
        echo "  🧹 cc-cache-flush  - Clear all cache"
        echo ""
        echo "💡 Use 'cc-cache-help <function_name>' or '<function_name> -h' for specific help"
    fi
}

# 🎉 Cache module loaded message
echo "💾 Cache module loaded! (cc-cache-*)"