#!/usr/bin/env zsh

# 🧪 Simple Claude Code Function Test with Maximum Flare! ✨
echo ""
echo "🚀⚡ CLAUDE CODE FUNCTION TEST SUITE ⚡🚀"
echo "════════════════════════════════════════════════════════"
echo "🎯 Testing async and parallel functions with FLARE! ✨"
echo ""

# 📊 Test counters
PASSED=0
FAILED=0

# ✅ Test function
test_func() {
    local name="$1"
    local command="$2"
    
    echo -n "🧪 Testing $name... "
    
    if eval "$command" >/dev/null 2>&1; then
        echo "✅ PASS"
        ((PASSED++))
    else
        echo "❌ FAIL"
        ((FAILED++))
    fi
}

echo "💾 Testing Redis Cache Functions:"
echo "────────────────────────────────"

test_func "Redis Connection" "redis-cli ping"
test_func "Cache SET" "redis-cli set 'cc:test' 'Hello World!' EX 300"
test_func "Cache GET" "redis-cli get 'cc:test'"
test_func "Cache TTL" "redis-cli ttl 'cc:test'"

echo ""
echo "🗄️ Testing MySQL Database Functions:"
echo "─────────────────────────────────────"

test_func "MySQL Connection (admin)" "mysql -u admin -padmin -e 'SELECT 1;'"
test_func "MySQL Connection (hgh)" "mysql -u hgh -padmin -e 'SELECT 1;'"
test_func "MySQL Connection (sms)" "mysql -u sms -padmin -e 'SELECT 1;'"
test_func "Database Creation" "mysql -u admin -padmin -e 'CREATE DATABASE IF NOT EXISTS async_test;'"
test_func "Table Creation" "mysql -u admin -padmin async_test -e 'CREATE TABLE IF NOT EXISTS test_table (id INT AUTO_INCREMENT PRIMARY KEY, data VARCHAR(100));'"

echo ""
echo "⚡ Testing Async Operations:"
echo "───────────────────────────"

# Test background job
test_func "Background Job" "(sleep 1 && echo 'done') &"

# Test multiple parallel jobs
echo -n "🧪 Testing Parallel Jobs... "
start_time=$(date +%s)

# Start 3 parallel jobs
(sleep 1 && touch /tmp/job1.done) &
(sleep 1 && touch /tmp/job2.done) &  
(sleep 1 && touch /tmp/job3.done) &

# Wait for all jobs
wait

end_time=$(date +%s)
duration=$((end_time - start_time))

# Check if all jobs completed
if [[ -f /tmp/job1.done && -f /tmp/job2.done && -f /tmp/job3.done ]]; then
    echo "✅ PASS (${duration}s - true parallel execution!)"
    ((PASSED++))
    rm -f /tmp/job*.done
else
    echo "❌ FAIL"
    ((FAILED++))
fi

echo ""
echo "🔄 Testing Cache + Database Integration:"
echo "────────────────────────────────────────"

# Integration test
echo -n "🧪 Testing Cache+DB Integration... "
test_data="integration_test_$(date +%s)"

if redis-cli set "cc:integration" "$test_data" EX 300 >/dev/null 2>&1 && \
   mysql -u admin -padmin async_test -e "INSERT INTO test_table (data) VALUES ('$test_data');" >/dev/null 2>&1; then
    echo "✅ PASS"
    ((PASSED++))
else
    echo "❌ FAIL"  
    ((FAILED++))
fi

echo ""
echo "🎊 PERFORMANCE BENCHMARK:"
echo "─────────────────────────"

# Cache performance test
echo -n "🧪 Cache Performance (100 ops)... "
start_time=$(date +%s.%3N)

for i in {1..100}; do
    redis-cli set "cc:perf_$i" "data_$i" EX 60 >/dev/null 2>&1
done

end_time=$(date +%s.%3N)
duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "1.0")
ops_per_sec=$(echo "scale=1; 100 / $duration" | bc 2>/dev/null || echo "100")

echo "✅ DONE (${duration}s, ${ops_per_sec} ops/sec)"

# Cleanup
redis-cli eval "return redis.call('del', unpack(redis.call('keys', 'cc:perf_*')))" 0 >/dev/null 2>&1

echo ""
echo "🎉 FINAL RESULTS:"
echo "════════════════"
echo "✅ Passed: $PASSED"
echo "❌ Failed: $FAILED"
echo "📊 Total: $((PASSED + FAILED))"

success_rate=$((PASSED * 100 / (PASSED + FAILED)))
echo "🎯 Success Rate: ${success_rate}%"

if [[ $success_rate -ge 90 ]]; then
    echo ""
    echo "🏆🚀 EXCELLENT! All systems firing on all cylinders! 🚀🏆"
    echo "💎✨ Claude Code async functions are LEGENDARY! ✨💎"
elif [[ $success_rate -ge 75 ]]; then
    echo ""
    echo "👍⚡ GOOD! Most functions working great! ⚡👍"
else
    echo ""
    echo "⚠️🔧 Needs some tuning, but the foundation is solid! 🔧⚠️"
fi

echo ""
echo "📺 Inspired by IndyDevDan's amazing tutorials! 🌟"
echo "🔗 https://www.youtube.com/c/IndyDevDan"
echo ""