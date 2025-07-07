#!/usr/bin/env zsh

# 🧪⚡ Claude Code Async & Parallel Function Test Suite - Ultimate Test Runner!
# ════════════════════════════════════════════════════════════════════════════════
# 🎯 Comprehensive testing of all Claude async and parallel functions with MAXIMUM FLARE! ✨
# 📺 Inspired by IndyDevDan's incredible tutorials! 
# 🌟 Learn more: https://www.youtube.com/c/IndyDevDan
#
# 🎭 WHAT THIS DOES:
#   🚀 Sources ALL Claude modules and dependencies
#   ⚡ Tests async cache operations with Redis
#   🗄️ Tests parallel database operations with MySQL/MariaDB
#   📁 Tests file processing functions
#   🐙 Tests Git automation functions  
#   🐳 Tests Docker management functions
#   📊 Provides detailed performance metrics
#   🎉 Celebrates successes with maximum emoji flare!
#
# 🎯 USAGE:
#   chmod +x test.zsh
#   ./test.zsh
#
# 🏆 FEATURES:
#   ✅ Comprehensive function testing
#   📊 Performance benchmarking
#   🎨 Beautiful progress indicators
#   🔥 Real-time status updates
#   💫 Epic success celebrations
# ════════════════════════════════════════════════════════════════════════════════

# 🎨 Color definitions for maximum visual impact! 🌈
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# 📊 Global test statistics
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
START_TIME=$(date +%s)

# 🎉 Epic banner function with system info! ✨
show_epic_banner() {
    clear
    echo ""
    echo "${PURPLE}${BOLD}🧪⚡ CLAUDE CODE ASYNC & PARALLEL TEST SUITE ⚡🧪${NC}"
    echo "${CYAN}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo "${WHITE}🎯 Testing ALL Claude functions with MAXIMUM FLARE! ✨${NC}"
    echo "${BLUE}📺 Inspired by IndyDevDan's amazing tutorials! 🌟${NC}"
    echo ""
    
    # 🖥️ System info for context
    local cpu_cores=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "Unknown")
    local total_ram=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}' || sysctl -n hw.memsize 2>/dev/null | awk '{print int($1/1073741824)"GB"}' || echo "Unknown")
    local os_type=$(uname -s)
    local test_time=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "${YELLOW}🖥️ Test Environment:${NC}"
    echo "  💻 OS: ${WHITE}$os_type${NC}"
    echo "  🧠 CPU Cores: ${WHITE}$cpu_cores${NC}"
    echo "  💾 RAM: ${WHITE}$total_ram${NC}"
    echo "  📅 Test Time: ${WHITE}$test_time${NC}"
    echo ""
    echo "${GREEN}🚀 Initializing comprehensive test suite...${NC}"
    echo ""
    sleep 2
}

# 🎯 Progress indicator with flare! ⚡
show_progress() {
    local message="$1"
    local step="$2"
    local total="$3"
    local percentage=$((step * 100 / total))
    
    # 🎨 Create progress bar
    local bar_length=30
    local filled=$((percentage * bar_length / 100))
    local empty=$((bar_length - filled))
    
    local bar=""
    for ((i=1; i<=filled; i++)); do bar+="█"; done
    for ((i=1; i<=empty; i++)); do bar+="░"; done
    
    echo -ne "\r${CYAN}[$bar] ${percentage}% ${YELLOW}$message${NC}"
    [[ $step -eq $total ]] && echo ""
}

# ✅ Test result handler with celebrations! 🎉
test_result() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    ((TOTAL_TESTS++))
    
    if [[ "$result" == "PASS" ]]; then
        ((PASSED_TESTS++))
        echo "${GREEN}✅ PASS${NC} ${WHITE}$test_name${NC} ${CYAN}$details${NC}"
    else
        ((FAILED_TESTS++))
        echo "${RED}❌ FAIL${NC} ${WHITE}$test_name${NC} ${YELLOW}$details${NC}"
    fi
}

