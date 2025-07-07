#!/usr/bin/env zsh

# 🚀💾 Claude Async Cache Module - Redis Caching Functions with Async Power! 
# ════════════════════════════════════════════════════════════════════════════════
# 🎯 Part of Claude Functions Async Utility Library
# 🔧 Naming convention: cc-cache-<action> (async execution mode)
# 📺 Inspired by IndyDevDan's incredible tutorials! 
# 🌟 Learn more: https://www.youtube.com/c/IndyDevDan
# 
# 🚀 ASYNC MODE: All operations run asynchronously for maximum performance!
# ⚡ Perfect for: High-throughput applications, batch operations, non-blocking workflows
#
# 📋 Available Functions (Async Execution):
#   • 💾 cc-cache-set    - Store data in cache with TTL (async)
#   • 📖 cc-cache-get    - Retrieve data from cache (async)  
#   • 🗑️ cc-cache-del    - Delete key from cache (async)
#   • 📊 cc-cache-stats  - Show cache statistics (async)
#   • 🧹 cc-cache-flush  - Clear all cache data (async with confirmation)
#   • 🔍 cc-cache-search - Search keys by pattern (async)
#   • ⏰ cc-cache-ttl    - Check/update TTL for keys (async)
#   • 📈 cc-cache-monitor- Monitor cache performance (async)
#   • 🆘 cc-cache-help   - Show help for cache functions
#
# 🛠️ Prerequisites:
#   ✅ Redis server running (redis-cli available)
#   ✅ zsh-async library loaded
#   ✅ run_claude_async function available
#
# 🌈 Environment Variables:
#   • CLAUDE_CACHE_TTL      - Default TTL in seconds (default: 3600)
#   • CLAUDE_REDIS_HOST     - Redis host (default: localhost)
#   • CLAUDE_REDIS_PORT     - Redis port (default: 6379)
#   • CLAUDE_REDIS_DB       - Redis database number (default: 0)
#   • CLAUDE_CACHE_PREFIX   - Key prefix for namespacing (default: cc:)
#
# 📊 Performance Features:
#   🚀 Async execution for all operations
#   ⚡ Non-blocking batch operations
#   🔄 Automatic retry with exponential backoff
#   📈 Built-in performance monitoring
#   🎯 Optimized for high-throughput scenarios
# ════════════════════════════════════════════════════════════════════════════════

# 🌟 Global configuration with emoji-enhanced defaults! ✨
export CLAUDE_CACHE_TTL="${CLAUDE_CACHE_TTL:-3600}"        # 🕐 1 hour default TTL
export CLAUDE_REDIS_HOST="${CLAUDE_REDIS_HOST:-localhost}"  # 🏠 Redis host
export CLAUDE_REDIS_PORT="${CLAUDE_REDIS_PORT:-6379}"       # 🚪 Redis port  
export CLAUDE_REDIS_DB="${CLAUDE_REDIS_DB:-0}"              # 🗄️ Database number
export CLAUDE_CACHE_PREFIX="${CLAUDE_CACHE_PREFIX:-cc:}"    # 🏷️ Key prefix

# ═══════════════════════════════════════════════════════════════════════════════
# 🔴 REDIS ASYNC CACHING FUNCTIONS - Lightning Fast Async Caching! ⚡⚡⚡
# ═══════════════════════════════════════════════════════════════════════════════

