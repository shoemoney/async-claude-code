# Claude Code Async Runner - Detailed Instructions

## Table of Contents

1. [Installation & Setup](#installation--setup)
2. [Core Concepts](#core-concepts)
3. [Function Reference](#function-reference)
4. [Advanced Usage](#advanced-usage)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)
7. [Examples & Recipes](#examples--recipes)
8. [Performance Optimization](#performance-optimization)

## Installation & Setup

### Prerequisites

1. **Zsh Shell** - Ensure you're using Zsh:
   ```bash
   echo $SHELL  # Should output /bin/zsh or similar
   ```

2. **Claude Code CLI** - Install and authenticate Claude Code:
   ```bash
   # Check if Claude Code is installed
   which claude-code
   
   # If not installed, refer to Anthropic's documentation
   ```

3. **zsh-async Library** - Install the async library:
   ```bash
   # Clone to home directory
   git clone https://github.com/mafredri/zsh-async ~/.zsh-async
   
   # Or use a custom location
   git clone https://github.com/mafredri/zsh-async /custom/path/
   ```

### Installation Steps

1. **Download the Script**:
   ```bash
   # Using curl
   curl -O https://example.com/claude-code-async.zsh
   
   # Or using wget
   wget https://example.com/claude-code-async.zsh
   
   # Make it executable
   chmod +x claude-code-async.zsh
   ```

2. **Configure zsh-async Path** (if using custom location):
   ```bash
   # Edit the script and update the source path
   vim claude-code-async.zsh
   # Change: source ~/.zsh-async/async.zsh
   # To: source /your/custom/path/async.zsh
   ```

3. **Load in Current Session**:
   ```bash
   source claude-code-async.zsh
   ```

4. **Add to Shell Profile** (optional):
   ```bash
   # For permanent availability
   echo 'source ~/path/to/claude-code-async.zsh' >> ~/.zshrc
   ```

## Core Concepts

### How It Works

The Claude Code Async Runner uses Zsh's async capabilities to:

1. **Create Worker Processes** - Spawn background workers for Claude Code execution
2. **Submit Jobs** - Queue prompts to be processed by workers
3. **Handle Callbacks** - Process results as jobs complete
4. **Manage State** - Track running jobs and their status

### Job Lifecycle

```
Submit Job → Worker Executes → Callback Triggered → Output Displayed → Cleanup
```

### Worker Model

- Each worker runs in a separate process
- Workers can handle one job at a time
- Multiple workers enable true parallelism
- Workers are automatically cleaned up after use

## Function Reference

### Primary Functions

#### `run_claude_parallel`
Execute multiple Claude Code prompts in parallel.

```bash
run_claude_parallel "prompt1" "prompt2" "prompt3" ...
```

**Parameters:**
- Multiple prompt strings (each as a separate argument)

**Returns:**
- Job IDs for tracking
- Automatic output display on completion

**Example:**
```bash
run_claude_parallel \
    "Create a Python logging utility" \
    "Write a bash backup script" \
    "Generate a JavaScript date formatter"
```

#### `run_claude_async`
Run a single Claude Code prompt asynchronously.

```bash
run_claude_async "your prompt here"
```

**Parameters:**
- `prompt` - The Claude Code prompt to execute

**Returns:**
- Job ID for tracking

**Example:**
```bash
run_claude_async "Write a function to merge two sorted arrays"
```

#### `claude_job_status`
Display currently running Claude Code jobs.

```bash
claude_job_status
```

**Output:**
```
Currently running Claude Code jobs:
  Job #1: Create a Python logging utility...
  Job #2: Write a bash backup script...
```

#### `stop_claude_jobs`
Terminate all running Claude Code jobs.

```bash
stop_claude_jobs
```

**Note:** This immediately stops all workers and clears the job queue.

#### `wait_for_claude_jobs`
Block execution until all jobs complete.

```bash
wait_for_claude_jobs [timeout_seconds]
```

**Parameters:**
- `timeout_seconds` (optional) - Maximum wait time in seconds

**Examples:**
```bash
# Wait indefinitely
wait_for_claude_jobs

# Wait up to 2 minutes
wait_for_claude_jobs 120
```

### Advanced Functions

#### `run_claude_with_handler`
Execute with custom output handling.

```bash
run_claude_with_handler "prompt" "output_file" "callback_function"
```

**Parameters:**
- `prompt` - The Claude Code prompt
- `output_file` - File path to save output (optional)
- `callback_function` - Custom function to call on completion (optional)

**Example:**
```bash
# Define custom handler
process_python_code() {
    local output="$1"
    local return_code="$2"
    
    # Validate Python syntax
    echo "$output" | python -m py_compile -
    echo "Python syntax check completed"
}

# Use custom handler
run_claude_with_handler \
    "Create a Python web server" \
    "server.py" \
    "process_python_code"
```

#### `claude_batch_process`
Process multiple prompts from a file.

```bash
claude_batch_process "input_file" ["output_directory"]
```

**Parameters:**
- `input_file` - File containing prompts (one per line)
- `output_directory` - Directory for output files (default: current directory)

**Example:**
```bash
# Create prompts file
cat > batch_prompts.txt << EOF
Create a Python function for data validation
Write a SQL query optimizer
Generate unit tests for a REST API
Build a JavaScript form validator
EOF

# Process batch
claude_batch_process batch_prompts.txt ./generated_code/
```

## Advanced Usage

### Parallel Pipeline Processing

Create a pipeline of dependent tasks:

```bash
# Step 1: Generate base components
run_claude_parallel \
    "Create a Python data model for users" \
    "Create a Python data model for products" \
    "Create a Python data model for orders"

wait_for_claude_jobs

# Step 2: Generate related components
run_claude_parallel \
    "Create REST API endpoints for the user model" \
    "Create REST API endpoints for the product model" \
    "Create REST API endpoints for the order model"
```

### Dynamic Job Submission

Submit jobs based on conditions:

```bash
# Function to generate code for multiple languages
generate_multilang() {
    local function_desc="$1"
    local -a languages=("Python" "JavaScript" "Go" "Rust")
    local -a prompts=()
    
    for lang in "${languages[@]}"; do
        prompts+=("Write '$function_desc' in $lang")
    done
    
    run_claude_parallel "${prompts[@]}"
}

# Usage
generate_multilang "a binary search function"
```

### Result Aggregation

Collect and process multiple outputs:

```bash
# Generate multiple implementations
run_claude_parallel \
    "Implement quicksort in Python" \
    "Implement mergesort in Python" \
    "Implement heapsort in Python"

# Custom aggregator
aggregate_results() {
    local output_dir="sorting_algorithms"
    mkdir -p "$output_dir"
    
    # Save each result with timestamp
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # Your aggregation logic here
}
```

### Conditional Execution

Run jobs based on previous results:

```bash
# First job with conditional follow-up
run_claude_with_handler \
    "Analyze this codebase and identify potential improvements" \
    "analysis.txt" \
    "handle_analysis"

handle_analysis() {
    local output="$1"
    
    # Check if improvements were found
    if grep -q "optimization opportunity" <<< "$output"; then
        run_claude_async "Generate optimized version of the identified code"
    fi
}
```

## Best Practices

### 1. Prompt Design

**Do:**
- Be specific and detailed in prompts
- Include constraints and requirements
- Specify desired output format

**Don't:**
- Use vague or ambiguous language
- Assume context between jobs
- Create overly complex single prompts

**Good Example:**
```bash
run_claude_async "Create a Python function that validates email addresses using regex, includes unit tests, handles edge cases, and follows PEP 8 style guidelines"
```

### 2. Resource Management

**Monitor System Resources:**
```bash
# Check before running many parallel jobs
top -l 1 | head -n 10

# Limit parallel jobs based on system capacity
if [[ $(sysctl -n hw.ncpu) -lt 8 ]]; then
    # Run fewer parallel jobs on systems with fewer cores
    run_claude_parallel "prompt1" "prompt2"
else
    # Run more on powerful systems
    run_claude_parallel "prompt1" "prompt2" "prompt3" "prompt4"
fi
```

### 3. Error Handling

**Always Include Error Handling:**
```bash
# Wrap execution in error handling
run_batch_with_retry() {
    local max_retries=3
    local retry_count=0
    
    while [[ $retry_count -lt $max_retries ]]; do
        if claude_batch_process "$1" "$2"; then
            echo "Batch processing completed successfully"
            break
        else
            ((retry_count++))
            echo "Attempt $retry_count failed, retrying..."
            sleep 5
        fi
    done
}
```

### 4. Output Organization

**Organize Outputs by Project:**
```bash
# Create project structure
setup_project() {
    local project_name="$1"
    mkdir -p "$project_name"/{src,tests,docs,scripts}
    
    # Generate components in appropriate directories
    run_claude_with_handler \
        "Create main application file" \
        "$project_name/src/main.py" \
        ""
    
    run_claude_with_handler \
        "Create unit tests" \
        "$project_name/tests/test_main.py" \
        ""
}
```

## Troubleshooting

### Common Issues

#### 1. "zsh-async not found"
```bash
# Solution: Verify installation
ls ~/.zsh-async/async.zsh

# If missing, reinstall
git clone https://github.com/mafredri/zsh-async ~/.zsh-async
```

#### 2. "claude-code: command not found"
```bash
# Solution: Check Claude Code installation
which claude-code

# Add to PATH if necessary
export PATH="$PATH:/path/to/claude-code"
```

#### 3. Jobs Not Completing
```bash
# Debug steps:
# 1. Check job status
claude_job_status

# 2. Check Claude Code directly
claude-code "simple test prompt"

# 3. Enable debug output
set -x
run_claude_async "test prompt"
set +x
```

#### 4. High Memory Usage
```bash
# Limit concurrent jobs
MAX_PARALLEL_JOBS=3

# Modified parallel runner
run_claude_limited() {
    local -a prompts=("$@")
    local i
    
    for ((i = 0; i < ${#prompts[@]}; i += MAX_PARALLEL_JOBS)); do
        local batch=("${prompts[@]:i:MAX_PARALLEL_JOBS}")
        run_claude_parallel "${batch[@]}"
        wait_for_claude_jobs
    done
}
```

### Debug Mode

Enable detailed logging:

```bash
# Enable debug mode
CLAUDE_ASYNC_DEBUG=1

# Run with debug output
run_claude_async "test prompt"

# Disable debug mode
unset CLAUDE_ASYNC_DEBUG
```

## Examples & Recipes

### Recipe 1: Full Stack Application Generator

```bash
generate_fullstack_app() {
    local app_name="$1"
    local tech_stack="$2"  # e.g., "React + Node.js + PostgreSQL"
    
    echo "Generating full stack application: $app_name"
    
    # Phase 1: Database and Models
    run_claude_parallel \
        "Create PostgreSQL schema for a $app_name application" \
        "Create Sequelize models for $app_name" \
        "Create database migration scripts"
    
    wait_for_claude_jobs
    
    # Phase 2: Backend
    run_claude_parallel \
        "Create Express.js REST API for $app_name with $tech_stack" \
        "Create authentication middleware with JWT" \
        "Create API documentation with Swagger"
    
    wait_for_claude_jobs
    
    # Phase 3: Frontend
    run_claude_parallel \
        "Create React component structure for $app_name" \
        "Create Redux store and actions" \
        "Create React Router configuration"
    
    wait_for_claude_jobs
    
    echo "Full stack application generated!"
}

# Usage
generate_fullstack_app "task-manager" "React + Node.js + PostgreSQL"
```

### Recipe 2: Code Review and Refactoring Pipeline

```bash
code_review_pipeline() {
    local file_path="$1"
    local language="$2"
    
    # Step 1: Analyze code
    run_claude_with_handler \
        "Review this $language code and identify issues: $(cat $file_path)" \
        "review_$file_path.md" \
        "process_review"
    
    # Step 2: Generate improvements in parallel
    run_claude_parallel \
        "Refactor the code for better performance" \
        "Add comprehensive error handling" \
        "Add unit tests with 100% coverage" \
        "Add detailed documentation"
}

process_review() {
    local review_output="$1"
    echo "Code review completed. Generating improvements..."
}
```

### Recipe 3: Multi-Language Implementation

```bash
implement_algorithm() {
    local algorithm="$1"
    local -a languages=("Python" "JavaScript" "Go" "Rust" "Java")
    local output_dir="implementations_$(date +%Y%m%d_%H%M%S)"
    
    mkdir -p "$output_dir"
    
    # Generate prompts
    local -a prompts=()
    for lang in "${languages[@]}"; do
        prompts+=("Implement $algorithm in $lang with comments and example usage")
    done
    
    # Run in parallel
    run_claude_parallel "${prompts[@]}"
    
    # Wait and organize outputs
    wait_for_claude_jobs
    
    echo "Implementations saved to $output_dir/"
}

# Usage
implement_algorithm "Dijkstra's shortest path algorithm"
```

### Recipe 4: Test Suite Generator

```bash
generate_test_suite() {
    local source_file="$1"
    local framework="$2"  # pytest, jest, go test, etc.
    
    # Analyze source code first
    local code_content=$(cat "$source_file")
    
    # Generate different types of tests in parallel
    run_claude_parallel \
        "Create unit tests for $source_file using $framework" \
        "Create integration tests for $source_file" \
        "Create edge case tests for $source_file" \
        "Create performance benchmarks for $source_file"
    
    wait_for_claude_jobs
    echo "Test suite generated for $source_file"
}
```

## Performance Optimization

### 1. Optimal Parallelism

Determine optimal number of parallel jobs:

```bash
get_optimal_parallel_count() {
    local cpu_count=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
    local memory_gb=$(free -g 2>/dev/null | awk '/^Mem:/{print $2}' || \
                      sysctl -n hw.memsize | awk '{print int($1/1073741824)}')
    
    # Rule of thumb: 1 job per 2 CPU cores, max 1 per 2GB RAM
    local cpu_based=$((cpu_count / 2))
    local mem_based=$((memory_gb / 2))
    
    # Return the minimum
    echo $((cpu_based < mem_based ? cpu_based : mem_based))
}

OPTIMAL_PARALLEL=$(get_optimal_parallel_count)
echo "Optimal parallel jobs: $OPTIMAL_PARALLEL"
```

### 2. Job Batching

Batch large numbers of prompts efficiently:

```bash
batch_process_optimized() {
    local input_file="$1"
    local batch_size="${2:-$(get_optimal_parallel_count)}"
    local output_dir="${3:-./output}"
    
    mkdir -p "$output_dir"
    
    # Read all prompts
    local -a all_prompts=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && all_prompts+=("$line")
    done < "$input_file"
    
    # Process in optimal batches
    local total=${#all_prompts[@]}
    local processed=0
    
    for ((i = 0; i < total; i += batch_size)); do
        local batch=("${all_prompts[@]:i:batch_size}")
        local batch_num=$((i / batch_size + 1))
        
        echo "Processing batch $batch_num ($(($i + 1)) to $((i + ${#batch[@]})) of $total)"
        
        run_claude_parallel "${batch[@]}"
        wait_for_claude_jobs
        
        processed=$((processed + ${#batch[@]}))
        echo "Progress: $processed/$total completed"
    done
}
```

### 3. Memory Management

Monitor and manage memory usage:

```bash
# Function to check available memory before running jobs
check_memory_before_run() {
    local required_mb="${1:-500}"  # Default 500MB per job
    local num_jobs="$2"
    
    local available_mb=$(free -m 2>/dev/null | awk '/^Mem:/{print $7}' || \
                        vm_stat | awk '/free:/{print int($3 * 4096 / 1048576)}')
    
    local needed_mb=$((required_mb * num_jobs))
    
    if [[ $available_mb -lt $needed_mb ]]; then
        echo "Warning: Low memory. Available: ${available_mb}MB, Needed: ${needed_mb}MB"
        echo "Consider running fewer parallel jobs"
        return 1
    fi
    
    return 0
}

# Use before running parallel jobs
if check_memory_before_run 500 4; then
    run_claude_parallel "prompt1" "prompt2" "prompt3" "prompt4"
fi
```

### 4. Network Optimization

Handle network issues gracefully:

```bash
# Retry logic for network failures
run_claude_with_retry() {
    local prompt="$1"
    local max_retries="${2:-3}"
    local retry_delay="${3:-5}"
    
    for ((i = 1; i <= max_retries; i++)); do
        echo "Attempt $i of $max_retries..."
        
        if run_claude_async "$prompt"; then
            return 0
        fi
        
        if [[ $i -lt $max_retries ]]; then
            echo "Failed, retrying in ${retry_delay}s..."
            sleep "$retry_delay"
            retry_delay=$((retry_delay * 2))  # Exponential backoff
        fi
    done
    
    echo "Failed after $max_retries attempts"
    return 1
}
```

## Summary

The Claude Code Async Runner provides a powerful framework for parallelizing AI-powered code generation tasks. By following these instructions and best practices, you can:

- Dramatically reduce code generation time through parallelization
- Handle complex multi-component projects efficiently
- Build sophisticated code generation pipelines
- Maintain organized and manageable outputs

Remember to:
- Start with simple parallel tasks before moving to complex pipelines
- Monitor system resources when running many parallel jobs
- Use appropriate error handling and retry logic
- Organize outputs in a structured manner

For additional help, run `claude_async_usage` or refer to the function documentation within the script.