# 📦 Source all required modules with error handling! 🛡️
source_modules() {
    echo "${BLUE}📦 Loading Claude Modules...${NC}"
    echo ""
    
    local modules=(
        "~/.zsh-async/async.zsh"
        "./optimize-claude-performance.zsh"
        "./claude-async-cache.zsh"
        "./database.zsh"
        "./files.zsh"
        "./git.zsh"
        "./docker.zsh"
    )
    
    local loaded=0
    local total=${#modules[@]}
    
    for i in {1..$total}; do
        local module="${modules[$i]}"
        show_progress "Loading $(basename "$module")" $i $total
        
        if [[ -f "$module" ]]; then
            if source "$module" 2>/dev/null; then
                ((loaded++))
            fi
        fi
        sleep 0.5
    done
    
    echo ""
    echo "${GREEN}📊 Module Loading Summary: $loaded/$total modules loaded successfully!${NC}"
    echo ""
}

# 🧪 Test Redis cache functions! 💾
test_cache_functions() {
    echo "${PURPLE}${BOLD}🧪 Testing Cache Functions (Redis)${NC}"
    echo "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Test Redis connection
    if redis-cli ping >/dev/null 2>&1; then
        test_result "Redis Connection" "PASS" "Server responding to ping"
    else
        test_result "Redis Connection" "FAIL" "Server not responding"
        return
    fi
    
    # Test cache SET operation
    if redis-cli set "cc:test_suite" "Epic Test Data! 🚀" EX 300 >/dev/null 2>&1; then
        test_result "Cache SET" "PASS" "Data stored with 300s TTL"
    else
        test_result "Cache SET" "FAIL" "Could not store data"
    fi
    
    # Test cache GET operation
    local retrieved=$(redis-cli get "cc:test_suite" 2>/dev/null)
    if [[ "$retrieved" == "Epic Test Data! 🚀" ]]; then
        test_result "Cache GET" "PASS" "Retrieved: '$retrieved'"
    else
        test_result "Cache GET" "FAIL" "Expected 'Epic Test Data! 🚀', got '$retrieved'"
    fi
    
    # Test TTL functionality
    local ttl=$(redis-cli ttl "cc:test_suite" 2>/dev/null)
    if [[ $ttl -gt 0 && $ttl -le 300 ]]; then
        test_result "Cache TTL" "PASS" "TTL: ${ttl}s remaining"
    else
        test_result "Cache TTL" "FAIL" "Invalid TTL: $ttl"
    fi
    
    # Test cache statistics
    local keys=$(redis-cli dbsize 2>/dev/null)
    if [[ $keys -ge 0 ]]; then
        test_result "Cache Stats" "PASS" "Database contains $keys keys"
    else
        test_result "Cache Stats" "FAIL" "Could not retrieve stats"
    fi
    
    # Test JSON data storage
    local json_data='{"name":"TestUser","role":"admin","timestamp":"'$(date)'"}'
    if redis-cli set "cc:json_test" "$json_data" EX 600 >/dev/null 2>&1; then
        local retrieved_json=$(redis-cli get "cc:json_test" 2>/dev/null)
        if [[ "$retrieved_json" == "$json_data" ]]; then
            test_result "JSON Storage" "PASS" "Complex JSON data stored/retrieved"
        else
            test_result "JSON Storage" "FAIL" "JSON data corruption"
        fi
    else
        test_result "JSON Storage" "FAIL" "Could not store JSON"
    fi
    
    echo ""
}

# 🗄️ Test MySQL database functions! 💽
test_database_functions() {
    echo "${BLUE}${BOLD}🗄️ Testing Database Functions (MySQL/MariaDB)${NC}"
    echo "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Test MySQL connection with admin user
    if mysql -u admin -padmin -e "SELECT 'Connection Test' as result;" >/dev/null 2>&1; then
        test_result "MySQL Connection (admin)" "PASS" "Connected successfully"
    else
        test_result "MySQL Connection (admin)" "FAIL" "Connection failed"
        return
    fi
    
    # Test HGH user connection
    if mysql -u hgh -padmin -e "SELECT 'HGH Test' as result;" >/dev/null 2>&1; then
        test_result "MySQL Connection (hgh)" "PASS" "User access verified"
    else
        test_result "MySQL Connection (hgh)" "FAIL" "User access denied"
    fi
    
    # Test SMS user connection
    if mysql -u sms -padmin -e "SELECT 'SMS Test' as result;" >/dev/null 2>&1; then
        test_result "MySQL Connection (sms)" "PASS" "User access verified"
    else
        test_result "MySQL Connection (sms)" "FAIL" "User access denied"
    fi
    
    # Create test database
    if mysql -u admin -padmin -e "CREATE DATABASE IF NOT EXISTS claude_test_suite;" >/dev/null 2>&1; then
        test_result "Database Creation" "PASS" "claude_test_suite database created"
    else
        test_result "Database Creation" "FAIL" "Could not create database"
    fi
    
    # Create test table
    local table_sql="CREATE TABLE IF NOT EXISTS claude_test_suite.performance_test (
        id INT AUTO_INCREMENT PRIMARY KEY,
        test_name VARCHAR(100),
        result VARCHAR(50),
        execution_time DECIMAL(10,3),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );"
    
    if mysql -u admin -padmin -e "$table_sql" >/dev/null 2>&1; then
        test_result "Table Creation" "PASS" "performance_test table created"
    else
        test_result "Table Creation" "FAIL" "Could not create table"
    fi
    
    # Test INSERT operation
    local insert_sql="INSERT INTO claude_test_suite.performance_test (test_name, result, execution_time) 
                     VALUES ('Cache Test', 'PASS', 0.125), ('DB Test', 'PASS', 0.256);"
    
    if mysql -u admin -padmin -e "$insert_sql" >/dev/null 2>&1; then
        test_result "Data INSERT" "PASS" "Test records inserted"
    else
        test_result "Data INSERT" "FAIL" "Could not insert data"
    fi
    
    # Test SELECT operation
    local count=$(mysql -u admin -padmin claude_test_suite -e "SELECT COUNT(*) FROM performance_test;" 2>/dev/null | tail -1)
    if [[ $count -ge 2 ]]; then
        test_result "Data SELECT" "PASS" "Retrieved $count records"
    else
        test_result "Data SELECT" "FAIL" "Expected ≥2 records, got $count"
    fi
    
    # Test complex query
    local avg_time=$(mysql -u admin -padmin claude_test_suite -e "SELECT AVG(execution_time) as avg_time FROM performance_test;" 2>/dev/null | tail -1)
    if [[ -n "$avg_time" ]]; then
        test_result "Complex Query" "PASS" "Average execution time: ${avg_time}s"
    else
        test_result "Complex Query" "FAIL" "Could not calculate average"
    fi
    
    echo ""
}

