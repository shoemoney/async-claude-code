# Async Loops with Claude Code Runner

A collection of 10 examples demonstrating various loop patterns for async operations, including batch processing, sequential naming, and race condition handling.

## Table of Contents

1. [Logo Variations with Sequential Naming](#1-logo-variations-with-sequential-naming)
2. [Batch Processing with Rate Limiting](#2-batch-processing-with-rate-limiting)
3. [Retry Loop with Exponential Backoff](#3-retry-loop-with-exponential-backoff)
4. [Parallel Pipeline with Dependencies](#4-parallel-pipeline-with-dependencies)
5. [Dynamic Queue Processing](#5-dynamic-queue-processing)
6. [Chunked File Processing](#6-chunked-file-processing)
7. [Progressive Enhancement Loop](#7-progressive-enhancement-loop)
8. [Conditional Batch Generation](#8-conditional-batch-generation)
9. [Round-Robin Task Distribution](#9-round-robin-task-distribution)
10. [Adaptive Batch Sizing](#10-adaptive-batch-sizing)

---

## 1. Logo Variations with Sequential Naming

Generate logo variations in batches with a locking mechanism for sequential naming (first come, first served).

```bash
# 🎨 Logo Variations Generator with Sequential Naming
# This function generates logo variations with guaranteed sequential naming using atomic file locks
# Implements first-come-first-served naming to prevent race conditions in parallel generation
generate_logo_variations() {
    local base_prompt="$1"                        # 📝 Base prompt for logo generation
    local total_variations=20                      # 🔢 Total number of logo variations to generate
    local batch_size=5                           # 📦 Number of logos to process in each batch
    local output_dir="./logos"                   # 📁 Directory to store generated logos
    
    # 📁 Create output directory and lock directory
    # Lock directory is used for atomic file operations to prevent race conditions
    mkdir -p "$output_dir"                       # 🏗️ Create main output directory
    mkdir -p "$output_dir/.locks"               # 🔒 Create directory for lock files
    
    echo "🎨 Generating $total_variations logo variations in batches of $batch_size..."
    
    # 🔒 Function to find next available number with locking
    # This function implements atomic number claiming to ensure sequential naming
    # Uses mkdir for atomic lock creation (mkdir is atomic on most filesystems)
    claim_next_number() {
        local max_attempts=100                    # 🔢 Maximum number of attempts to find available slot
        local number=1                          # 🔢 Start numbering from 1
        
        # 🔄 Loop through potential numbers until we find an available one
        while [[ $number -le $max_attempts ]]; do
            local lock_file="$output_dir/.locks/$number.lock"  # 🔒 Lock file path for this number
            local final_file="$output_dir/logo_$number.svg"   # 📄 Final output file path
            
            # 🔒 Try to create lock file atomically
            # mkdir is atomic - either succeeds completely or fails completely
            if mkdir "$lock_file" 2>/dev/null; then
                echo "$number"                   # ✅ Successfully claimed this number
                return 0
            elif [[ -f "$final_file" ]]; then
                # 📄 File already exists, try next number
                ((number++))
            else
                # 🔒 Lock exists but no final file - another process is working on it
                sleep 0.1                        # ⏱️ Wait briefly for the other process
                # 🔍 Check again if final file was created while we waited
                if [[ ! -f "$final_file" ]]; then
                    continue                     # 🔄 Lock still exists, keep waiting
                fi
                ((number++))                     # 📈 Move to next number
            fi
        done
        
        echo "0"                                 # ❌ Failed to claim a number after max attempts
        return 1
    }
    
    # 🎯 Callback function for handling completed jobs
    # This function is called when each logo generation job completes
    # It handles the sequential naming and file saving with proper cleanup
    logo_completion_handler() {
        local job_name="$1"                      # 📝 Name of the completed job
        local return_code="$2"                   # 🔢 Exit code of the job (0 = success)
        local stdout="$3"                        # 📄 Output content from Claude Code
        local exec_time="$4"                     # ⏱️ Time taken to execute the job
        
        # 🏷️ Extract temporary job ID from job name
        # Job names are in format "logo_job_X" so we remove the prefix
        local temp_id="${job_name#logo_job_}"
        
        # 🔢 Claim the next available sequential number
        # This ensures logos are numbered sequentially regardless of completion order
        local seq_number=$(claim_next_number)
        
        if [[ $seq_number -gt 0 ]]; then
            local lock_file="$output_dir/.locks/$seq_number.lock"     # 🔒 Lock file to clean up
            local final_file="$output_dir/logo_$seq_number.svg"       # 📄 Final sequential filename
            
            # 💾 Save the output to the sequentially numbered file
            echo "$stdout" > "$final_file"
            
            # 🧹 Remove the lock file to indicate completion
            # This allows the number to be considered "used" by other processes
            rmdir "$lock_file" 2>/dev/null
            
            echo "✅ Logo variation $seq_number saved (generated in ${exec_time}s)"
        else
            echo "❌ Failed to save logo variation - no available slots"
        fi
    }
    
    # 🏁 Start worker with custom callback
    # Initialize the async worker that will process logo generation jobs
    async_start_worker logo_worker
    async_register_callback logo_worker logo_completion_handler  # 📞 Register our custom completion handler
    
    # 📦 Submit jobs in batches
    # Process logos in controlled batches to manage system resources
    local job_count=0
    while [[ $job_count -lt $total_variations ]]; do
        echo "📤 Submitting batch starting at job $((job_count + 1))..."
        
        # 🔢 Submit batch_size jobs
        # Each batch contains up to batch_size concurrent jobs
        local batch_submitted=0
        while [[ $batch_submitted -lt $batch_size && $job_count -lt $total_variations ]]; do
            # 🎨 Create unique variation prompt for each logo
            # Each logo gets a unique variation prompt to ensure diversity
            local variation_prompt="$base_prompt - Variation $((job_count + 1)): unique style, different color scheme"
            
            # 🚀 Submit job to async worker with unique job ID
            async_job logo_worker claude-code "$variation_prompt" "logo_job_$job_count"
            
            ((job_count++))                    # 📈 Increment total job counter
            ((batch_submitted++))              # 📈 Increment batch counter
        done
        
        # ⏸️ Wait for batch to complete before submitting next batch
        # This prevents overwhelming the system with too many concurrent jobs
        sleep 2                               # ⏱️ Brief pause to let jobs start
        
        # 🔄 Wait for current batch to complete
        # Monitor lock directory to see how many jobs are still running
        while [[ $(ls -1 "$output_dir/.locks" 2>/dev/null | wc -l) -ge $batch_size ]]; do
            sleep 0.5                         # ⏱️ Check every 500ms
        done
    done
    
    # ⏳ Wait for all remaining jobs
    # Ensure all jobs complete before finishing the function
    while [[ $(ls -1 "$output_dir/.locks" 2>/dev/null | wc -l) -gt 0 ]]; do
        sleep 0.5                             # ⏱️ Check every 500ms for completion
    done
    
    # 🧹 Cleanup
    # Stop the async worker and clean up temporary directories
    async_stop_worker logo_worker             # 🛑 Stop the background worker
    rmdir "$output_dir/.locks" 2>/dev/null   # 🗑️ Remove empty lock directory
    
    echo "✅ All $total_variations logo variations generated!"
    echo "📁 Logos saved in: $output_dir"
    ls -la "$output_dir"/logo_*.svg | head -10  # 📋 Show first 10 generated logos
}

# Usage
generate_logo_variations "Create a modern tech company logo with abstract shapes"
```

## 2. Batch Processing with Rate Limiting

Process items in controlled batches with rate limiting to avoid overwhelming resources.

```bash
# ⏱️ Rate Limited Batch Processor Function
# This function processes items from a file with rate limiting to avoid overwhelming APIs or resources
# Implements concurrent job limiting and requests-per-minute throttling for API-friendly processing
rate_limited_batch_processor() {
    local input_file="$1"                       # 📄 Input file containing items to process
    local max_concurrent=3                      # 🔢 Maximum number of concurrent jobs
    local requests_per_minute=30                # ⏱️ Maximum requests per minute to stay within API limits
    local output_dir="./processed"              # 📁 Directory to store processed results
    
    mkdir -p "$output_dir"                     # 🏗️ Create output directory if it doesn't exist
    
    # 📖 Read all items from input file
    # Load all items into memory for processing
    local -a items=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && items+=("$line")    # 📝 Only add non-empty lines
    done < "$input_file"
    
    local total_items=${#items[@]}              # 🔢 Total number of items to process
    local processed=0                          # 🔢 Counter for completed items
    local start_time=$(date +%s)               # ⏰ Record start time for rate limiting
    local request_count=0                      # 🔢 Counter for requests in current minute
    
    echo "⏱️ Processing $total_items items with rate limiting..."
    echo "Max concurrent: $max_concurrent, Max requests/min: $requests_per_minute"
    
    # ⏱️ Create rate limiter function
    # This function enforces rate limiting by tracking requests per minute
    # Automatically pauses processing when rate limits are reached
    check_rate_limit() {
        local current_time=$(date +%s)           # ⏰ Get current timestamp
        local elapsed=$((current_time - start_time))  # 🔢 Calculate elapsed time since last reset
        
        # 🔄 Reset counter every minute
        # If a full minute has passed, reset the request counter
        if [[ $elapsed -ge 60 ]]; then
            start_time=$current_time            # ⏰ Update start time
            request_count=0                    # 🔄 Reset request counter
        fi
        
        # 🚦 Check if we're at the rate limit
        # If we've hit the requests per minute limit, wait until the minute resets
        if [[ $request_count -ge $requests_per_minute ]]; then
            local wait_time=$((60 - elapsed))   # ⏱️ Calculate time remaining in current minute
            echo "⏸️ Rate limit reached. Waiting ${wait_time}s..."
            sleep $wait_time                   # ⏸️ Wait for the minute to reset
            start_time=$(date +%s)             # ⏰ Reset start time
            request_count=0                    # 🔄 Reset request counter
        fi
    }
    
    # 🏁 Start worker for rate-limited processing
    async_start_worker rate_limited_worker
    
    # 📞 Custom callback function for completed jobs
    # This function handles the results of each processed item
    rate_limited_callback() {
        local job_name="$1"                     # 📝 Name of the completed job
        local return_code="$2"                  # 🔢 Exit code (0 = success)
        local stdout="$3"                       # 📄 Output from the processing
        
        # 🏷️ Extract item index from job name
        local item_index="${job_name#item_}"    # 🔢 Remove "item_" prefix to get index
        
        # 💾 Save the processed output to a file
        echo "$stdout" > "$output_dir/processed_$item_index.txt"
        
        # 📈 Update progress counter
        ((processed++))
        
        # 📊 Calculate and display progress percentage
        local progress=$((processed * 100 / total_items))
        echo "[$progress%] Processed item $item_index ($processed/$total_items)"
    }
    
    # 📞 Register the callback function with the worker
    async_register_callback rate_limited_worker rate_limited_callback
    
    # 🔄 Process items with rate limiting
    # Main processing loop that respects both concurrent and rate limits
    local active_jobs=0                        # 🔢 Track number of currently running jobs
    local i=0                                  # 🔢 Index of current item being processed
    
    # 🔄 Continue until all items are submitted and all jobs complete
    while [[ $i -lt $total_items || $active_jobs -gt 0 ]]; do
        # 🚀 Submit new jobs if under limits
        # Only submit new jobs if we haven't hit concurrent or rate limits
        while [[ $i -lt $total_items && $active_jobs -lt $max_concurrent ]]; do
            check_rate_limit                    # ⏱️ Enforce rate limiting before submission
            
            local item="${items[$i]}"           # 📝 Get current item to process
            
            # 🚀 Submit job to process this item
            async_job rate_limited_worker claude-code "Process this item: $item" "item_$i"
            
            ((i++))                           # 📈 Move to next item
            ((active_jobs++))                 # 📈 Increment active job counter
            ((request_count++))               # 📈 Increment rate limit counter
        done
        
        # ⏳ Wait for at least one job to complete
        # This prevents busy waiting and allows jobs to complete
        local prev_processed=$processed
        while [[ $processed -eq $prev_processed && $active_jobs -gt 0 ]]; do
            sleep 0.1                         # ⏱️ Check every 100ms
        done
        
        # 🔄 Update active job count
        # Calculate how many jobs are still running
        active_jobs=$((i - processed))
    done
    
    # 🧹 Cleanup and completion
    async_stop_worker rate_limited_worker      # 🛑 Stop the worker
    echo "✅ Processing complete! Results in: $output_dir"
}

# Usage
echo "Task 1: Generate user dashboard
Task 2: Create API endpoint
Task 3: Build data model" > tasks.txt

rate_limited_batch_processor "tasks.txt"
```

## 3. Retry Loop with Exponential Backoff

Implement robust retry logic for unreliable operations.

```bash
# 🔄 Async Operations with Retry Logic Function
# This function implements robust retry logic with exponential backoff for unreliable operations
# Handles transient failures gracefully with configurable retry attempts and delays
async_with_retry() {
    local max_retries=5                        # 🔢 Maximum number of retry attempts per job
    local base_delay=1                         # ⏱️ Initial delay in seconds for first retry
    local max_delay=60                         # ⏱️ Maximum delay in seconds to prevent excessive waiting
    
    echo "🔄 Starting async operations with retry logic..."
    
    # 📊 Track retry attempts for each job
    # These associative arrays maintain state for each job's retry attempts
    typeset -A retry_counts                    # 🔢 Number of retries attempted for each job
    typeset -A retry_delays                    # ⏱️ Current delay for each job (exponential backoff)
    
    # 🏁 Start worker for retry operations
    async_start_worker retry_worker
    
    # 🔄 Retry handler function
    # This function processes job completion and implements retry logic with exponential backoff
    retry_handler() {
        local job_name="$1"                     # 📝 Name of the completed job
        local return_code="$2"                  # 🔢 Exit code (0 = success, non-zero = failure)
        local stdout="$3"                       # 📄 Standard output from the job
        local stderr="$5"                       # 📄 Standard error from the job
        
        # 🏷️ Extract job ID from job name
        local job_id="${job_name#job_}"         # 🔢 Remove "job_" prefix to get ID
        
        # ✅ Check if job succeeded
        if [[ $return_code -eq 0 ]]; then
            echo "✅ Job $job_id succeeded"
            echo "$stdout" > "success_$job_id.txt"  # 💾 Save successful output
            
            # 🧹 Clean up retry tracking for this job
            unset "retry_counts[$job_id]"
            unset "retry_delays[$job_id]"
        else
            # 📈 Increment retry count for failed job
            local current_retries=${retry_counts[$job_id]:-0}  # 🔢 Get current retry count (default 0)
            ((current_retries++))
            retry_counts[$job_id]=$current_retries
            
            # 🔄 Check if we should retry or give up
            if [[ $current_retries -lt $max_retries ]]; then
                # 📊 Calculate exponential backoff with jitter
                # Jitter prevents thundering herd problem when multiple jobs fail simultaneously
                local delay=${retry_delays[$job_id]:-$base_delay}  # ⏱️ Get current delay (default base_delay)
                local jitter=$((RANDOM % 1000))                    # 🎲 Random jitter 0-999ms
                local total_delay=$(echo "$delay + $jitter/1000" | bc)  # 🧮 Add jitter to delay
                
                echo "⚠️ Job $job_id failed (attempt $current_retries/$max_retries)"
                echo "   Retrying in ${total_delay}s..."
                
                # 🚀 Schedule retry in background
                # Use background process to implement delay without blocking other jobs
                (
                    sleep "$total_delay"             # ⏱️ Wait for calculated delay
                    async_job retry_worker claude-code \
                        "Retry attempt $current_retries: ${original_prompts[$job_id]}" \
                        "$job_name"
                ) &
                
                # 📈 Update delay for next retry (exponential backoff)
                # Each retry doubles the delay, capped at max_delay
                local next_delay=$((delay * 2))
                [[ $next_delay -gt $max_delay ]] && next_delay=$max_delay
                retry_delays[$job_id]=$next_delay
            else
                # ❌ Job failed permanently after max retries
                echo "❌ Job $job_id failed after $max_retries attempts"
                echo "Error: $stderr" > "failed_$job_id.txt"  # 💾 Save error details
                
                # 🧹 Clean up retry tracking
                unset "retry_counts[$job_id]"
                unset "retry_delays[$job_id]"
            fi
        fi
    }
    
    # 📞 Register retry handler with the worker
    async_register_callback retry_worker retry_handler
    
    # 🚀 Submit jobs that might fail
    # Store original prompts for retry attempts
    typeset -A original_prompts                # 📝 Store original prompts for retries
    local -a prompts=(
        "Create a complex animation system"                             # 🎬 Complex UI animation system
        "Generate a distributed system architecture"                   # 🏗️ Scalable system design
        "Build a machine learning pipeline"                           # 🤖 ML data processing pipeline
        "Design a real-time collaboration feature"                    # 👥 Real-time collaborative editing
        "Implement a blockchain smart contract"                       # ⛓️ Decentralized contract logic
    )
    
    # 📤 Submit initial jobs
    for i in {0..4}; do
        original_prompts[$i]="${prompts[$i]}"   # 💾 Store original prompt for retries
        async_job retry_worker claude-code "${prompts[$i]}" "job_$i"
    done
    
    echo "📤 Submitted ${#prompts[@]} jobs with retry capability"
    
    # ⏳ Wait for all jobs to complete or fail permanently
    # Continue until no jobs are being retried and no background retry processes are running
    while [[ ${#retry_counts[@]} -gt 0 || \
            $(jobs -r | wc -l) -gt 0 ]]; do
        sleep 1                               # ⏱️ Check every second
    done
    
    # 🧹 Cleanup
    async_stop_worker retry_worker
    echo "✅ All jobs processed (with retries as needed)"
}

# Usage
async_with_retry
```

## 4. Parallel Pipeline with Dependencies

Create a pipeline where each stage depends on the previous one, but items within each stage run in parallel.

```bash
# 🔀 Parallel Pipeline with Dependencies Function
# This function creates a pipeline where each stage depends on the previous one
# Components within each stage run in parallel, but stages are sequential
parallel_pipeline() {
    local project_name="$1"                    # 📝 Name of the project being developed
    # 🔗 Array of pipeline stages in dependency order
    local -a stages=("design" "implement" "test" "document" "deploy")
    
    echo "🔀 Running parallel pipeline for $project_name..."
    
    # 💾 Store outputs from each stage
    # This allows later stages to reference outputs from previous stages
    typeset -A stage_outputs
    
    # 🔄 Process each stage sequentially
    # Each stage must complete before the next stage begins
    for stage_index in {0..4}; do
        local stage="${stages[$stage_index]}"    # 📝 Current stage name
        
        # 📊 Display stage header for clarity
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Stage $((stage_index + 1)): $stage"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # 🧩 Define components for each stage
        # Each stage has multiple components that can be developed in parallel
        local -a components
        case $stage in
            "design")                            # 🎨 Design phase components
                components=(
                    "UI mockups"                     # 🖼️ User interface designs
                    "Database schema"               # 🗄️ Data structure design
                    "API specification"             # 📋 API contract definition
                    "Architecture diagram"          # 🏗️ System architecture overview
                )
                ;;
            "implement")                         # 🔨 Implementation phase components
                components=(
                    "Frontend components"           # 🎨 User interface implementation
                    "Backend services"              # ⚙️ Server-side logic
                    "Database layer"                # 🗄️ Data access layer
                    "API endpoints"                 # 🔗 REST/GraphQL endpoints
                )
                ;;
            "test")                              # 🧪 Testing phase components
                components=(
                    "Unit tests"                    # 🔬 Component-level tests
                    "Integration tests"             # 🔗 Service integration tests
                    "E2E tests"                     # 🎭 End-to-end user flow tests
                    "Performance tests"             # ⚡ Load and performance tests
                )
                ;;
            "document")                          # 📚 Documentation phase components
                components=(
                    "API docs"                      # 📋 API reference documentation
                    "User guide"                    # 👥 End-user documentation
                    "Developer guide"               # 👨‍💻 Development documentation
                    "Deployment guide"              # 🚀 Operations documentation
                )
                ;;
            "deploy")                            # 🚀 Deployment phase components
                components=(
                    "CI/CD pipeline"                # 🔄 Automated deployment pipeline
                    "Infrastructure"                # 🏗️ Cloud infrastructure setup
                    "Monitoring"                    # 📊 Application monitoring
                    "Rollback plan"                 # 🔙 Deployment rollback procedures
                )
                ;;
        esac
        
        # 🏁 Start stage worker
        # Each stage gets its own worker to isolate processing
        async_start_worker "stage_${stage}_worker"
        
        # 📞 Stage callback function
        # This function processes completed components within the current stage
        stage_callback() {
            local job_name="$1"                 # 📝 Name of completed job
            local return_code="$2"              # 🔢 Exit code
            local stdout="$3"                   # 📄 Component output
            
            # 🏷️ Extract component name from job name
            local component="${job_name#component_}"
            echo "✅ Completed: $component"
            
            # 💾 Store output for next stage to reference
            # This enables dependency passing between pipeline stages
            stage_outputs["${stage}_${component}"]="$stdout"
        }
        
        # 📞 Register callback with stage worker
        async_register_callback "stage_${stage}_worker" stage_callback
        
        # 🚀 Submit all components for this stage in parallel
        # All components within a stage can be developed simultaneously
        for component in "${components[@]}"; do
            # 📝 Build prompt for this component
            local prompt="Create $component for $project_name"
            
            # 🔗 Add context from previous stage if available
            # This creates dependencies between pipeline stages
            if [[ $stage_index -gt 0 ]]; then
                local prev_stage="${stages[$((stage_index - 1))]}"  # 📋 Previous stage name
                prompt="$prompt. Based on previous stage outputs, enhance the $component"
            fi
            
            # 📤 Submit component job to stage worker
            async_job "stage_${stage}_worker" claude-code "$prompt" "component_$component"
        done
        
        # ⏳ Wait for all components in this stage to complete
        echo "⏳ Waiting for all $stage components to complete..."
        local stage_start=$(date +%s)            # ⏰ Record stage start time
        
        # 🔄 Wait with progress monitoring
        # Process results until all jobs in this stage complete
        while async_process_results "stage_${stage}_worker" 2>/dev/null; do
            sleep 0.5                           # ⏱️ Check every 500ms
        done
        
        # 📊 Calculate and report stage completion time
        local stage_duration=$(($(date +%s) - stage_start))
        echo "✅ Stage '$stage' completed in ${stage_duration}s"
        
        # 🧹 Cleanup stage worker
        async_stop_worker "stage_${stage}_worker"
        
        # ⏸️ Brief pause between stages
        # Allows system resources to stabilize between stages
        [[ $stage_index -lt 4 ]] && sleep 2
    done
    
    # 🎉 Pipeline completion summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Pipeline completed for $project_name!"
}

# Usage
parallel_pipeline "E-Commerce Platform"
```

## 5. Dynamic Queue Processing

Process a queue that can grow dynamically during execution.

```bash
# 📋 Dynamic Queue Processor Function
# This function processes a queue that can grow dynamically during execution
# New tasks can be added to the queue based on the output of completed tasks
dynamic_queue_processor() {
    local initial_queue_file="$1"               # 📄 File containing initial tasks
    local max_workers=4                        # 🔢 Maximum number of concurrent workers
    
    # 📊 Dynamic queue stored in memory
    # These variables maintain the state of the dynamic queue
    typeset -a task_queue                      # 📝 Array storing all tasks (initial + generated)
    typeset -i queue_index=0                   # 🔢 Index of next task to process
    typeset -i tasks_completed=0               # 🔢 Number of completed tasks
    typeset -i tasks_generated=0               # 🔢 Number of dynamically generated tasks
    
    # 📖 Load initial tasks from file
    # Read all tasks from the input file into the queue
    while IFS= read -r task; do
        [[ -n "$task" ]] && task_queue+=("$task")  # 📝 Add non-empty tasks to queue
    done < "$initial_queue_file"
    
    echo "📋 Starting dynamic queue processing..."
    echo "Initial queue size: ${#task_queue[@]}"
    
    # 🏁 Start workers for dynamic queue processing
    # Create multiple workers to process tasks concurrently
    for worker_id in {1..$max_workers}; do
        async_start_worker "queue_worker_$worker_id"
        
        # 🔄 Dynamic callback that can add new tasks
        # This callback processes completed tasks and can add new tasks to the queue
        dynamic_callback() {
            local job_name="$1"                 # 📝 Name of completed job
            local return_code="$2"              # 🔢 Exit code
            local stdout="$3"                   # 📄 Output from completed task
            
            ((tasks_completed++))               # 📈 Increment completion counter
            
            # 🔍 Parse output for new tasks
            # Look for lines starting with "GENERATE:" to identify new tasks
            while IFS= read -r line; do
                if [[ "$line" =~ ^GENERATE:(.+)$ ]]; then
                    local new_task="${BASH_REMATCH[1]}"  # 📝 Extract new task description
                    task_queue+=("$new_task")           # ➕ Add new task to queue
                    ((tasks_generated++))               # 📈 Increment generation counter
                    echo "🔄 New task added to queue: $new_task"
                fi
            done <<< "$stdout"
            
            # 📊 Display progress information
            echo "✅ Task completed ($tasks_completed total, queue size: $((${#task_queue[@]} - queue_index)))"
        }
        
        # 📞 Register dynamic callback with each worker
        async_register_callback "queue_worker_$worker_id" dynamic_callback
    done
    
    # 🔄 Process queue dynamically
    # Main processing loop that handles the growing queue
    local active_jobs=0                        # 🔢 Track number of currently running jobs
    
    # 🔄 Continue until queue is empty and no jobs are running
    # The queue can grow during processing, so we check both conditions
    while [[ $queue_index -lt ${#task_queue[@]} || $active_jobs -gt 0 ]]; do
        # 🎯 Distribute tasks to available workers
        # Try to assign tasks to each worker if they're available
        for worker_id in {1..$max_workers}; do
            if [[ $queue_index -lt ${#task_queue[@]} ]]; then
                local task="${task_queue[$queue_index]}"  # 📝 Get next task from queue
                
                # 🔍 Check if worker is available
                # Only assign new task if worker is not currently processing
                if ! async_job_is_running "queue_worker_$worker_id" 2>/dev/null; then
                    # 🚀 Submit task to available worker
                    async_job "queue_worker_$worker_id" claude-code \
                        "Process task: $task. If this generates sub-tasks, prefix each with 'GENERATE:'" \
                        "task_$queue_index"
                    
                    ((queue_index++))           # 📈 Move to next task in queue
                    ((active_jobs++))           # 📈 Increment active job counter
                fi
            fi
        done
        
        # 🔄 Process results and update active job count
        # Check all workers for completed jobs
        local jobs_before=$active_jobs
        for worker_id in {1..$max_workers}; do
            async_process_results "queue_worker_$worker_id" 2>/dev/null
        done
        
        # 📊 Update active jobs count
        # Calculate how many jobs are still running
        active_jobs=$((queue_index - tasks_completed))
        
        # ⏱️ Brief sleep to prevent CPU spinning
        sleep 0.1
        
        # 📊 Status update every 10 tasks
        # Provide periodic progress updates to user
        if [[ $((tasks_completed % 10)) -eq 0 && $tasks_completed -gt 0 ]]; then
            echo "📊 Status: Completed: $tasks_completed, Generated: $tasks_generated, Remaining: $((${#task_queue[@]} - queue_index))"
        fi
    done
    
    # 🧹 Cleanup workers
    # Stop all workers now that queue processing is complete
    for worker_id in {1..$max_workers}; do
        async_stop_worker "queue_worker_$worker_id"
    done
    
    # 📊 Final completion summary
    echo "✅ Dynamic queue processing complete!"
    echo "📊 Final stats: Total processed: $tasks_completed, Dynamically generated: $tasks_generated"
}

# Usage
echo "Build user authentication system
Create admin panel
Design dashboard" > initial_tasks.txt

dynamic_queue_processor "initial_tasks.txt"
```

## 6. Chunked File Processing

Process large files in chunks with parallel processing.

```bash
chunked_file_processor() {
    local input_file="$1"
    local chunk_size=1000  # lines per chunk
    local max_parallel=5
    local output_dir="./chunks_processed"
    
    mkdir -p "$output_dir"
    
    # Split file into chunks
    local total_lines=$(wc -l < "$input_file")
    local num_chunks=$(( (total_lines + chunk_size - 1) / chunk_size ))
    
    echo "📄 Processing file with $total_lines lines in $num_chunks chunks..."
    
    # Create chunks
    local chunk_num=0
    local line_num=0
    local chunk_file=""
    
    while IFS= read -r line; do
        if [[ $((line_num % chunk_size)) -eq 0 ]]; then
            [[ -n "$chunk_file" ]] && exec 3>&-  # Close previous chunk
            chunk_file="$output_dir/chunk_$chunk_num.tmp"
            exec 3>"$chunk_file"
            ((chunk_num++))
        fi
        echo "$line" >&3
        ((line_num++))
    done < "$input_file"
    [[ -n "$chunk_file" ]] && exec 3>&-  # Close last chunk
    
    # Process chunks in parallel batches
    echo "🔄 Processing chunks in batches of $max_parallel..."
    
    # Start worker
    async_start_worker chunk_worker
    
    # Chunk processing callback
    chunk_callback() {
        local job_name="$1"
        local return_code="$2"
        local stdout="$3"
        
        local chunk_id="${job_name#chunk_}"
        local output_file="$output_dir/processed_$chunk_id.txt"
        
        echo "$stdout" > "$output_file"
        echo "✅ Chunk $chunk_id processed"
        
        # Remove temporary chunk file
        rm -f "$output_dir/chunk_$chunk_id.tmp"
    }
    
    async_register_callback chunk_worker chunk_callback
    
    # Process chunks with controlled parallelism
    local chunks_submitted=0
    local chunks_completed=0
    
    while [[ $chunks_submitted -lt $chunk_num || $chunks_completed -lt $chunk_num ]]; do
        # Submit new chunks if under limit
        local active_chunks=$((chunks_submitted - chunks_completed))
        
        while [[ $active_chunks -lt $max_parallel && $chunks_submitted -lt $chunk_num ]]; do
            local chunk_content=$(cat "$output_dir/chunk_$chunks_submitted.tmp")
            
            async_job chunk_worker claude-code \
                "Process this data chunk: $chunk_content" \
                "chunk_$chunks_submitted"
            
            ((chunks_submitted++))
            ((active_chunks++))
        done
        
        # Process results
        local before=$chunks_completed
        while async_process_results chunk_worker 2>/dev/null; do
            ((chunks_completed++))
        done
        
        # Progress update
        if [[ $chunks_completed -gt $before ]]; then
            local progress=$((chunks_completed * 100 / chunk_num))
            echo "[$progress%] Processed $chunks_completed/$chunk_num chunks"
        fi
        
        sleep 0.1
    done
    
    # Merge results
    echo "🔀 Merging processed chunks..."
    cat "$output_dir"/processed_*.txt > "$output_dir/final_result.txt"
    
    # Cleanup
    async_stop_worker chunk_worker
    rm -f "$output_dir"/chunk_*.tmp
    rm -f "$output_dir"/processed_*.txt
    
    echo "✅ File processing complete! Result: $output_dir/final_result.txt"
}

# Usage
# Create a large test file
seq 1 5000 | while read n; do
    echo "Line $n: Process this data entry"
done > large_file.txt

chunked_file_processor "large_file.txt"
```

## 7. Progressive Enhancement Loop

Iteratively enhance code with multiple passes.

```bash
progressive_enhancement() {
    local base_code="$1"
    local enhancement_passes=5
    local parallel_enhancements=3
    
    echo "🔧 Starting progressive enhancement..."
    
    # Store code versions
    local current_version="$base_code"
    local version_history=()
    version_history+=("$current_version")
    
    # Enhancement strategies
    local -a strategies=(
        "performance optimization"
        "error handling"
        "code documentation"
        "security hardening"
        "test coverage"
        "accessibility"
        "type safety"
        "logging and monitoring"
    )
    
    # Process enhancement passes
    for pass in $(seq 1 $enhancement_passes); do
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Enhancement Pass $pass/$enhancement_passes"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # Select random strategies for this pass
        local -a selected_strategies=()
        local -a available_strategies=("${strategies[@]}")
        
        for i in $(seq 1 $parallel_enhancements); do
            local rand_index=$((RANDOM % ${#available_strategies[@]}))
            selected_strategies+=("${available_strategies[$rand_index]}")
            unset 'available_strategies[$rand_index]'
            available_strategies=("${available_strategies[@]}")  # Reindex
        done
        
        # Start pass worker
        async_start_worker "pass_${pass}_worker"
        
        # Enhancement results storage
        typeset -A enhancement_results
        
        # Enhancement callback
        enhancement_callback() {
            local job_name="$1"
            local return_code="$2"
            local stdout="$3"
            
            local strategy="${job_name#enhance_}"
            enhancement_results[$strategy]="$stdout"
            echo "✅ Applied: $strategy"
        }
        
        async_register_callback "pass_${pass}_worker" enhancement_callback
        
        # Submit parallel enhancements
        for strategy in "${selected_strategies[@]}"; do
            local prompt="Enhance this code with focus on $strategy: $current_version"
            async_job "pass_${pass}_worker" claude-code "$prompt" "enhance_$strategy"
        done
        
        # Wait for enhancements
        while async_process_results "pass_${pass}_worker" 2>/dev/null; do
            sleep 0.1
        done
        
        # Merge enhancements
        echo "🔀 Merging enhancements..."
        local merged_prompt="Merge these enhanced versions intelligently:"
        for strategy in "${selected_strategies[@]}"; do
            merged_prompt="$merged_prompt\n\n--- $strategy version ---\n${enhancement_results[$strategy]}"
        done
        
        # Get merged version
        current_version=$(claude-code "$merged_prompt")
        version_history+=("$current_version")
        
        # Cleanup
        async_stop_worker "pass_${pass}_worker"
        
        echo "✅ Pass $pass complete"
        
        # Save intermediate version
        echo "$current_version" > "enhanced_v${pass}.txt"
    done
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Progressive enhancement complete!"
    echo "📁 Final version saved to: enhanced_v${enhancement_passes}.txt"
}

# Usage
base_code='function calculateTotal(items) {
    let total = 0;
    for (let item of items) {
        total += item.price;
    }
    return total;
}'

progressive_enhancement "$base_code"
```

## 8. Conditional Batch Generation

Generate code conditionally based on previous results.

```bash
conditional_batch_generator() {
    local project_type="$1"  # "web", "mobile", "desktop"
    local feature_flags="$2"  # comma-separated features
    
    echo "🎯 Conditional batch generation for $project_type project..."
    
    # Parse feature flags
    IFS=',' read -ra features <<< "$feature_flags"
    
    # Decision tree for generation
    typeset -A generation_queue
    typeset -A completed_components
    
    # Phase 1: Core components (always needed)
    echo "Phase 1: Generating core components..."
    
    async_start_worker core_worker
    
    core_callback() {
        local job_name="$1"
        local return_code="$2"
        local stdout="$3"
        
        local component="${job_name#core_}"
        completed_components[$component]="done"
        
        # Analyze output to determine what else needs to be generated
        if [[ "$stdout" =~ "requires authentication" ]]; then
            generation_queue["auth"]="needed"
        fi
        if [[ "$stdout" =~ "database required" ]]; then
            generation_queue["database"]="needed"
        fi
        if [[ "$stdout" =~ "api endpoints" ]]; then
            generation_queue["api"]="needed"
        fi
        
        echo "✅ Core component completed: $component"
    }
    
    async_register_callback core_worker core_callback
    
    # Submit core components
    local -a core_components=("main_app" "config" "router")
    for component in "${core_components[@]}"; do
        async_job core_worker claude-code \
            "Create $component for $project_type project" \
            "core_$component"
    done
    
    # Wait for core components
    while async_process_results core_worker 2>/dev/null; do
        sleep 0.1
    done
    async_stop_worker core_worker
    
    # Phase 2: Conditional components based on analysis
    if [[ ${#generation_queue[@]} -gt 0 ]]; then
        echo "Phase 2: Generating conditional components..."
        
        async_start_worker conditional_worker
        
        conditional_callback() {
            local job_name="$1"
            local stdout="$3"
            
            local component="${job_name#cond_}"
            
            # Further conditional generation based on results
            case $component in
                "auth")
                    if [[ "$stdout" =~ "OAuth" ]]; then
                        generation_queue["oauth_providers"]="needed"
                    fi
                    ;;
                "database")
                    if [[ "$stdout" =~ "migrations" ]]; then
                        generation_queue["migrations"]="needed"
                    fi
                    ;;
            esac
            
            echo "✅ Conditional component completed: $component"
        }
        
        async_register_callback conditional_worker conditional_callback
        
        # Submit conditional components
        for component in "${!generation_queue[@]}"; do
            async_job conditional_worker claude-code \
                "Create $component based on previous requirements" \
                "cond_$component"
        done
        
        # Wait and clear queue
        while async_process_results conditional_worker 2>/dev/null; do
            sleep 0.1
        done
        async_stop_worker conditional_worker
    fi
    
    # Phase 3: Feature-specific components
    if [[ ${#features[@]} -gt 0 ]]; then
        echo "Phase 3: Generating feature-specific components..."
        
        async_start_worker feature_worker
        
        # Generate in batches of 3
        local feature_index=0
        while [[ $feature_index -lt ${#features[@]} ]]; do
            local batch_count=0
            
            while [[ $batch_count -lt 3 && $feature_index -lt ${#features[@]} ]]; do
                local feature="${features[$feature_index]}"
                
                # Skip if already generated
                if [[ -z "${completed_components[$feature]}" ]]; then
                    async_job feature_worker claude-code \
                        "Create $feature feature for $project_type" \
                        "feat_$feature"
                    ((batch_count++))
                fi
                
                ((feature_index++))
            done
            
            # Wait for batch
            sleep 1
            while async_process_results feature_worker 2>/dev/null; do
                sleep 0.1
            done
        done
        
        async_stop_worker feature_worker
    fi
    
    echo "✅ Conditional batch generation complete!"
}

# Usage
conditional_batch_generator "web" "payment,analytics,chat,notifications"
```

## 9. Round-Robin Task Distribution

Distribute tasks across multiple queues in round-robin fashion.

```bash
round_robin_distributor() {
    local num_queues=4
    local -a task_files=("$@")
    
    echo "🔄 Round-robin task distribution across $num_queues queues..."
    
    # Initialize queues
    typeset -a queue_tasks
    for i in $(seq 0 $((num_queues - 1))); do
        queue_tasks[$i]=""
    done
    
    # Read all tasks and distribute round-robin
    local task_count=0
    for file in "${task_files[@]}"; do
        while IFS= read -r task; do
            if [[ -n "$task" ]]; then
                local queue_index=$((task_count % num_queues))
                queue_tasks[$queue_index]+="$task|"
                ((task_count++))
            fi
        done < "$file"
    done
    
    echo "📊 Distributed $task_count tasks across $num_queues queues"
    
    # Process queues in parallel
    for queue_id in $(seq 0 $((num_queues - 1))); do
        # Start queue worker
        async_start_worker "queue_${queue_id}_worker"
        
        # Queue-specific callback
        queue_callback() {
            local job_name="$1"
            local return_code="$2"
            local stdout="$3"
            local exec_time="$4"
            
            local task_id="${job_name#task_}"
            echo "[Queue $queue_id] ✅ Task $task_id completed in ${exec_time}s"
            
            # Save output
            mkdir -p "./queue_${queue_id}_output"
            echo "$stdout" > "./queue_${queue_id}_output/task_${task_id}.txt"
        }
        
        async_register_callback "queue_${queue_id}_worker" queue_callback
        
        # Submit tasks for this queue
        IFS='|' read -ra tasks <<< "${queue_tasks[$queue_id]}"
        local task_id=0
        
        for task in "${tasks[@]}"; do
            if [[ -n "$task" ]]; then
                async_job "queue_${queue_id}_worker" claude-code "$task" "task_$task_id"
                ((task_id++))
            fi
        done
        
        echo "📤 Queue $queue_id: Processing ${#tasks[@]} tasks"
    done
    
    # Monitor progress
    local completed=0
    local last_update=0
    
    while [[ $completed -lt $task_count ]]; do
        # Process results from all queues
        for queue_id in $(seq 0 $((num_queues - 1))); do
            while async_process_results "queue_${queue_id}_worker" 2>/dev/null; do
                ((completed++))
            done
        done
        
        # Progress update every 5 completions
        if [[ $((completed - last_update)) -ge 5 ]]; then
            local progress=$((completed * 100 / task_count))
            echo "[$progress%] Completed $completed/$task_count tasks"
            last_update=$completed
        fi
        
        sleep 0.1
    done
    
    # Cleanup
    for queue_id in $(seq 0 $((num_queues - 1))); do
        async_stop_worker "queue_${queue_id}_worker"
    done
    
    echo "✅ All tasks completed!"
    
    # Show queue statistics
    echo "📊 Queue Statistics:"
    for queue_id in $(seq 0 $((num_queues - 1))); do
        local queue_files=$(ls -1 "./queue_${queue_id}_output" 2>/dev/null | wc -l)
        echo "   Queue $queue_id: $queue_files tasks processed"
    done
}

# Usage
# Create multiple task files
echo "Create login component
Build user profile page
Design settings panel" > ui_tasks.txt

echo "Implement REST API
Create GraphQL schema
Build WebSocket server" > backend_tasks.txt

echo "Write unit tests
Create integration tests
Generate test data" > test_tasks.txt

round_robin_distributor ui_tasks.txt backend_tasks.txt test_tasks.txt
```

## 10. Adaptive Batch Sizing

Dynamically adjust batch size based on system performance.

```bash
adaptive_batch_processor() {
    local total_tasks=100
    local initial_batch_size=5
    local min_batch_size=1
    local max_batch_size=20
    local target_completion_time=30  # seconds per batch
    
    echo "📈 Adaptive batch processing with dynamic sizing..."
    
    # Performance tracking
    local current_batch_size=$initial_batch_size
    local batch_number=0
    local tasks_completed=0
    typeset -a batch_times
    
    # Create tasks
    local -a all_tasks=()
    for i in $(seq 1 $total_tasks); do
        all_tasks+=("Generate component $i with full implementation")
    done
    
    # Start worker
    async_start_worker adaptive_worker
    
    # Batch completion tracking
    typeset -A batch_start_times
    typeset -A batch_task_counts
    
    adaptive_callback() {
        local job_name="$1"
        local return_code="$2"
        local stdout="$3"
        
        ((tasks_completed++))
        
        local batch_id="${job_name%%_*}"
        batch_id="${batch_id#batch}"
        
        # Check if batch is complete
        local batch_count=${batch_task_counts[$batch_id]}
        local batch_completed=$(grep -c "^batch${batch_id}_" <<< "$job_name")
        
        echo "✅ Task completed (Batch $batch_id: $tasks_completed/$total_tasks total)"
    }
    
    async_register_callback adaptive_worker adaptive_callback
    
    # Process with adaptive batching
    local task_index=0
    
    while [[ $task_index -lt $total_tasks ]]; do
        ((batch_number++))
        
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Batch $batch_number (size: $current_batch_size)"
        
        # Record batch start time
        local batch_start=$(date +%s)
        batch_start_times[$batch_number]=$batch_start
        
        # Submit batch
        local batch_task_count=0
        local batch_end=$((task_index + current_batch_size))
        [[ $batch_end -gt $total_tasks ]] && batch_end=$total_tasks
        
        while [[ $task_index -lt $batch_end ]]; do
            local task="${all_tasks[$task_index]}"
            async_job adaptive_worker claude-code "$task" "batch${batch_number}_task${task_index}"
            ((task_index++))
            ((batch_task_count++))
        done
        
        batch_task_counts[$batch_number]=$batch_task_count
        echo "📤 Submitted $batch_task_count tasks"
        
        # Wait for batch completion
        local batch_tasks_completed=0
        while [[ $batch_tasks_completed -lt $batch_task_count ]]; do
            local before=$tasks_completed
            while async_process_results adaptive_worker 2>/dev/null; do
                :
            done
            batch_tasks_completed=$((tasks_completed - (task_index - batch_task_count)))
            
            # Show progress
            if [[ $tasks_completed -gt $before ]]; then
                local batch_progress=$((batch_tasks_completed * 100 / batch_task_count))
                echo -ne "\r[Batch Progress: $batch_progress%] "
            fi
            
            sleep 0.1
        done
        echo ""  # New line after progress
        
        # Calculate batch completion time
        local batch_end_time=$(date +%s)
        local batch_duration=$((batch_end_time - batch_start))
        batch_times+=($batch_duration)
        
        echo "⏱️ Batch completed in ${batch_duration}s"
        
        # Adapt batch size based on performance
        if [[ $batch_duration -lt $((target_completion_time - 5)) ]]; then
            # Too fast, increase batch size
            local new_size=$((current_batch_size + 2))
            [[ $new_size -gt $max_batch_size ]] && new_size=$max_batch_size
            
            if [[ $new_size -ne $current_batch_size ]]; then
                echo "📈 Increasing batch size: $current_batch_size → $new_size"
                current_batch_size=$new_size
            fi
        elif [[ $batch_duration -gt $((target_completion_time + 5)) ]]; then
            # Too slow, decrease batch size
            local new_size=$((current_batch_size - 1))
            [[ $new_size -lt $min_batch_size ]] && new_size=$min_batch_size
            
            if [[ $new_size -ne $current_batch_size ]]; then
                echo "📉 Decreasing batch size: $current_batch_size → $new_size"
                current_batch_size=$new_size
            fi
        else
            echo "✅ Batch size optimal at $current_batch_size"
        fi
        
        # Brief pause between batches
        [[ $task_index -lt $total_tasks ]] && sleep 1
    done
    
    # Cleanup
    async_stop_worker adaptive_worker
    
    # Calculate statistics
    local total_time=0
    for time in "${batch_times[@]}"; do
        total_time=$((total_time + time))
    done
    
    local avg_batch_time=$((total_time / batch_number))
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Adaptive batch processing complete!"
    echo "📊 Statistics:"
    echo "   Total tasks: $total_tasks"
    echo "   Total batches: $batch_number"
    echo "   Average batch time: ${avg_batch_time}s"
    echo "   Final batch size: $current_batch_size"
    echo "   Total time: ${total_time}s"
}

# Usage
adaptive_batch_processor
```

## Best Practices for Async Loops

1. **Lock File Management**
   - Always use atomic operations (mkdir) for lock creation
   - Clean up locks on failure
   - Implement timeout mechanisms for stale locks

2. **Batch Size Optimization**
   - Start with conservative batch sizes
   - Monitor system resources
   - Adapt based on performance metrics

3. **Error Recovery**
   - Implement retry logic for failed tasks
   - Use exponential backoff for retries
   - Log failures for debugging

4. **Resource Management**
   - Limit concurrent operations
   - Implement rate limiting
   - Monitor memory usage

5. **Progress Tracking**
   - Provide clear progress indicators
   - Save intermediate results
   - Enable resume capability for long-running processes

6. **Sequential Naming**
   - Use atomic operations for claiming numbers
   - Handle race conditions gracefully
   - Provide fallback mechanisms

## Summary

These examples demonstrate various patterns for async loop processing:

- **Sequential naming with locks** for ordered output
- **Rate limiting** for API-friendly processing
- **Retry mechanisms** for reliability
- **Pipeline processing** for dependent tasks
- **Dynamic queues** for adaptive workloads
- **Chunked processing** for large data sets
- **Progressive enhancement** for iterative improvement
- **Conditional generation** for smart workflows
- **Round-robin distribution** for load balancing
- **Adaptive sizing** for performance optimization

Each pattern can be adapted and combined to create sophisticated async processing workflows tailored to specific needs.