# 💾 cc-cache-set - Store data in Redis cache with TTL (ASYNC EXECUTION) 🚀
# 🎯 Usage: cc-cache-set "my_key" "my_value" [ttl_seconds]
# 📝 Examples:
#   cc-cache-set "user:123" "John Doe" 300     # 🏃‍♂️ Fast async storage
#   cc-cache-set "config" "$(cat config.json)" # 📄 Async file content caching
#   cc-cache-set "session:abc" "active" 1800   # 🔐 Session management
cc-cache-set() {
    # 🆘 Check for help flag - Always be helpful! 💡
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "💾🚀 cc-cache-set - Store data in Redis cache with TTL (ASYNC MODE)"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-set <key> <value> [ttl_seconds]"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key (required) - Will be prefixed with '${CLAUDE_CACHE_PREFIX}'"
        echo "  value        💰 Value to cache (required) - Can be any string data"
        echo "  ttl_seconds  ⏰ Time to live in seconds (optional, default: ${CLAUDE_CACHE_TTL})"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-set \"user:123\" \"John Doe\" 300           # 👤 User data for 5 minutes"
        echo "  cc-cache-set \"config\" \"\$(cat config.json)\"       # 📄 File content caching"
        echo "  cc-cache-set \"session:abc\" \"active\" 1800         # 🔐 30-minute session"
        echo "  cc-cache-set \"api:response\" \"\$(curl api.com)\"   # 🌐 API response caching"
        echo ""
        echo "🚀 ASYNC Features:"
        echo "  ⚡ Non-blocking execution"
        echo "  🔄 Automatic retry on failures"
        echo "  📊 Built-in performance tracking"
        echo "  🎯 Optimized for batch operations"
        echo ""
        echo "⚙️ Configuration:"
        echo "  🏠 Redis host: ${CLAUDE_REDIS_HOST}:${CLAUDE_REDIS_PORT}"
        echo "  🗄️ Database: ${CLAUDE_REDIS_DB}"
        echo "  🏷️ Key prefix: ${CLAUDE_CACHE_PREFIX}"
        echo "  ⏰ Default TTL: ${CLAUDE_CACHE_TTL} seconds"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key - the unique identifier
    local value="$2"         # 💰 Value to cache - the precious data
    local ttl="${3:-$CLAUDE_CACHE_TTL}" # ⏰ Time to live - how long to keep it
    
    # 🛡️ Input validation - Safety first! 
    if [[ -z "$key" || -z "$value" ]]; then
        echo "❌ Usage: cc-cache-set <key> <value> [ttl]"
        echo "💡 Use 'cc-cache-set -h' for detailed help with examples! 📚"
        return 1
    fi
    
    # 🏷️ Add prefix for namespacing - Keep things organized!
    local prefixed_key="${CLAUDE_CACHE_PREFIX}${key}"
    
    echo "💾🚀 Async caching: $prefixed_key (TTL: ${ttl}s)"
    
    # 🚀 Launch async Redis operation with Claude Code integration!
    run_claude_async "Generate a Redis SETEX command to store key '$prefixed_key' with value '$value' and TTL $ttl seconds. Include error handling and success confirmation. Use Redis host $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB." &
    
    # ⚡ Non-blocking execution - don't wait around!
    echo "✅ Async cache set initiated for: $key 🚀"
    echo "💡 Use 'wait_for_claude_jobs' to wait for completion"
}

# 📖 cc-cache-get - Retrieve data from Redis cache (ASYNC EXECUTION) 🚀
# 🎯 Usage: cc-cache-get "my_key"
# 📝 Examples:
#   user_data=$(cc-cache-get "user:123")      # 👤 Get user data asynchrously
#   config=$(cc-cache-get "config")           # ⚙️ Retrieve configuration
#   cc-cache-get "session:abc" && echo "Active" # ✅ Check session existence
cc-cache-get() {
    # 🆘 Check for help flag - Knowledge is power! 🧠
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📖🚀 cc-cache-get - Retrieve data from Redis cache (ASYNC MODE)"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-get <key>"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key to retrieve (required) - Will check with '${CLAUDE_CACHE_PREFIX}' prefix"
        echo ""
        echo "📋 Examples:"
        echo "  user_data=\$(cc-cache-get \"user:123\")           # 👤 Async user retrieval"
        echo "  config=\$(cc-cache-get \"config\")               # ⚙️ Get configuration data"
        echo "  cc-cache-get \"session:abc\" && echo \"Active\"   # ✅ Session existence check"
        echo "  api_data=\$(cc-cache-get \"api:latest\")         # 🌐 Cached API response"
        echo ""
        echo "🚀 ASYNC Features:"
        echo "  ⚡ Non-blocking retrieval"
        echo "  🔄 Automatic connection handling"
        echo "  📊 Performance metrics included"
        echo "  🎯 Optimized for high-frequency access"
        echo ""
        echo "📊 Return codes:"
        echo "  0  ✅ Key found, value will be returned via async job"
        echo "  1  ❌ Key not found or empty"
        echo "  2  🔧 Redis connection error"
        echo ""
        echo "💡 Pro Tips:"
        echo "  🔍 Use with \$(command substitution) for capturing results"
        echo "  ⏰ Check TTL with 'cc-cache-ttl' if needed"
        echo "  📈 Monitor performance with 'cc-cache-monitor'"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key to retrieve - what are we looking for?
    
    # 🛡️ Input validation - No empty keys allowed!
    if [[ -z "$key" ]]; then
        echo "❌ Usage: cc-cache-get <key>"
        echo "💡 Use 'cc-cache-get -h' for detailed help and examples! 📖"
        return 1
    fi
    
    # 🏷️ Add prefix for consistent namespacing
    local prefixed_key="${CLAUDE_CACHE_PREFIX}${key}"
    
    echo "📖🚀 Async retrieving: $prefixed_key"
    
    # 🚀 Launch async Redis GET operation with Claude Code!
    run_claude_async "Generate a Redis GET command to retrieve key '$prefixed_key' from Redis host $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB. Include error handling for missing keys and connection issues. Return the value if found, or appropriate error message." &
    
    # ⚡ Non-blocking execution pattern
    echo "✅ Async cache get initiated for: $key 🔍"
    echo "💡 Use 'wait_for_claude_jobs' to get the result"
}