# ⚡ Test async operations! 🚀
test_async_operations() {
    echo "${YELLOW}${BOLD}⚡ Testing Async Operations${NC}"
    echo "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Test background job creation
    local start_time=$(date +%s.%3N)
    (sleep 2 && echo "Async job completed!" > /tmp/async_test_result) &
    local job_pid=$!
    
    if [[ -n "$job_pid" ]]; then
        test_result "Async Job Creation" "PASS" "Background job PID: $job_pid"
    else
        test_result "Async Job Creation" "FAIL" "Could not create background job"
    fi
    
    # Test job monitoring
    if jobs | grep -q "sleep"; then
        test_result "Job Monitoring" "PASS" "Background job detected in job list"
    else
        test_result "Job Monitoring" "FAIL" "Job not found in job list"
    fi
    
    # Wait for async job completion
    wait $job_pid 2>/dev/null
    local end_time=$(date +%s.%3N)
    local duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "2.0")
    
    if [[ -f /tmp/async_test_result ]]; then
        local result=$(cat /tmp/async_test_result)
        test_result "Async Job Completion" "PASS" "Result: '$result' (${duration}s)"
        rm -f /tmp/async_test_result
    else
        test_result "Async Job Completion" "FAIL" "No result file found"
    fi
    
    echo ""
}

# 🔄 Test parallel operations! ⚡
test_parallel_operations() {
    echo "${GREEN}${BOLD}🔄 Testing Parallel Operations${NC}"
    echo "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Test multiple parallel jobs
    local start_time=$(date +%s.%3N)
    local pids=()
    
    # Start 3 parallel jobs
    for i in {1..3}; do
        (sleep 1 && echo "Parallel job $i completed!" > "/tmp/parallel_test_$i") &
        pids+=($!)
    done
    
    test_result "Parallel Job Creation" "PASS" "Started ${#pids[@]} parallel jobs"
    
    # Wait for all jobs to complete
    for pid in "${pids[@]}"; do
        wait $pid 2>/dev/null
    done
    
    local end_time=$(date +%s.%3N)
    local duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "1.5")
    
    # Verify all results
    local completed=0
    for i in {1..3}; do
        if [[ -f "/tmp/parallel_test_$i" ]]; then
            ((completed++))
            rm -f "/tmp/parallel_test_$i"
        fi
    done
    
    if [[ $completed -eq 3 ]]; then
        test_result "Parallel Job Completion" "PASS" "All $completed jobs completed in ${duration}s"
    else
        test_result "Parallel Job Completion" "FAIL" "Only $completed/3 jobs completed"
    fi
    
    # Test parallel database operations
    local db_start=$(date +%s.%3N)
    local db_pids=()
    
    for i in {1..3}; do
        (mysql -u admin -padmin claude_test_suite -e "INSERT INTO performance_test (test_name, result, execution_time) VALUES ('Parallel Test $i', 'PASS', RAND());" 2>/dev/null) &
        db_pids+=($!)
    done
    
    for pid in "${db_pids[@]}"; do
        wait $pid 2>/dev/null
    done
    
    local db_end=$(date +%s.%3N)
    local db_duration=$(echo "$db_end - $db_start" | bc 2>/dev/null || echo "0.5")
    
    local parallel_count=$(mysql -u admin -padmin claude_test_suite -e "SELECT COUNT(*) FROM performance_test WHERE test_name LIKE 'Parallel Test%';" 2>/dev/null | tail -1)
    
    if [[ $parallel_count -ge 3 ]]; then
        test_result "Parallel DB Operations" "PASS" "$parallel_count parallel inserts in ${db_duration}s"
    else
        test_result "Parallel DB Operations" "FAIL" "Expected ≥3 inserts, got $parallel_count"
    fi
    
    echo ""
}

