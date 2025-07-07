#!/usr/bin/env zsh

# 🗄️ Database Module - Database Operations Functions
# 🎯 Part of Claude Functions Async Utility Library  
# 🔧 New naming convention: cc-db-<database>-<action>
#
# 📋 Available Functions:
#   • cc-db-mysql-insert     - Async MySQL batch inserts
#   • cc-db-mysql-select     - Async MySQL queries
#   • cc-db-postgres-insert  - Async PostgreSQL inserts  
#   • cc-db-postgres-select  - Async PostgreSQL queries
#   • cc-db-sqlite-backup    - Async SQLite backups
#   • cc-db-sqlite-select    - Async SQLite queries
#   • cc-db-help            - Show help for database functions

# ═══════════════════════════════════════════════════════════════════════════════
# 🗄️ DATABASE ASYNC FUNCTIONS - Powerful DB Operations! 💪
# ═══════════════════════════════════════════════════════════════════════════════

# 🔄 cc-db-mysql-insert - Insert data asynchronously with batch processing
# 🎯 Usage: cc-db-mysql-insert "database" "table" "file_with_data.txt"
# 📝 File format: Each line should be: field1,field2,field3
cc-db-mysql-insert() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🔄 cc-db-mysql-insert - Async MySQL batch inserts"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-db-mysql-insert <database> <table> <data_file>"
        echo ""
        echo "📝 Parameters:"
        echo "  database     🗄️ MySQL database name (required)"
        echo "  table        📋 Table name (required)"
        echo "  data_file    📄 File containing data to insert (required)"
        echo ""
        echo "📄 File Format:"
        echo "  Each line: field1,field2,field3"
        echo "  Empty lines are skipped"
        echo ""
        echo "📋 Examples:"
        echo "  echo \"john,doe,john@example.com\" > users.txt"
        echo "  echo \"jane,smith,jane@example.com\" >> users.txt"
        echo "  cc-db-mysql-insert \"mydb\" \"users\" \"users.txt\""
        echo ""
        echo "⚙️ Batch size controlled by CLAUDE_BATCH_SIZE (default: ${CLAUDE_BATCH_SIZE:-5})"
        return 0
    fi
    
    local database="$1"      # 🗄️ Database name
    local table="$2"         # 📋 Table name
    local data_file="$3"     # 📄 File containing data to insert
    
    if [[ -z "$database" || -z "$table" || -z "$data_file" ]]; then
        echo "❌ Usage: cc-db-mysql-insert <database> <table> <data_file>"
        echo "💡 Use 'cc-db-mysql-insert -h' for detailed help"
        return 1
    fi
    
    if [[ ! -f "$data_file" ]]; then
        echo "❌ Data file not found: $data_file"
        return 1
    fi
    
    echo "🚀 Starting async MySQL inserts for $table..."
    
    # 🔢 Process file in batches
    local batch_num=0
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue  # Skip empty lines
        
        ((batch_num++))
        
        # 🚀 Launch async insert
        run_claude_async "Generate MySQL INSERT statement for table '$table' with data: $line" &
        
        # 📊 Process in batches to avoid overwhelming the system
        if (( batch_num % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
            echo "⏸️ Waiting for batch to complete... ($batch_num records processed)"
            wait_for_claude_jobs
        fi
    done < "$data_file"
    
    # ⏳ Wait for any remaining jobs
    wait_for_claude_jobs
    echo "✅ Async MySQL inserts completed! Processed $batch_num records"
}

# 📊 cc-db-mysql-select - Run MySQL queries in parallel
# 🎯 Usage: cc-db-mysql-select "database" "queries_file.sql"
cc-db-mysql-select() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📊 cc-db-mysql-select - Async MySQL queries"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-db-mysql-select <database> <queries_file>"
        echo ""
        echo "📝 Parameters:"
        echo "  database      🗄️ MySQL database name (required)"
        echo "  queries_file  📄 File containing SQL queries (required)"
        echo ""
        echo "📄 File Format:"
        echo "  Each line: SQL SELECT statement"
        echo "  Comments (lines starting with --) are ignored"
        echo ""
        echo "📋 Examples:"
        echo "  echo \"SELECT * FROM users WHERE active = 1;\" > queries.sql"
        echo "  echo \"SELECT COUNT(*) FROM orders;\" >> queries.sql"
        echo "  cc-db-mysql-select \"mydb\" \"queries.sql\""
        return 0
    fi
    
    local database="$1"
    local queries_file="$2"
    
    if [[ -z "$database" || -z "$queries_file" ]]; then
        echo "❌ Usage: cc-db-mysql-select <database> <queries_file>"
        echo "💡 Use 'cc-db-mysql-select -h' for detailed help"
        return 1
    fi
    
    if [[ ! -f "$queries_file" ]]; then
        echo "❌ Queries file not found: $queries_file"
        return 1
    fi
    
    echo "🚀 Starting async MySQL queries for $database..."
    
    local query_num=0
    while IFS= read -r query; do
        [[ -z "$query" || "$query" =~ ^[[:space:]]*-- ]] && continue  # Skip empty lines and comments
        
        ((query_num++))
        echo "📊 Processing query $query_num: ${query:0:50}..."
        
        # 🚀 Launch async query
        run_claude_async "Execute this MySQL query on database '$database': $query" &
        
        # 📊 Process in batches
        if (( query_num % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
            echo "⏸️ Waiting for query batch to complete..."
            wait_for_claude_jobs
        fi
    done < "$queries_file"
    
    wait_for_claude_jobs
    echo "✅ Async MySQL queries completed! Processed $query_num queries"
}

# 🐘 cc-db-postgres-insert - PostgreSQL async inserts
# 🎯 Usage: cc-db-postgres-insert "database" "table" "data_file.txt"
cc-db-postgres-insert() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🐘 cc-db-postgres-insert - Async PostgreSQL batch inserts"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-db-postgres-insert <database> <table> <data_file>"
        echo ""
        echo "📝 Parameters:"
        echo "  database     🗄️ PostgreSQL database name (required)"
        echo "  table        📋 Table name (required)"  
        echo "  data_file    📄 File containing data to insert (required)"
        echo ""
        echo "📄 File Format:"
        echo "  Each line: field1,field2,field3"
        echo "  Empty lines are skipped"
        echo ""
        echo "📋 Examples:"
        echo "  echo \"john,doe,john@example.com\" > users.txt"
        echo "  cc-db-postgres-insert \"mydb\" \"users\" \"users.txt\""
        return 0
    fi
    
    local database="$1"
    local table="$2" 
    local data_file="$3"
    
    if [[ -z "$database" || -z "$table" || -z "$data_file" ]]; then
        echo "❌ Usage: cc-db-postgres-insert <database> <table> <data_file>"
        echo "💡 Use 'cc-db-postgres-insert -h' for detailed help"
        return 1
    fi
    
    if [[ ! -f "$data_file" ]]; then
        echo "❌ Data file not found: $data_file"
        return 1
    fi
    
    echo "🐘 Starting async PostgreSQL inserts for $table..."
    
    local batch_num=0
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        
        ((batch_num++))
        
        # 🚀 Launch async insert
        run_claude_async "Generate PostgreSQL INSERT statement for table '$table' with data: $line" &
        
        if (( batch_num % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
            echo "⏸️ Waiting for PostgreSQL batch to complete... ($batch_num records)"
            wait_for_claude_jobs
        fi
    done < "$data_file"
    
    wait_for_claude_jobs
    echo "✅ Async PostgreSQL inserts completed! Processed $batch_num records"
}

# 📊 cc-db-postgres-select - PostgreSQL async queries
# 🎯 Usage: cc-db-postgres-select "database" "queries_file.sql"  
cc-db-postgres-select() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📊 cc-db-postgres-select - Async PostgreSQL queries"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-db-postgres-select <database> <queries_file>"
        echo ""
        echo "📝 Parameters:"
        echo "  database      🗄️ PostgreSQL database name (required)"
        echo "  queries_file  📄 File containing SQL queries (required)"
        echo ""
        echo "📋 Examples:"
        echo "  echo \"SELECT * FROM users WHERE active = true;\" > queries.sql"
        echo "  cc-db-postgres-select \"mydb\" \"queries.sql\""
        return 0
    fi
    
    local database="$1"
    local queries_file="$2"
    
    if [[ -z "$database" || -z "$queries_file" ]]; then
        echo "❌ Usage: cc-db-postgres-select <database> <queries_file>"
        echo "💡 Use 'cc-db-postgres-select -h' for detailed help"
        return 1
    fi
    
    if [[ ! -f "$queries_file" ]]; then
        echo "❌ Queries file not found: $queries_file"
        return 1
    fi
    
    echo "🐘 Starting async PostgreSQL queries for $database..."
    
    local query_num=0
    while IFS= read -r query; do
        [[ -z "$query" || "$query" =~ ^[[:space:]]*-- ]] && continue
        
        ((query_num++))
        echo "📊 Processing PostgreSQL query $query_num..."
        
        run_claude_async "Execute this PostgreSQL query on database '$database': $query" &
        
        if (( query_num % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
            wait_for_claude_jobs
        fi
    done < "$queries_file"
    
    wait_for_claude_jobs
    echo "✅ Async PostgreSQL queries completed! Processed $query_num queries"
}

# 🗃️ cc-db-sqlite-backup - Async SQLite database backup
# 🎯 Usage: cc-db-sqlite-backup "database.db" [backup_dir]
cc-db-sqlite-backup() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🗃️ cc-db-sqlite-backup - Async SQLite database backup"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-db-sqlite-backup <database_file> [backup_dir]"
        echo ""
        echo "📝 Parameters:"
        echo "  database_file  🗄️ SQLite database file (required)"
        echo "  backup_dir     📁 Backup directory (optional, default: ./backups)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-db-sqlite-backup \"app.db\""
        echo "  cc-db-sqlite-backup \"data/users.db\" \"/backup/sqlite\""
        return 0
    fi
    
    local db_file="$1"
    local backup_dir="${2:-./backups}"
    
    if [[ -z "$db_file" ]]; then
        echo "❌ Usage: cc-db-sqlite-backup <database_file> [backup_dir]"
        echo "💡 Use 'cc-db-sqlite-backup -h' for detailed help"
        return 1
    fi
    
    if [[ ! -f "$db_file" ]]; then
        echo "❌ Database file not found: $db_file"
        return 1
    fi
    
    # 📁 Create backup directory
    mkdir -p "$backup_dir"
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$backup_dir/$(basename "$db_file" .db)_backup_$timestamp.db"
    
    echo "🗃️ Starting async SQLite backup..."
    echo "📄 Source: $db_file"
    echo "💾 Backup: $backup_file"
    
    # 🚀 Launch async backup
    run_claude_async "Create SQLite backup script to copy '$db_file' to '$backup_file' with verification"
    
    echo "✅ SQLite backup initiated!"
}

# 📊 cc-db-sqlite-select - SQLite async queries
# 🎯 Usage: cc-db-sqlite-select "database.db" "queries_file.sql"
cc-db-sqlite-select() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "📊 cc-db-sqlite-select - Async SQLite queries"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-db-sqlite-select <database_file> <queries_file>"
        echo ""
        echo "📝 Parameters:"
        echo "  database_file  🗄️ SQLite database file (required)"
        echo "  queries_file   📄 File containing SQL queries (required)"
        echo ""
        echo "📋 Examples:"
        echo "  echo \"SELECT * FROM users;\" > queries.sql"
        echo "  cc-db-sqlite-select \"app.db\" \"queries.sql\""
        return 0
    fi
    
    local db_file="$1"
    local queries_file="$2"
    
    if [[ -z "$db_file" || -z "$queries_file" ]]; then
        echo "❌ Usage: cc-db-sqlite-select <database_file> <queries_file>"
        echo "💡 Use 'cc-db-sqlite-select -h' for detailed help"
        return 1
    fi
    
    if [[ ! -f "$db_file" ]]; then
        echo "❌ Database file not found: $db_file"
        return 1
    fi
    
    if [[ ! -f "$queries_file" ]]; then
        echo "❌ Queries file not found: $queries_file"
        return 1
    fi
    
    echo "🗃️ Starting async SQLite queries for $db_file..."
    
    local query_num=0
    while IFS= read -r query; do
        [[ -z "$query" || "$query" =~ ^[[:space:]]*-- ]] && continue
        
        ((query_num++))
        echo "📊 Processing SQLite query $query_num..."
        
        run_claude_async "Execute this SQLite query on database '$db_file': $query" &
        
        if (( query_num % ${CLAUDE_BATCH_SIZE:-5} == 0 )); then
            wait_for_claude_jobs
        fi
    done < "$queries_file"
    
    wait_for_claude_jobs
    echo "✅ Async SQLite queries completed! Processed $query_num queries"
}

# 🆘 cc-db-help - Show help for all database functions
# 🎯 Usage: cc-db-help [function_name]
cc-db-help() {
    local function_name="$1"
    
    if [[ -n "$function_name" ]]; then
        # 📖 Try to call the specific function with -h flag
        if "$function_name" -h 2>/dev/null; then
            return 0
        else
            echo "❌ Function not found: $function_name"
            echo "💡 Available database functions:"
            echo "   MySQL: cc-db-mysql-insert, cc-db-mysql-select"
            echo "   PostgreSQL: cc-db-postgres-insert, cc-db-postgres-select"  
            echo "   SQLite: cc-db-sqlite-backup, cc-db-sqlite-select"
            return 1
        fi
    else
        echo "🗄️ Claude Database Functions Help"
        echo "════════════════════════════════════════"
        echo ""
        echo "🚀 Quick Start:"
        echo "  echo \"john,doe,john@example.com\" > users.txt"
        echo "  cc-db-mysql-insert \"mydb\" \"users\" \"users.txt\""
        echo ""
        echo "📚 Available Functions:"
        echo "  🔄 MySQL:"
        echo "    • cc-db-mysql-insert   - Batch inserts"
        echo "    • cc-db-mysql-select   - Async queries"
        echo ""
        echo "  🐘 PostgreSQL:"
        echo "    • cc-db-postgres-insert - Batch inserts"
        echo "    • cc-db-postgres-select - Async queries"
        echo ""
        echo "  🗃️ SQLite:"
        echo "    • cc-db-sqlite-backup  - Database backup"
        echo "    • cc-db-sqlite-select  - Async queries"
        echo ""
        echo "💡 Use 'cc-db-help <function_name>' or '<function_name> -h' for specific help"
    fi
}

# 🎉 Database module loaded message
echo "🗄️ Database module loaded! (cc-db-*)"