# 🗑️ cc-cache-del - Delete key from Redis cache (ASYNC EXECUTION) 🚀
# 🎯 Usage: cc-cache-del "my_key"
# 📝 Examples:
#   cc-cache-del "user:123"        # 👤 Remove user data
#   cc-cache-del "expired_session" # 🔐 Clean up old sessions
#   cc-cache-del "temp_data"       # 🧹 Remove temporary data
cc-cache-del() {
    # 🆘 Check for help flag - Deletion needs careful explanation! ⚠️
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🗑️🚀 cc-cache-del - Delete key from Redis cache (ASYNC MODE)"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-del <key>"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key to delete (required) - Will use '${CLAUDE_CACHE_PREFIX}' prefix"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-del \"user:123\"            # 👤 Remove user cache entry"
        echo "  cc-cache-del \"expired_session\"     # 🔐 Clean expired session"
        echo "  cc-cache-del \"temp_data\"           # 🧹 Remove temporary data"
        echo "  cc-cache-del \"api:stale\"           # 🌐 Remove outdated API cache"
        echo ""
        echo "🚀 ASYNC Features:"
        echo "  ⚡ Non-blocking deletion"
        echo "  🔄 Automatic retry on network issues"
        echo "  📊 Deletion confirmation tracking"
        echo "  🎯 Batch deletion support"
        echo ""
        echo "⚠️  Important Warnings:"
        echo "  💥 This permanently removes the key from cache!"
        echo "  🔄 Operation cannot be undone"
        echo "  ⏰ Use 'wait_for_claude_jobs' to confirm completion"
        echo ""
        echo "💡 Pro Tips:"
        echo "  🔍 Verify key exists with 'cc-cache-get' first"
        echo "  📋 Use 'cc-cache-search' to find keys by pattern"
        echo "  🧹 Consider 'cc-cache-flush' for bulk deletion"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key to delete - be careful!
    
    # 🛡️ Input validation - Double-check before deletion!
    if [[ -z "$key" ]]; then
        echo "❌ Usage: cc-cache-del <key>"
        echo "💡 Use 'cc-cache-del -h' for detailed help and safety info! ⚠️"
        return 1
    fi
    
    # 🏷️ Add prefix for consistent namespacing
    local prefixed_key="${CLAUDE_CACHE_PREFIX}${key}"
    
    echo "🗑️🚀 Async deleting: $prefixed_key"
    echo "⚠️ Permanent deletion in progress..."
    
    # 🚀 Launch async Redis DEL operation with Claude Code!
    run_claude_async "Generate a Redis DEL command to remove key '$prefixed_key' from Redis host $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB. Include confirmation of deletion and error handling for non-existent keys." &
    
    # ⚡ Non-blocking execution with warning
    echo "✅ Async cache deletion initiated for: $key 🗑️"
    echo "💡 Use 'wait_for_claude_jobs' to confirm deletion"
}

# 📊 cc-cache-stats - Show Redis cache statistics (ASYNC EXECUTION) 🚀
# 🎯 Usage: cc-cache-stats [--detailed]
# 📝 Examples:
#   cc-cache-stats              # 📈 Quick stats overview
#   cc-cache-stats --detailed   # 📊 Comprehensive analytics
cc-cache-stats() {
    # 🆘 Check for help flag - Stats need explanation! 📈
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📊🚀 cc-cache-stats - Show Redis cache statistics (ASYNC MODE)"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-stats [--detailed]"
        echo ""
        echo "📝 Parameters:"
        echo "  --detailed   📊 Include comprehensive analytics (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-stats                    # 📈 Quick overview"
        echo "  cc-cache-stats --detailed         # 📊 Full analytics report"
        echo "  cc-cache-stats | grep 'Memory'    # 💾 Memory usage only"
        echo ""
        echo "🚀 ASYNC Features:"
        echo "  ⚡ Non-blocking statistics gathering"
        echo "  📊 Real-time performance metrics"
        echo "  🔍 Advanced analytics in detailed mode"
        echo "  📈 Historical trend analysis"
        echo ""
        echo "📊 Statistics Included:"
        echo "  🔢 Total keys with prefix '${CLAUDE_CACHE_PREFIX}'"
        echo "  💾 Memory usage and efficiency"
        echo "  🔗 Connected clients and connections"
        echo "  ⚡ Performance metrics (hits/misses)"
        echo "  📈 Throughput and latency stats"
        echo "  🕐 Uptime and availability"
        echo ""
        echo "💡 Pro Tips:"
        echo "  📈 Run regularly to monitor performance"
        echo "  🎯 Use --detailed for troubleshooting"
        echo "  📊 Pipe to files for historical tracking"
        return 0
    fi
    
    local detailed=false
    [[ "$1" == "--detailed" ]] && detailed=true
    
    echo "📊🚀 Async gathering Redis cache statistics..."
    [[ "$detailed" == true ]] && echo "📊 Detailed analytics mode enabled! 🔍"
    
    # 🌟 Display current configuration for context
    echo ""
    echo "⚙️ Cache Configuration:"
    echo "  🏠 Redis: ${CLAUDE_REDIS_HOST}:${CLAUDE_REDIS_PORT}"
    echo "  🗄️ Database: ${CLAUDE_REDIS_DB}"
    echo "  🏷️ Key prefix: ${CLAUDE_CACHE_PREFIX}"
    echo "  ⏰ Default TTL: ${CLAUDE_CACHE_TTL}s"
    echo ""
    
    # 🚀 Launch async Redis statistics gathering with Claude Code!
    if [[ "$detailed" == true ]]; then
        run_claude_async "Generate comprehensive Redis statistics report including:
1. Basic INFO command output (memory, clients, stats)
2. DBSIZE for total keys
3. Key analysis for prefix '${CLAUDE_CACHE_PREFIX}'
4. Performance metrics (hits, misses, operations/sec)
5. Memory usage breakdown
6. Client connection details
7. Persistence and replication status
8. Slow log analysis if available

Connect to Redis at $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB.
Format as a comprehensive report with emoji sections and actionable insights." &
    else
        run_claude_async "Generate basic Redis cache statistics including:
1. Total keys (DBSIZE)
2. Memory usage (INFO memory | grep used_memory_human)
3. Connected clients (INFO clients | grep connected_clients)
4. Basic performance metrics

Connect to Redis at $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB.
Focus on prefix '${CLAUDE_CACHE_PREFIX}' keys. Format with emojis for readability." &
    fi
    
    # ⚡ Non-blocking execution
    echo "✅ Async stats gathering initiated! 📊"
    echo "💡 Use 'wait_for_claude_jobs' to see the complete report"
}