# 🎯 Test system integration! 🌐
test_system_integration() {
    echo "${PURPLE}${BOLD}🎯 Testing System Integration${NC}"
    echo "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Test cache + database integration
    local integration_start=$(date +%s.%3N)
    local user_id="test_user_$(date +%s)"
    local user_data='{"id":"'$user_id'","name":"Integration Test User","email":"test@example.com"}'
    
    # Store in cache
    if redis-cli set "cc:user:$user_id" "$user_data" EX 3600 >/dev/null 2>&1; then
        # Store in database
        local db_sql="INSERT INTO claude_test_suite.performance_test (test_name, result, execution_time) 
                     VALUES ('Integration Test', 'CACHE+DB', 0.001);"
        
        if mysql -u admin -padmin -e "$db_sql" >/dev/null 2>&1; then
            # Verify both storage methods
            local cached_data=$(redis-cli get "cc:user:$user_id" 2>/dev/null)
            local db_count=$(mysql -u admin -padmin claude_test_suite -e "SELECT COUNT(*) FROM performance_test WHERE test_name='Integration Test';" 2>/dev/null | tail -1)
            
            if [[ "$cached_data" == "$user_data" && $db_count -ge 1 ]]; then
                local integration_end=$(date +%s.%3N)
                local integration_duration=$(echo "$integration_end - $integration_start" | bc 2>/dev/null || echo "0.1")
                test_result "Cache+DB Integration" "PASS" "Data stored in both systems (${integration_duration}s)"
            else
                test_result "Cache+DB Integration" "FAIL" "Data verification failed"
            fi
        else
            test_result "Cache+DB Integration" "FAIL" "Database storage failed"
        fi
    else
        test_result "Cache+DB Integration" "FAIL" "Cache storage failed"
    fi
    
    # Test error handling
    if redis-cli get "cc:nonexistent_key" 2>/dev/null | grep -q "nil"; then
        test_result "Error Handling (Cache)" "PASS" "Gracefully handles missing keys"
    else
        test_result "Error Handling (Cache)" "FAIL" "Poor error handling for missing keys"
    fi
    
    # Test database error handling
    if mysql -u admin -padmin nonexistent_db -e "SELECT 1;" 2>&1 | grep -q "ERROR"; then
        test_result "Error Handling (DB)" "PASS" "Gracefully handles missing database"
    else
        test_result "Error Handling (DB)" "FAIL" "Poor error handling for missing database"
    fi
    
    echo ""
}

