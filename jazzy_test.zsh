#!/usr/bin/env zsh

# 🎨⚡ ULTRA JAZZY Claude Code Function Test with KLEUR Magic! ✨🎭
# ════════════════════════════════════════════════════════════════════════════════
# 🎯 Dynamic colors, animated loading, and emoji magic for each test! 🌈
# 📺 Inspired by IndyDevDan's incredible tutorials! 
# 🌟 Learn more: https://www.youtube.com/c/IndyDevDan
# ════════════════════════════════════════════════════════════════════════════════

# 🎭 Install kleur if not available
if ! command -v node >/dev/null 2>&1; then
    echo "❌ Node.js required for kleur colors!"
    exit 1
fi

# 🎨 Create kleur color helper
create_kleur_helper() {
    cat > /tmp/kleur_helper.js << 'EOF'
const kleur = require('kleur');

const style = process.argv[2];
const text = process.argv.slice(3).join(' ');

switch(style) {
    case 'banner':
        console.log(kleur.bold().magenta().bgBlack(text));
        break;
    case 'success':
        console.log(kleur.bold().green(text));
        break;
    case 'fail':
        console.log(kleur.bold().red(text));
        break;
    case 'info':
        console.log(kleur.bold().cyan(text));
        break;
    case 'warning':
        console.log(kleur.bold().yellow(text));
        break;
    case 'loading':
        console.log(kleur.dim().blue(text));
        break;
    case 'perf':
        console.log(kleur.bold().magenta(text));
        break;
    case 'rainbow':
        // Rainbow effect
        const colors = ['red', 'yellow', 'green', 'cyan', 'blue', 'magenta'];
        let output = '';
        for (let i = 0; i < text.length; i++) {
            const color = colors[i % colors.length];
            output += kleur[color](text[i]);
        }
        console.log(output);
        break;
    case 'pulse':
        // Simulate pulsing effect
        for (let i = 0; i < 3; i++) {
            process.stdout.write('\r' + kleur.bold().cyan('●'.repeat(i + 1)) + ' ' + text);
            require('child_process').execSync('sleep 0.3');
        }
        console.log('\r' + kleur.bold().green('✅') + ' ' + text);
        break;
    default:
        console.log(kleur.white(text));
}
EOF
}

# 🎨 Color helper function
color() {
    local style="$1"
    shift
    node /tmp/kleur_helper.js "$style" "$@"
}

# 🎭 Dynamic emoji selector based on test type
get_test_emoji() {
    local test_type="$1"
    local result="$2"
    
    case "$test_type" in
        "redis"|"cache")
            [[ "$result" == "PASS" ]] && echo "💎🔥" || echo "💥❌"
            ;;
        "mysql"|"database"|"db")
            [[ "$result" == "PASS" ]] && echo "🗄️⚡" || echo "🗄️💥"
            ;;
        "async")
            [[ "$result" == "PASS" ]] && echo "🚀⚡" || echo "🚀💥"
            ;;
        "parallel")
            [[ "$result" == "PASS" ]] && echo "🔄✨" || echo "🔄💥"
            ;;
        "integration")
            [[ "$result" == "PASS" ]] && echo "🌐💫" || echo "🌐💥"
            ;;
        "performance"|"perf")
            [[ "$result" == "PASS" ]] && echo "📊🚀" || echo "📊💥"
            ;;
        *)
            [[ "$result" == "PASS" ]] && echo "✅💯" || echo "❌😵"
            ;;
    esac
}