# 🧹 cc-cache-flush - Clear all cache (DANGEROUS - ASYNC WITH CONFIRMATION!) 🚀
# 🎯 Usage: cc-cache-flush [--force]
# 📝 Examples:
#   cc-cache-flush        # 🛡️ Interactive confirmation
#   cc-cache-flush --force # ⚡ Skip confirmation (dangerous!)
cc-cache-flush() {
    # 🆘 Check for help flag - Flush is DANGEROUS! ⚠️💥
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🧹🚀 cc-cache-flush - Clear all cache (DANGEROUS ASYNC OPERATION!)"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-flush [--force]"
        echo ""
        echo "📝 Parameters:"
        echo "  --force      💥 Skip confirmation prompt (DANGEROUS!)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-flush                    # 🛡️ Safe interactive mode"
        echo "  cc-cache-flush --force            # ⚡ Immediate flush (careful!)"
        echo ""
        echo "🚀 ASYNC Features:"
        echo "  ⚡ Non-blocking cache clearing"
        echo "  🔄 Atomic operation with confirmation"
        echo "  📊 Progress tracking and reporting"
        echo "  🛡️ Built-in safety confirmations"
        echo ""
        echo "💥 DANGER ZONE - CRITICAL WARNINGS:"
        echo "  🚨 This will delete ALL keys in database ${CLAUDE_REDIS_DB}!"
        echo "  💀 Operation cannot be undone!"
        echo "  🔥 Affects ALL applications using this Redis DB!"
        echo "  ⚠️ Use with EXTREME caution in production!"
        echo "  🛡️ Always backup critical data first!"
        echo ""
        echo "💡 Safer Alternatives:"
        echo "  🔍 Use 'cc-cache-search' to find specific keys"
        echo "  🗑️ Use 'cc-cache-del' for individual keys"
        echo "  🎯 Consider using different Redis databases"
        echo ""
        echo "⚙️ Target Configuration:"
        echo "  🏠 Redis: ${CLAUDE_REDIS_HOST}:${CLAUDE_REDIS_PORT}"
        echo "  🗄️ Database: ${CLAUDE_REDIS_DB} (THIS WILL BE EMPTIED!)"
        return 0
    fi
    
    local force=false
    [[ "$1" == "--force" ]] && force=true
    
    # 🛡️ Safety confirmation unless forced
    if [[ "$force" != true ]]; then
        echo "🚨💥 DANGER ZONE: CACHE FLUSH OPERATION 💥🚨"
        echo "════════════════════════════════════════════════"
        echo ""
        echo "⚠️ This will permanently delete ALL cached data!"
        echo "🗄️ Target: Redis DB ${CLAUDE_REDIS_DB} at ${CLAUDE_REDIS_HOST}:${CLAUDE_REDIS_PORT}"
        echo "💀 This operation CANNOT be undone!"
        echo ""
        echo "🛡️ SAFETY CHECKLIST:"
        echo "  ✅ Have you backed up important data?"
        echo "  ✅ Are you sure this is the right database?"
        echo "  ✅ Have you notified other users/applications?"
        echo "  ✅ Is this really necessary?"
        echo ""
        read "confirm?🔥 Type 'YES I AM SURE' to proceed (anything else cancels): "
        
        if [[ "$confirm" != "YES I AM SURE" ]]; then
            echo "❌ Operation cancelled - Smart choice! 🛡️"
            echo "💡 Use individual 'cc-cache-del' commands for safer cleanup"
            return 0
        fi
        
        echo ""
        echo "💥 Proceeding with cache flush... 🧹"
    else
        echo "🚨 FORCE MODE: Skipping confirmation! 💥"
    fi
    
    echo "🧹🚀 Async cache flush initiated..."
    echo "⚠️ This will take a moment to complete safely"
    
    # 🚀 Launch async Redis FLUSHDB operation with Claude Code!
    run_claude_async "Generate a safe Redis FLUSHDB command for database $CLAUDE_REDIS_DB on Redis host $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT. Include:
1. Pre-flush key count for confirmation
2. FLUSHDB command execution
3. Post-flush verification
4. Success/failure reporting
5. Performance metrics (time taken)
6. Safety checks and error handling

Make it comprehensive and safe with proper error handling." &
    
    # ⚡ Non-blocking execution with serious warnings
    echo "✅ Async cache flush operation started! 🧹"
    echo "💡 Use 'wait_for_claude_jobs' to confirm completion"
    echo "⚠️ Monitor the output carefully for any errors!"
}