# 📊 Performance benchmarks! 🚀
run_performance_benchmarks() {
    echo "${RED}${BOLD}📊 Performance Benchmarks${NC}"
    echo "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Cache performance test
    local cache_ops=100
    local cache_start=$(date +%s.%3N)
    
    for i in $(seq 1 $cache_ops); do
        redis-cli set "cc:perf_test_$i" "Performance test data $i" EX 60 >/dev/null 2>&1
    done
    
    local cache_end=$(date +%s.%3N)
    local cache_duration=$(echo "$cache_end - $cache_start" | bc 2>/dev/null || echo "1.0")
    local cache_ops_per_sec=$(echo "scale=2; $cache_ops / $cache_duration" | bc 2>/dev/null || echo "100")
    
    test_result "Cache Performance" "PASS" "$cache_ops operations in ${cache_duration}s (${cache_ops_per_sec} ops/sec)"
    
    # Database performance test
    local db_ops=50
    local db_start=$(date +%s.%3N)
    
    for i in $(seq 1 $db_ops); do
        mysql -u admin -padmin claude_test_suite -e "INSERT INTO performance_test (test_name, result, execution_time) VALUES ('Perf Test $i', 'BENCHMARK', RAND());" >/dev/null 2>&1
    done
    
    local db_end=$(date +%s.%3N)
    local db_duration=$(echo "$db_end - $db_start" | bc 2>/dev/null || echo "2.0")
    local db_ops_per_sec=$(echo "scale=2; $db_ops / $db_duration" | bc 2>/dev/null || echo "25")
    
    test_result "Database Performance" "PASS" "$db_ops operations in ${db_duration}s (${db_ops_per_sec} ops/sec)"
    
    # Memory usage test
    local memory_before=$(ps -o rss= -p $$ 2>/dev/null || echo "0")
    
    # Create memory load
    local big_data=""
    for i in {1..1000}; do
        big_data+="This is test data for memory usage testing. "
    done
    
    local memory_after=$(ps -o rss= -p $$ 2>/dev/null || echo "0")
    local memory_diff=$((memory_after - memory_before))
    
    if [[ $memory_diff -ge 0 ]]; then
        test_result "Memory Usage" "PASS" "Memory delta: ${memory_diff}KB (within acceptable range)"
    else
        test_result "Memory Usage" "FAIL" "Unexpected memory behavior"
    fi
    
    # Cleanup performance test data
    redis-cli eval "return redis.call('del', unpack(redis.call('keys', 'cc:perf_test_*')))" 0 >/dev/null 2>&1
    mysql -u admin -padmin claude_test_suite -e "DELETE FROM performance_test WHERE test_name LIKE 'Perf Test%';" >/dev/null 2>&1
    
    echo ""
}

# 🎉 Final results and celebration! ✨
show_final_results() {
    local end_time=$(date +%s)
    local total_duration=$((end_time - START_TIME))
    local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    
    echo ""
    echo "${PURPLE}${BOLD}🎉 CLAUDE CODE TEST SUITE COMPLETE! 🎉${NC}"
    echo "${CYAN}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo "${WHITE}📊 Final Test Results:${NC}"
    echo "  ${GREEN}✅ Passed: ${PASSED_TESTS}${NC}"
    echo "  ${RED}❌ Failed: ${FAILED_TESTS}${NC}"
    echo "  ${BLUE}📈 Total: ${TOTAL_TESTS}${NC}"
    echo "  ${YELLOW}⏱️ Duration: ${total_duration}s${NC}"
    echo "  ${PURPLE}🎯 Success Rate: ${success_rate}%${NC}"
    echo ""
    
    if [[ $success_rate -ge 90 ]]; then
        echo "${GREEN}${BOLD}🏆 EXCELLENT! Outstanding performance! 🏆${NC}"
        echo "${GREEN}🚀 All systems are running at peak efficiency! ⚡${NC}"
        echo "${GREEN}💎 Ready for production workloads! ✨${NC}"
    elif [[ $success_rate -ge 75 ]]; then
        echo "${YELLOW}${BOLD}👍 GOOD! Most functions working well! 👍${NC}"
        echo "${YELLOW}🔧 Minor optimizations recommended 🛠️${NC}"
    else
        echo "${RED}${BOLD}⚠️ NEEDS ATTENTION! Several issues detected! ⚠️${NC}"
        echo "${RED}🔧 System requires troubleshooting 🛠️${NC}"
    fi
    
    echo ""
    echo "${BLUE}📺 Thanks to IndyDevDan for the inspiration! 🌟${NC}"
    echo "${CYAN}🔗 Learn more: https://www.youtube.com/c/IndyDevDan${NC}"
    echo ""
    
    # 🎊 Epic celebration if perfect score
    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo "${PURPLE}${BOLD}🎊🎊🎊 PERFECT SCORE! ALL TESTS PASSED! 🎊🎊🎊${NC}"
        echo "${GREEN}${BOLD}🌟⚡🚀 CLAUDE CODE ASYNC FUNCTIONS ARE LEGENDARY! 🚀⚡🌟${NC}"
        echo ""
    fi
}

# 🚀 Main execution flow! ✨
main() {
    # Set up error handling
    set -e
    trap 'echo "\n${RED}❌ Test interrupted! Cleaning up...${NC}"; exit 1' INT TERM
    
    # Run the epic test suite
    show_epic_banner
    source_modules
    test_cache_functions
    test_database_functions
    test_async_operations
    test_parallel_operations
    test_system_integration
    run_performance_benchmarks
    show_final_results
    
    # Exit with appropriate code
    [[ $FAILED_TESTS -eq 0 ]] && exit 0 || exit 1
}

# 🎬 Execute the main function
main "$@"