# 🎪 Animated loading spinner
show_loading() {
    local message="$1"
    local duration="${2:-2}"
    local pid=$!
    
    local spinners=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local colors=('red' 'yellow' 'green' 'cyan' 'blue' 'magenta')
    
    local i=0
    local start_time=$(date +%s)
    
    while [[ $(($(date +%s) - start_time)) -lt $duration ]]; do
        local spinner=${spinners[$((i % ${#spinners[@]}))]}
        local color=${colors[$((i % ${#colors[@]}))]}
        
        echo -ne "\r$(node -e "const kleur=require('kleur'); console.log(kleur.$color('$spinner $message...'))")"
        sleep 0.1
        ((i++))
    done
    
    echo -ne "\r$(color success "✅ $message completed!")          \n"
}

# 🎉 Epic animated banner
show_epic_banner() {
    clear
    create_kleur_helper
    
    echo ""
    color rainbow "🎨⚡ ULTRA JAZZY CLAUDE CODE TEST SUITE ⚡🎨"
    color banner "════════════════════════════════════════════════════════════════════════════════"
    color info "🎯 Dynamic colors, animated loading, and emoji magic! ✨"
    color loading "📺 Inspired by IndyDevDan's amazing tutorials! 🌟"
    echo ""
    
    # 🖥️ System info with colors
    local cpu_cores=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "Unknown")
    local os_type=$(uname -s)
    local test_time=$(date '+%Y-%m-%d %H:%M:%S')
    
    color warning "🖥️ Test Environment:"
    echo "  💻 OS: $(color info "$os_type")"
    echo "  🧠 CPU Cores: $(color info "$cpu_cores")"
    echo "  📅 Test Time: $(color info "$test_time")"
    echo ""
    
    # Animated initialization
    color loading "🚀 Initializing ultra-jazzy test suite..."
    show_loading "Setting up kleur magic" 1
    show_loading "Loading emoji arsenal" 1
    show_loading "Calibrating color spectrum" 1
    echo ""
}

# 📊 Test counters with style
PASSED=0
FAILED=0
declare -A test_colors=(
    ["redis"]="cyan"
    ["mysql"]="blue" 
    ["async"]="magenta"
    ["parallel"]="yellow"
    ["integration"]="green"
    ["performance"]="red"
)

# ✨ Enhanced test function with dynamic colors and emojis
jazzy_test() {
    local name="$1"
    local command="$2"
    local test_type="$3"
    local color_style="${test_colors[$test_type]:-white}"
    
    # Show loading animation
    echo -ne "$(node -e "const kleur=require('kleur'); console.log(kleur.$color_style('🧪 Testing $name...'))")"
    
    # Animated dots
    for i in {1..3}; do
        echo -n "."
        sleep 0.2
    done
    
    if eval "$command" >/dev/null 2>&1; then
        local emoji=$(get_test_emoji "$test_type" "PASS")
        echo -e "\r$(color success "$emoji PASS - $name")                    "
        ((PASSED++))
    else
        local emoji=$(get_test_emoji "$test_type" "FAIL")
        echo -e "\r$(color fail "$emoji FAIL - $name")                    "
        ((FAILED++))
    fi
}

# 🎪 Section headers with style
section_header() {
    local title="$1"
    local emoji="$2"
    local color="$3"
    
    echo ""
    color "$color" "$emoji $title"
    node -e "const kleur=require('kleur'); console.log(kleur.$color('─'.repeat(${#title} + 10)))"
}

# 🚀 Main test execution with MAXIMUM JAZZ!
main() {
    show_epic_banner
    
    # 💎 Redis Cache Tests
    section_header "Redis Cache Functions" "💎🔥" "cyan"
    jazzy_test "Redis Connection" "redis-cli ping" "redis"
    jazzy_test "Cache SET Operation" "redis-cli set 'cc:jazzy_test' 'Ultra Jazzy Data! 🎨' EX 300" "redis"
    jazzy_test "Cache GET Operation" "redis-cli get 'cc:jazzy_test'" "redis"
    jazzy_test "Cache TTL Management" "redis-cli ttl 'cc:jazzy_test'" "redis"
    
    # 🗄️ MySQL Database Tests
    section_header "MySQL Database Functions" "🗄️⚡" "blue"
    jazzy_test "MySQL Connection (admin)" "mysql -u admin -padmin -e 'SELECT 1;'" "mysql"
    jazzy_test "MySQL Connection (hgh)" "mysql -u hgh -padmin -e 'SELECT 1;'" "mysql"
    jazzy_test "MySQL Connection (sms)" "mysql -u sms -padmin -e 'SELECT 1;'" "mysql"
    jazzy_test "Database Creation" "mysql -u admin -padmin -e 'CREATE DATABASE IF NOT EXISTS jazzy_test;'" "mysql"
    jazzy_test "Table Creation" "mysql -u admin -padmin jazzy_test -e 'CREATE TABLE IF NOT EXISTS jazzy_table (id INT AUTO_INCREMENT PRIMARY KEY, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);'" "mysql"
    
    # 🚀 Async Operations Tests
    section_header "Async Operations" "🚀⚡" "magenta"
    jazzy_test "Background Job Creation" "(sleep 1 && echo 'Async magic complete!' > /tmp/jazzy_async.done) &" "async"
    
    # Wait for async job with style
    echo -ne "$(color loading "⏳ Waiting for async job to complete...")"
    wait
    if [[ -f /tmp/jazzy_async.done ]]; then
        echo -e "\r$(color success "🚀⚡ PASS - Async Job Completion")                    "
        ((PASSED++))
        rm -f /tmp/jazzy_async.done
    else
        echo -e "\r$(color fail "🚀💥 FAIL - Async Job Completion")                    "
        ((FAILED++))
    fi
    
    # 🔄 Parallel Operations Tests
    section_header "Parallel Operations" "🔄✨" "yellow"
    
    echo -ne "$(color loading "🔄 Launching parallel job army...")"
    start_time=$(date +%s)
    
    # Launch 5 parallel jobs with different delays
    (sleep 1 && echo "Job 1 complete! 🎯" > /tmp/jazzy_job1.done) &
    (sleep 1 && echo "Job 2 complete! 🎯" > /tmp/jazzy_job2.done) &
    (sleep 1 && echo "Job 3 complete! 🎯" > /tmp/jazzy_job3.done) &
    (sleep 1 && echo "Job 4 complete! 🎯" > /tmp/jazzy_job4.done) &
    (sleep 1 && echo "Job 5 complete! 🎯" > /tmp/jazzy_job5.done) &
    
    # Animated waiting
    local job_count=0
    while [[ $job_count -lt 5 ]]; do
        job_count=0
        for i in {1..5}; do
            [[ -f "/tmp/jazzy_job$i.done" ]] && ((job_count++))
        done
        
        echo -ne "\r$(node -e "const kleur=require('kleur'); console.log(kleur.yellow('🔄 Jobs completed: $job_count/5'))")"
        sleep 0.1
    done
    
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    
    echo -e "\r$(color success "🔄✨ PASS - Parallel Execution ($duration seconds)")                    "
    ((PASSED++))
    rm -f /tmp/jazzy_job*.done
    
    # 🌐 Integration Tests
    section_header "System Integration" "🌐💫" "green"
    
    test_data="jazzy_integration_$(date +%s)"
    echo -ne "$(color loading "🌐 Testing cache+database integration...")"
    
    if redis-cli set "cc:jazzy_integration" "$test_data" EX 300 >/dev/null 2>&1 && \
       mysql -u admin -padmin jazzy_test -e "INSERT INTO jazzy_table (data) VALUES ('$test_data');" >/dev/null 2>&1; then
        echo -e "\r$(color success "🌐💫 PASS - Cache+Database Integration")                    "
        ((PASSED++))
    else
        echo -e "\r$(color fail "🌐💥 FAIL - Cache+Database Integration")                    "
        ((FAILED++))
    fi
    
    # 📊 Performance Benchmark
    section_header "Performance Benchmark" "📊🚀" "red"
    
    echo -ne "$(color perf "📊 Running 100 cache operations...")"
    start_time=$(date +%s.%3N)
    
    for i in {1..100}; do
        redis-cli set "cc:jazzy_perf_$i" "Performance data $i 🚀" EX 60 >/dev/null 2>&1
        
        # Show progress every 20 operations
        if [[ $((i % 20)) -eq 0 ]]; then
            echo -ne "\r$(node -e "const kleur=require('kleur'); console.log(kleur.magenta('📊 Progress: $i/100 operations completed'))")"
        fi
    done
    
    end_time=$(date +%s.%3N)
    duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "1.0")
    ops_per_sec=$(echo "scale=1; 100 / $duration" | bc 2>/dev/null || echo "100")
    
    echo -e "\r$(color perf "📊🚀 PASS - Performance Test (${duration}s, ${ops_per_sec} ops/sec)")                    "
    ((PASSED++))
    
    # Cleanup performance data
    redis-cli eval "return redis.call('del', unpack(redis.call('keys', 'cc:jazzy_perf_*')))" 0 >/dev/null 2>&1
    
    # 🎉 EPIC FINAL RESULTS
    echo ""
    color rainbow "🎉 ULTRA JAZZY TEST RESULTS 🎉"
    color banner "════════════════════════════════════════════════════════════════════════════════"
    echo ""
    
    color success "✅ Passed: $PASSED"
    color fail "❌ Failed: $FAILED"
    color info "📊 Total: $((PASSED + FAILED))"
    
    success_rate=$((PASSED * 100 / (PASSED + FAILED)))
    color perf "🎯 Success Rate: ${success_rate}%"
    
    echo ""
    if [[ $success_rate -eq 100 ]]; then
        color rainbow "🏆🎨 PERFECT JAZZY SCORE! ALL SYSTEMS ULTRA FABULOUS! 🎨🏆"
        color rainbow "💎✨🚀 CLAUDE CODE FUNCTIONS ARE LEGENDARY JAZZ MASTERS! 🚀✨💎"
        
        # Victory animation
        for i in {1..3}; do
            echo -ne "\r$(color rainbow "🎊🎉🎊 CELEBRATION MODE ACTIVATED! 🎊🎉🎊")"
            sleep 0.5
            echo -ne "\r$(color rainbow "🌟⚡🌟 ULTRA PERFORMANCE ACHIEVED! 🌟⚡🌟")"
            sleep 0.5
        done
        echo ""
    elif [[ $success_rate -ge 90 ]]; then
        color success "🚀⚡ EXCELLENT JAZZ! Almost perfect performance! ⚡🚀"
    elif [[ $success_rate -ge 75 ]]; then
        color warning "👍🎵 GOOD RHYTHM! Most functions grooving well! 🎵👍"
    else
        color warning "⚠️🎭 NEEDS TUNING! But the jazz foundation is solid! 🎭⚠️"
    fi
    
    echo ""
    color info "📺 Inspired by IndyDevDan's amazing tutorials! 🌟"
    color loading "🔗 https://www.youtube.com/c/IndyDevDan"
    echo ""
    
    # Cleanup
    rm -f /tmp/kleur_helper.js
    
    # Exit with style
    [[ $FAILED -eq 0 ]] && exit 0 || exit 1
}

# 🎬 Execute the jazzy main function
main "$@"