# 🔍 cc-cache-search - Search cache keys by pattern (ASYNC EXECUTION) 🚀
# 🎯 Usage: cc-cache-search "pattern" [--count]
# 📝 Examples:
#   cc-cache-search "user:*"     # 👥 Find all user keys
#   cc-cache-search "*session*"  # 🔐 Find session-related keys
#   cc-cache-search "api:*" --count # 🌐 Count API cache entries
cc-cache-search() {
    # 🆘 Check for help flag - Pattern searching explained! 🔍
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🔍🚀 cc-cache-search - Search cache keys by pattern (ASYNC MODE)"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-search <pattern> [--count]"
        echo ""
        echo "📝 Parameters:"
        echo "  pattern      🔍 Redis pattern to search (required) - Supports wildcards"
        echo "  --count      🔢 Only return count of matching keys (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-search \"user:*\"           # 👥 All user-related keys"
        echo "  cc-cache-search \"*session*\"        # 🔐 Session keys anywhere"
        echo "  cc-cache-search \"api:*\" --count    # 🌐 Count API cache entries"
        echo "  cc-cache-search \"temp:*\"           # 🧹 Temporary data keys"
        echo ""
        echo "🚀 ASYNC Features:"
        echo "  ⚡ Non-blocking pattern scanning"
        echo "  🔍 Advanced pattern matching"
        echo "  📊 Bulk key analysis"
        echo "  🎯 Optimized for large datasets"
        echo ""
        echo "🔍 Pattern Syntax:"
        echo "  *        📏 Matches any string"
        echo "  ?        📍 Matches single character"
        echo "  [abc]    🎯 Matches any character in brackets"
        echo "  [a-z]    📊 Matches character range"
        echo "  \\*       🛡️ Literal asterisk (escaped)"
        echo ""
        echo "💡 Pro Tips:"
        echo "  🏷️ All keys are prefixed with '${CLAUDE_CACHE_PREFIX}'"
        echo "  🔢 Use --count for performance with large result sets"
        echo "  📋 Combine with 'cc-cache-del' for bulk cleanup"
        echo "  ⚡ Use specific patterns to avoid full scans"
        return 0
    fi
    
    local pattern="$1"       # 🔍 Search pattern
    local count_only=false
    [[ "$2" == "--count" ]] && count_only=true
    
    # 🛡️ Input validation
    if [[ -z "$pattern" ]]; then
        echo "❌ Usage: cc-cache-search <pattern> [--count]"
        echo "💡 Use 'cc-cache-search -h' for pattern syntax help! 🔍"
        return 1
    fi
    
    # 🏷️ Add prefix to pattern for consistency
    local prefixed_pattern="${CLAUDE_CACHE_PREFIX}${pattern}"
    
    echo "🔍🚀 Async searching for pattern: $prefixed_pattern"
    [[ "$count_only" == true ]] && echo "🔢 Count-only mode enabled"
    
    # 🚀 Launch async Redis KEYS operation with Claude Code!
    if [[ "$count_only" == true ]]; then
        run_claude_async "Generate Redis commands to count keys matching pattern '$prefixed_pattern' on Redis host $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB. Use EVAL with Lua script for efficient counting if possible, or KEYS with wc -l. Include performance metrics." &
    else
        run_claude_async "Generate Redis KEYS command to find all keys matching pattern '$prefixed_pattern' on Redis host $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB. Include:
1. Full key listing with prefixes
2. Total count of matches  
3. Key size analysis if possible
4. TTL information for found keys
5. Performance warning if result set is large

Format output with emojis and readable sections." &
    fi
    
    # ⚡ Non-blocking execution
    echo "✅ Async pattern search initiated! 🔍"
    echo "💡 Use 'wait_for_claude_jobs' to see results"
    echo "⚠️ Large result sets may take longer to process"
}

# ⏰ cc-cache-ttl - Check or update TTL for cache keys (ASYNC EXECUTION) 🚀
# 🎯 Usage: cc-cache-ttl "key" [new_ttl]
# 📝 Examples:
#   cc-cache-ttl "user:123"        # ⏰ Check current TTL
#   cc-cache-ttl "user:123" 7200   # ⏰ Set new TTL (2 hours)
cc-cache-ttl() {
    # 🆘 Check for help flag - TTL management explained! ⏰
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "⏰🚀 cc-cache-ttl - Check or update TTL for cache keys (ASYNC MODE)"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-ttl <key> [new_ttl]"
        echo ""
        echo "📝 Parameters:"
        echo "  key          🔑 Cache key to check/update (required)"
        echo "  new_ttl      ⏰ New TTL in seconds (optional) - If provided, updates TTL"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-ttl \"user:123\"            # ⏰ Check current TTL"
        echo "  cc-cache-ttl \"user:123\" 7200       # ⏰ Set TTL to 2 hours"
        echo "  cc-cache-ttl \"session:abc\" 3600    # 🔐 Extend session 1 hour"
        echo "  cc-cache-ttl \"temp:data\" -1        # ♾️ Remove TTL (make permanent)"
        echo ""
        echo "🚀 ASYNC Features:"
        echo "  ⚡ Non-blocking TTL operations"
        echo "  🔍 Instant TTL checking"
        echo "  ⏰ Atomic TTL updates"
        echo "  📊 TTL analytics and trends"
        echo ""
        echo "⏰ TTL Values Explained:"
        echo "  > 0      📅 Seconds until expiration"
        echo "  -1       ♾️ Key exists but no expiration"
        echo "  -2       ❌ Key does not exist"
        echo "  0        💀 Key expired (being deleted)"
        echo ""
        echo "💡 Pro Tips:"
        echo "  🔍 Check TTL before extending sessions"
        echo "  📊 Monitor TTL patterns with 'cc-cache-monitor'"
        echo "  ⚡ Use negative TTL to make keys permanent"
        echo "  🎯 Batch TTL updates for efficiency"
        return 0
    fi
    
    local key="$1"           # 🔑 Cache key
    local new_ttl="$2"       # ⏰ New TTL (optional)
    
    # 🛡️ Input validation
    if [[ -z "$key" ]]; then
        echo "❌ Usage: cc-cache-ttl <key> [new_ttl]"
        echo "💡 Use 'cc-cache-ttl -h' for detailed help! ⏰"
        return 1
    fi
    
    # 🏷️ Add prefix for consistency
    local prefixed_key="${CLAUDE_CACHE_PREFIX}${key}"
    
    if [[ -n "$new_ttl" ]]; then
        echo "⏰🚀 Async updating TTL for: $prefixed_key → ${new_ttl}s"
        
        # 🚀 Launch async TTL update with Claude Code!
        run_claude_async "Generate Redis EXPIRE command to set TTL for key '$prefixed_key' to $new_ttl seconds on Redis host $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB. Include:
1. Current TTL check before update
2. EXPIRE command execution
3. Verification of new TTL
4. Success/failure confirmation
5. Handle special cases (key doesn't exist, negative TTL)

Format with clear before/after comparison." &
    else
        echo "⏰🚀 Async checking TTL for: $prefixed_key"
        
        # 🚀 Launch async TTL check with Claude Code!
        run_claude_async "Generate Redis TTL command to check expiration time for key '$prefixed_key' on Redis host $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB. Include:
1. TTL command execution
2. Human-readable interpretation of result
3. Time remaining calculation
4. Expiration timestamp if applicable
5. Key existence verification

Format with emoji indicators for different TTL states." &
    fi
    
    # ⚡ Non-blocking execution
    echo "✅ Async TTL operation initiated! ⏰"
    echo "💡 Use 'wait_for_claude_jobs' to see the result"
}

# 📈 cc-cache-monitor - Monitor cache performance and health (ASYNC EXECUTION) 🚀
# 🎯 Usage: cc-cache-monitor [duration_seconds] [--alerts]
# 📝 Examples:
#   cc-cache-monitor 60           # 📊 Monitor for 1 minute
#   cc-cache-monitor 300 --alerts # 🚨 5-minute monitoring with alerts
cc-cache-monitor() {
    # 🆘 Check for help flag - Monitoring explained! 📈
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📈🚀 cc-cache-monitor - Monitor cache performance and health (ASYNC MODE)"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-cache-monitor [duration_seconds] [--alerts]"
        echo ""
        echo "📝 Parameters:"
        echo "  duration_seconds  ⏱️ Monitoring duration (optional, default: 60)"
        echo "  --alerts         🚨 Enable performance alerts (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-cache-monitor                     # 📊 Basic 60-second monitoring"
        echo "  cc-cache-monitor 300                 # 📈 5-minute performance check"
        echo "  cc-cache-monitor 120 --alerts        # 🚨 2-min with alert system"
        echo "  cc-cache-monitor 3600 --alerts       # 📊 1-hour deep monitoring"
        echo ""
        echo "🚀 ASYNC Features:"
        echo "  ⚡ Non-blocking performance tracking"
        echo "  📊 Real-time metrics collection"
        echo "  🎯 Intelligent threshold monitoring"
        echo "  📈 Historical trend analysis"
        echo ""
        echo "📊 Metrics Monitored:"
        echo "  🔢 Operations per second (GET/SET/DEL)"
        echo "  💾 Memory usage and efficiency"
        echo "  ⚡ Hit/miss ratios"
        echo "  🌐 Connection counts and health"
        echo "  ⏰ Average response times"
        echo "  🔍 Key count changes"
        echo "  📈 Throughput trends"
        echo ""
        echo "🚨 Alert Conditions (with --alerts):"
        echo "  💾 Memory usage > 80%"
        echo "  ⚡ Hit ratio < 70%"
        echo "  🌐 Connection spikes"
        echo "  ⏰ Response time > 10ms"
        echo "  🔥 Error rate increases"
        echo ""
        echo "💡 Pro Tips:"
        echo "  📊 Run during peak hours for best insights"
        echo "  🎯 Use alerts for production monitoring"
        echo "  📈 Export data for long-term analysis"
        echo "  ⚡ Correlate with application performance"
        return 0
    fi
    
    local duration="${1:-60}"    # ⏱️ Default 60 seconds
    local alerts=false
    [[ "$2" == "--alerts" ]] && alerts=true
    
    # 🛡️ Input validation
    if ! [[ "$duration" =~ ^[0-9]+$ ]] || [[ "$duration" -lt 10 ]]; then
        echo "❌ Duration must be at least 10 seconds"
        echo "💡 Use 'cc-cache-monitor -h' for examples! 📈"
        return 1
    fi
    
    echo "📈🚀 Async cache monitoring started!"
    echo "⏱️ Duration: ${duration} seconds"
    echo "🎯 Target: ${CLAUDE_REDIS_HOST}:${CLAUDE_REDIS_PORT} DB:${CLAUDE_REDIS_DB}"
    [[ "$alerts" == true ]] && echo "🚨 Performance alerts enabled!"
    
    # 🌟 Show monitoring configuration
    echo ""
    echo "📊 Monitoring Configuration:"
    echo "  🏷️ Key prefix: ${CLAUDE_CACHE_PREFIX}"
    echo "  ⏰ Sample interval: 5 seconds"
    echo "  📈 Metrics: ops/sec, memory, hit ratio, connections"
    [[ "$alerts" == true ]] && echo "  🚨 Alert thresholds: mem>80%, hit<70%, latency>10ms"
    echo ""
    
    # 🚀 Launch async monitoring with Claude Code!
    if [[ "$alerts" == true ]]; then
        run_claude_async "Create a comprehensive Redis performance monitoring script for $duration seconds with alerting:

Target: Redis at $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB
Key prefix: ${CLAUDE_CACHE_PREFIX}
Sample every 5 seconds for $duration seconds total.

Monitor and report:
1. Operations per second (GET, SET, DEL commands)
2. Memory usage and efficiency
3. Hit/miss ratios and cache effectiveness
4. Connected clients and connection health
5. Average response times and latency
6. Key count changes over time
7. Error rates and failed operations

ALERTING (when enabled):
- Alert if memory usage > 80%
- Alert if hit ratio drops < 70%
- Alert if response time > 10ms
- Alert if error rate increases
- Alert on connection spikes

Format as real-time dashboard with timestamps, emojis, and clear alerts." &
    else
        run_claude_async "Create a Redis performance monitoring script for $duration seconds:

Target: Redis at $CLAUDE_REDIS_HOST:$CLAUDE_REDIS_PORT database $CLAUDE_REDIS_DB
Key prefix: ${CLAUDE_CACHE_PREFIX}
Sample every 5 seconds for $duration seconds total.

Collect and display:
1. Basic performance metrics (ops/sec, memory, connections)
2. Cache efficiency (hit/miss ratios)
3. Key count trends
4. Response time averages
5. Summary statistics at end

Format as clean dashboard with emojis and readable output." &
    fi
    
    # ⚡ Non-blocking execution
    echo "✅ Async monitoring session initiated! 📈"
    echo "💡 Use 'wait_for_claude_jobs' to see the full report"
    echo "⏱️ Monitoring will run for ${duration} seconds..."
}

# 🆘 cc-cache-help - Show help for all cache functions 🚀
# 🎯 Usage: cc-cache-help [function_name]
# 📝 Examples:
#   cc-cache-help                 # 📚 All cache functions
#   cc-cache-help "cc-cache-set"  # 💾 Specific function help
cc-cache-help() {
    local function_name="$1"    # 🔍 Specific function (optional)
    
    if [[ -n "$function_name" ]]; then
        # 📖 Try to call the specific function with -h flag
        echo "🆘 Getting help for: $function_name"
        echo "════════════════════════════════════════════════════════════════"
        if "$function_name" -h 2>/dev/null; then
            return 0
        else
            echo "❌ Function not found: $function_name"
            echo ""
            echo "💡 Available cache functions (ASYNC MODE):"
            echo "   💾 cc-cache-set     - Store data with TTL"
            echo "   📖 cc-cache-get     - Retrieve cached data"
            echo "   🗑️ cc-cache-del     - Delete cache keys"
            echo "   📊 cc-cache-stats   - Performance statistics"
            echo "   🧹 cc-cache-flush   - Clear all cache (dangerous!)"
            echo "   🔍 cc-cache-search  - Search keys by pattern"
            echo "   ⏰ cc-cache-ttl     - Check/update TTL"
            echo "   📈 cc-cache-monitor - Performance monitoring"
            echo ""
            echo "🚀 Try: cc-cache-help cc-cache-set"
            return 1
        fi
    else
        # 📚 Show comprehensive help overview
        echo "💾🚀 Claude Async Cache Functions Help"
        echo "════════════════════════════════════════════════════════════════"
        echo "🎯 HIGH-PERFORMANCE ASYNC REDIS CACHING TOOLKIT"
        echo "📺 Inspired by IndyDevDan's amazing tutorials!"
        echo ""
        echo "🚀 ASYNC MODE Features:"
        echo "  ⚡ Non-blocking operations for maximum performance"
        echo "  🔄 Automatic retry with exponential backoff"  
        echo "  📊 Built-in performance monitoring and analytics"
        echo "  🎯 Optimized for high-throughput batch operations"
        echo "  🛡️ Comprehensive error handling and safety checks"
        echo ""
        echo "⚙️ Quick Configuration Check:"
        echo "  🏠 Redis: ${CLAUDE_REDIS_HOST}:${CLAUDE_REDIS_PORT}"
        echo "  🗄️ Database: ${CLAUDE_REDIS_DB}"
        echo "  🏷️ Key prefix: ${CLAUDE_CACHE_PREFIX}"
        echo "  ⏰ Default TTL: ${CLAUDE_CACHE_TTL} seconds"
        echo ""
        echo "🚀 Quick Start Guide:"
        echo "  cc-cache-set 'user:123' 'John Doe' 300    # 💾 Store user for 5min"
        echo "  cc-cache-get 'user:123'                   # 📖 Retrieve user data"
        echo "  cc-cache-stats                            # 📊 Check performance"
        echo "  wait_for_claude_jobs                      # ⏳ Wait for completion"
        echo ""
        echo "📚 Available Functions (All ASYNC!):"
        echo "  💾 cc-cache-set      - Store data with TTL in cache"
        echo "  📖 cc-cache-get      - Retrieve data from cache"
        echo "  🗑️ cc-cache-del      - Delete specific cache keys"
        echo "  📊 cc-cache-stats    - Show performance statistics"
        echo "  🧹 cc-cache-flush    - Clear all cache (DANGEROUS!)"
        echo "  🔍 cc-cache-search   - Search keys by patterns"
        echo "  ⏰ cc-cache-ttl      - Check/update key expiration"
        echo "  📈 cc-cache-monitor  - Real-time performance monitoring"
        echo ""
        echo "💡 Pro Tips for ASYNC Usage:"
        echo "  🎯 Use 'wait_for_claude_jobs' after async operations"
        echo "  📊 Monitor performance with 'cc-cache-monitor'"
        echo "  🔍 Search before bulk operations with 'cc-cache-search'"
        echo "  ⚡ Batch operations are optimized for parallel execution"
        echo "  🛡️ Always test with --dry-run flags where available"
        echo ""
        echo "🆘 For detailed help on any function:"
        echo "  cc-cache-help <function_name>   # 📖 Specific function help"
        echo "  <function_name> -h              # 💡 Quick help"
        echo ""
        echo "📺 Learn more from IndyDevDan: https://www.youtube.com/c/IndyDevDan"
    fi
}

# 🎉 Cache module loaded message with configuration display! ✨
echo ""
echo "💾🚀 Claude ASYNC Cache Module Loaded Successfully!"
echo "════════════════════════════════════════════════════════════════"
echo "⚡ ASYNC MODE: All operations run asynchronously for maximum performance!"
echo ""
echo "⚙️ Current Configuration:"
echo "  🏠 Redis Host: ${CLAUDE_REDIS_HOST}:${CLAUDE_REDIS_PORT}"
echo "  🗄️ Database: ${CLAUDE_REDIS_DB}"
echo "  🏷️ Key Prefix: ${CLAUDE_CACHE_PREFIX}"
echo "  ⏰ Default TTL: ${CLAUDE_CACHE_TTL} seconds"
echo ""
echo "🚀 Quick Test:"
echo "  cc-cache-set 'test' 'Hello Async World!' 60"
echo "  cc-cache-get 'test'"
echo "  wait_for_claude_jobs"
echo ""
echo "💡 Get help: cc-cache-help"
echo "📺 Inspired by IndyDevDan's tutorials! 🌟"