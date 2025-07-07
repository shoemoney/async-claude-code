# 🚀 Basic Usage - Simple Examples for Vibe Coders

> **Learn Claude Code Async Runner with copy-paste examples! No complex theory, just working code.** ✨

## 🎯 What This Guide Is

This is for **vibe coders** who want to:
- 🔥 Copy and paste working examples
- ⚡ Get shit done fast 
- 🚀 See immediate results
- 💡 Learn by doing, not reading theory

**Each example works out of the box!** Just copy, paste, and watch the magic happen! ✨

---

## 🛠️ Setup (One Time Only)

```bash
# 📥 Install the dependency
git clone https://github.com/mafredri/zsh-async ~/.zsh-async

# 🔗 Load the async runner AND utility functions (add to ~/.zshrc)
# 🚀 ONE-LINE PERFORMANCE BOOST!
source /path/to/optimize-claude-performance.zsh

# 🎯 Optional: Enable smart autocompletion
source /path/to/autocomplete-claude-optimized.zsh

# 🧪 Test it works
run_claude_async "echo 'Hello World'"

# 💎 Test the new utility functions  
cc-cache-set "test" "Hello Functions!" 300
cc-cache-get "test"
```

---

## 🔥 Section 1: Basic Parallel Jobs (The Good Stuff)

### 1. **Generate 3 Components at Once** 🏎️
```bash
# Instead of waiting 6 minutes, wait 2 minutes!
run_claude_parallel \
    "Create a Python function to validate emails" \
    "Write a JavaScript function to format dates" \
    "Generate a SQL query to find top customers"
```

### 2. **Build a Complete API in Parallel** 🌐
```bash
run_claude_parallel \
    "Create Express.js routes for user authentication" \
    "Write middleware for JWT token validation" \
    "Create database models for users and sessions" \
    "Generate API documentation for auth endpoints"
```

### 3. **Frontend Components Speedrun** ⚡
```bash
run_claude_parallel \
    "Create React login component with form validation" \
    "Write CSS for responsive navigation bar" \
    "Build JavaScript shopping cart functionality" \
    "Generate TypeScript interfaces for API responses"
```

### 4. **Database Everything** 🗄️
```bash
run_claude_parallel \
    "Create PostgreSQL schema for blog posts" \
    "Write MySQL migration for user tables" \
    "Generate Redis caching functions" \
    "Create SQLite backup script"
```

### 5. **DevOps Parallel Setup** 🚀
```bash
run_claude_parallel \
    "Create Dockerfile for Node.js app" \
    "Write docker-compose.yml with PostgreSQL" \
    "Generate Kubernetes deployment YAML" \
    "Create CI/CD pipeline with GitHub Actions"
```

---

## 📁 Section 2: Batch Processing (Handle Big Lists)

### 6. **Process a File of Tasks** 📋
```bash
# Create your task list
cat > tasks.txt << 'EOF'
Create a Python web scraper
Write a React todo component  
Generate REST API endpoints
Build a CSS grid layout
Create unit tests for calculator
EOF

# Process all at once!
claude_batch_process tasks.txt ./generated/
```

### 7. **Comment All Your Markdown Files** 💬
```bash
# Your exact example - comment all .md files and commit!
for file in $(ls *.md); do
    run_claude_async "Add detailed comments to this markdown file and explain each section: $(cat $file)"
done

wait_for_claude_jobs
git add *.md
git commit -m "Added detailed comments to all markdown files"
```

### 8. **Add Tests to All Your Python Files** 🧪
```bash
for file in $(find . -name "*.py"); do
    run_claude_async "Create comprehensive unit tests for this Python file: $(cat $file)"
done
```

### 9. **Document All JavaScript Functions** 📝
```bash
for file in $(find . -name "*.js"); do
    run_claude_async "Add JSDoc comments to every function in this file: $(cat $file)"
done
```

### 10. **Convert All CSS to Sass** 🎨
```bash
for file in $(find . -name "*.css"); do
    run_claude_async "Convert this CSS to Sass with variables and mixins: $(cat $file)"
done
```

---

## 🎯 Section 3: File Management Magic

### 11. **Backup and Improve All Config Files** ⚙️
```bash
for config in $(find . -name "*.config.js" -o -name "*.json"); do
    # Backup first
    cp "$config" "$config.backup"
    
    # Improve it
    run_claude_async "Optimize this config file with best practices and comments: $(cat $config)"
done
```

### 12. **Generate README for Every Directory** 📚
```bash
for dir in */; do
    run_claude_async "Create a comprehensive README.md for this directory based on its contents: $(ls -la $dir)"
done
```

### 13. **Add Error Handling to All Scripts** 🛡️
```bash
for script in $(find . -name "*.sh"); do
    run_claude_async "Add comprehensive error handling and logging to this bash script: $(cat $script)"
done
```

### 14. **Create Dockerfiles for All Projects** 🐳
```bash
for dir in */; do
    if [[ -f "$dir/package.json" ]]; then
        run_claude_async "Create an optimized Dockerfile for this Node.js project: $(cat $dir/package.json)"
    elif [[ -f "$dir/requirements.txt" ]]; then
        run_claude_async "Create an optimized Dockerfile for this Python project: $(cat $dir/requirements.txt)"
    fi
done
```

### 15. **Security Audit Everything** 🔒
```bash
for file in $(find . -name "*.js" -o -name "*.py" -o -name "*.php"); do
    run_claude_async "Perform security audit and suggest fixes for this file: $(cat $file)"
done
```

---

## 🚀 Section 4: Quick Development Workflows

### 16. **Full Stack App Generator** 🏗️
```bash
# Generate entire app structure in parallel
run_claude_parallel \
    "Create Express.js server with authentication routes" \
    "Build React frontend with login and dashboard" \
    "Generate PostgreSQL database schema" \
    "Create Docker setup for the full stack" \
    "Write comprehensive tests for all components"
```

### 17. **API Documentation Speedrun** 📖
```bash
run_claude_parallel \
    "Generate OpenAPI/Swagger spec for user endpoints" \
    "Create Postman collection for all API routes" \
    "Write cURL examples for each endpoint" \
    "Generate API client code in Python and JavaScript"
```

### 18. **Performance Optimization Blitz** ⚡
```bash
run_claude_parallel \
    "Optimize this JavaScript for performance: $(cat app.js)" \
    "Add caching to this Express API: $(cat server.js)" \
    "Optimize these SQL queries: $(cat queries.sql)" \
    "Minify and compress these CSS files: $(cat styles.css)"
```

### 19. **Testing Everything Simultaneously** 🧪
```bash
run_claude_parallel \
    "Create unit tests with Jest for React components" \
    "Write integration tests for API endpoints" \
    "Generate E2E tests with Cypress" \
    "Create performance tests with K6" \
    "Add accessibility tests with axe-core"
```

### 20. **Migration Helper** 🔄
```bash
run_claude_parallel \
    "Convert this jQuery to vanilla JavaScript: $(cat old-script.js)" \
    "Migrate this class component to React hooks: $(cat Component.js)" \
    "Convert this REST API to GraphQL: $(cat routes.js)" \
    "Upgrade this webpack config to latest version: $(cat webpack.config.js)"
```

---

## 🛠️ Section 5: Monitoring and Status

### 21. **Check What's Running** 👀
```bash
# See all your parallel jobs
claude_job_status

# Wait for everything to finish
wait_for_claude_jobs

# Stop everything if needed
stop_claude_jobs
```

### 22. **Smart Waiting with Timeout** ⏰
```bash
# Start some big jobs
run_claude_parallel \
    "Create complete e-commerce backend" \
    "Build responsive frontend with animations" \
    "Generate comprehensive documentation"

# Wait max 10 minutes, then give up
if wait_for_claude_jobs 600; then
    echo "✅ All done!"
else
    echo "⏰ Timed out, but check what completed"
fi
```

### 23. **Process Jobs in Waves** 🌊
```bash
# Wave 1: Backend
run_claude_parallel \
    "Create database schema" \
    "Build API routes" \
    "Add authentication"

wait_for_claude_jobs

# Wave 2: Frontend (depends on Wave 1)
run_claude_parallel \
    "Create React components" \
    "Build dashboard UI" \
    "Add user management"
```

---

## 🎨 Section 6: Creative and Content

### 24. **Generate Multiple Logo Concepts** 🎭
```bash
run_claude_parallel \
    "Create SVG logo concept 1: minimalist tech company" \
    "Create SVG logo concept 2: playful startup with colors" \
    "Create SVG logo concept 3: professional corporate style" \
    "Create SVG logo concept 4: modern geometric design"
```

### 25. **Content Creation Speedrun** ✍️
```bash
run_claude_parallel \
    "Write engaging blog post about AI development" \
    "Create social media posts for tech company" \
    "Generate product descriptions for e-commerce" \
    "Write technical documentation for API"
```

### 26. **Multi-Language Code Generation** 🌍
```bash
# Same algorithm, different languages
run_claude_parallel \
    "Implement binary search in Python with comments" \
    "Implement binary search in JavaScript with examples" \
    "Implement binary search in Go with benchmarks" \
    "Implement binary search in Rust with error handling"
```

### 27. **Theme Variations** 🎨
```bash
run_claude_parallel \
    "Create dark theme CSS for dashboard" \
    "Create light theme CSS for dashboard" \
    "Create high-contrast theme for accessibility" \
    "Create colorful theme for creative users"
```

---

## 🧪 Section 7: Testing and Quality

### 28. **Quality Assurance Blitz** ✅
```bash
run_claude_parallel \
    "Add TypeScript types to this JavaScript: $(cat app.js)" \
    "Add JSDoc comments to all functions: $(cat utils.js)" \
    "Create validation schemas for API inputs: $(cat routes.js)" \
    "Add error boundaries to React components: $(cat App.jsx)"
```

### 29. **Performance Testing Suite** 📊
```bash
run_claude_parallel \
    "Create load test script for homepage" \
    "Generate stress test for API endpoints" \
    "Build memory leak detection script" \
    "Create database performance benchmark"
```

### 30. **Security Hardening** 🛡️
```bash
run_claude_parallel \
    "Add input validation to all forms" \
    "Implement rate limiting for API" \
    "Create HTTPS redirect middleware" \
    "Add CORS configuration" \
    "Generate security headers middleware"
```

---

## 📦 Section 8: Package and Deploy

### 31. **Deployment Pipeline** 🚀
```bash
run_claude_parallel \
    "Create production Dockerfile with multi-stage build" \
    "Generate docker-compose for production deployment" \
    "Create Kubernetes manifests with secrets" \
    "Build CI/CD pipeline with automated testing"
```

### 32. **Package Everything** 📦
```bash
run_claude_parallel \
    "Create npm package.json with all dependencies" \
    "Generate requirements.txt for Python project" \
    "Create setup.py for Python package distribution" \
    "Build webpack config for production bundle"
```

### 33. **Environment Configuration** ⚙️
```bash
run_claude_parallel \
    "Create .env.development with local settings" \
    "Generate .env.production with secure defaults" \
    "Create .env.test for testing environment" \
    "Build environment validation script"
```

---

## 🔧 Section 9: Utility Scripts

### 34. **Cleanup and Maintenance** 🧹
```bash
run_claude_parallel \
    "Create script to clean old log files" \
    "Generate database backup automation" \
    "Build file organization script" \
    "Create dependency update checker"
```

### 35. **Development Helpers** 🛠️
```bash
run_claude_parallel \
    "Create git hook for pre-commit linting" \
    "Generate code formatter configuration" \
    "Build development environment setup script" \
    "Create project scaffolding template"
```

### 36. **Monitoring Scripts** 📊
```bash
run_claude_parallel \
    "Create server health check script" \
    "Generate application performance monitor" \
    "Build error reporting and alerting" \
    "Create usage analytics collector"
```

---

## 🎯 Section 10: Advanced One-Liners

### 37. **Git Repository Enhancement** 📂
```bash
# Add comprehensive documentation to entire repo
for file in $(find . -name "*.py" -o -name "*.js" -o -name "*.md"); do
    run_claude_async "Enhance this file with better documentation and comments: $(cat $file)"
done && git add . && git commit -m "Enhanced documentation across entire repository"
```

### 38. **Instant API from Database** ⚡
```bash
# Generate complete CRUD API from database schema
run_claude_parallel \
    "Create Express CRUD routes for users table" \
    "Generate Sequelize models from database schema" \
    "Build input validation middleware" \
    "Create API tests for all endpoints" \
    "Generate OpenAPI documentation"
```

### 39. **Full Test Coverage** 🎯
```bash
# Generate tests for every file in your project
for file in $(find ./src -name "*.js" -o -name "*.py"); do
    run_claude_async "Create comprehensive test suite for this file with 100% coverage: $(cat $file)"
done
```

### 40. **Instant Docker Environment** 🐳
```bash
run_claude_parallel \
    "Create development Dockerfile" \
    "Generate docker-compose with all services" \
    "Build production multi-stage Dockerfile" \
    "Create Docker health checks" \
    "Generate container orchestration scripts"
```

---

## 🚀 Section 11: Real-World Scenarios

### 41. **Legacy Code Modernization** 🔄
```bash
# Modernize old codebase in parallel
run_claude_parallel \
    "Convert jQuery code to modern vanilla JS: $(cat old-script.js)" \
    "Migrate PHP 5 to PHP 8 with modern features: $(cat legacy.php)" \
    "Update old CSS to modern flexbox/grid: $(cat old-styles.css)" \
    "Convert callback hell to async/await: $(cat callbacks.js)"
```

### 42. **Startup MVP Generator** 🌟
```bash
# Generate complete startup in 30 minutes
run_claude_parallel \
    "Create landing page with hero section and features" \
    "Build user authentication system with email/password" \
    "Generate payment integration with Stripe" \
    "Create admin dashboard with user management" \
    "Build email notification system" \
    "Generate analytics tracking setup"
```

### 43. **Open Source Project Setup** 📖
```bash
run_claude_parallel \
    "Create comprehensive README with examples" \
    "Generate CONTRIBUTING.md with guidelines" \
    "Build CODE_OF_CONDUCT.md" \
    "Create issue templates for GitHub" \
    "Generate LICENSE file" \
    "Create pull request template"
```

### 44. **Performance Audit Everything** 📈
```bash
for file in $(find . -name "*.js" -o -name "*.css" -o -name "*.html"); do
    run_claude_async "Perform performance audit and optimization for: $(cat $file)"
done
```

### 45. **Accessibility Compliance** ♿
```bash
run_claude_parallel \
    "Add ARIA labels to all interactive elements: $(cat index.html)" \
    "Create high contrast CSS theme: $(cat styles.css)" \
    "Add keyboard navigation to JavaScript: $(cat app.js)" \
    "Generate screen reader friendly content structure"
```

---

## 🎮 Section 12: Fun and Creative

### 46. **Game Development Assets** 🎮
```bash
run_claude_parallel \
    "Create HTML5 canvas game engine" \
    "Generate sprite animation system" \
    "Build game physics with collision detection" \
    "Create game state management" \
    "Generate sound effect integration"
```

### 47. **Creative Coding** 🎨
```bash
run_claude_parallel \
    "Create CSS animations for loading spinners" \
    "Generate interactive SVG illustrations" \
    "Build particle system with JavaScript" \
    "Create morphing shape animations" \
    "Generate color palette generator tool"
```

### 48. **Data Visualization** 📊
```bash
run_claude_parallel \
    "Create interactive charts with D3.js" \
    "Generate dashboard with real-time data" \
    "Build data filtering and search interface" \
    "Create responsive chart components" \
    "Generate export functionality for charts"
```

---

## 🔥 Section 13: Power User Tricks

### 49. **Custom Callback Functions** 🎯
```bash
# Define what happens when jobs complete
my_custom_handler() {
    local output="$1"
    local job_name="$2"
    
    # Save with timestamp
    echo "$output" > "generated_$(date +%H%M%S)_${job_name}.txt"
    
    # Auto-commit to git
    git add .
    git commit -m "Generated: $job_name"
    
    echo "✅ Generated and committed: $job_name"
}

# Use custom handler
run_claude_with_handler \
    "Create awesome React component" \
    "react-component.jsx" \
    "my_custom_handler"
```

### 50. **Smart File Processing** 🧠
```bash
# Process different file types intelligently
for file in $(find . -type f); do
    case "$file" in
        *.js)
            run_claude_async "Add TypeScript types and JSDoc to: $(cat $file)"
            ;;
        *.py)
            run_claude_async "Add type hints and docstrings to: $(cat $file)"
            ;;
        *.css)
            run_claude_async "Convert to SCSS with variables: $(cat $file)"
            ;;
        *.md)
            run_claude_async "Enhance documentation with examples: $(cat $file)"
            ;;
    esac
done
```

### 💎 **BONUS: New Claude Functions Examples!**

#### 51. **Redis Caching Workflow** 💾
```bash
# Cache user data for quick access
cc-cache-set "user:john" '{"name":"John","role":"admin"}' 3600

# Retrieve and use cached data
user_data=$(cc-cache-get "user:john")
echo "User: $user_data"

# Check cache statistics
cc-cache-stats
```

#### 52. **Batch File Processing Power** 📁
```bash
# Process all JavaScript files to add TypeScript
batch_file_processor "src/*.js" "Convert to TypeScript with proper types"

# Enhance all markdown files
markdown_enhancer ./docs

# Optimize all CSS files
css_optimizer "styles/*.css"
```

#### 53. **Git Automation** 🐙
```bash
# Generate smart commit message based on changes
git add .
git_commit_generator

# Create release with auto-generated notes
git_tag_release "v2.0.0"

# Analyze repository health
git_repo_analyzer
```

#### 54. **Testing Suite Generation** 🧪
```bash
# Generate comprehensive tests for all source files
test_generator "src/*.ts" "jest"

# Run security scan
security_scanner

# Monitor performance
performance_monitor 120
```

#### 55. **Database Operations** 🗄️
```bash
# Async MySQL batch inserts
echo "john,doe,john@example.com
jane,smith,jane@example.com" > users.txt
mysql_async_insert "mydb" "users" "users.txt"

# Backup SQLite database
sqlite_backup_async "app.db"
```

---

## 🎉 Bonus: Mega Workflows

### 🚀 **Complete Project Generator**
```bash
# Generate EVERYTHING for a new project
create_full_project() {
    local project_name="$1"
    
    echo "🚀 Creating complete project: $project_name"
    
    # Backend
    run_claude_parallel \
        "Create Express.js server with authentication" \
        "Generate PostgreSQL database schema" \
        "Create API documentation with Swagger" \
        "Build comprehensive error handling"
    
    wait_for_claude_jobs
    
    # Frontend  
    run_claude_parallel \
        "Create React app with routing" \
        "Build responsive CSS framework" \
        "Generate state management setup" \
        "Create component library"
    
    wait_for_claude_jobs
    
    # DevOps
    run_claude_parallel \
        "Create Docker containerization" \
        "Generate CI/CD pipeline" \
        "Build monitoring and logging" \
        "Create deployment scripts"
    
    wait_for_claude_jobs
    
    echo "✅ Complete project generated!"
}

# Usage
create_full_project "my-awesome-app"
```

---

## 💡 Pro Tips for Vibe Coders

### 🎯 **Quick Wins**
- Always use `wait_for_claude_jobs` after parallel tasks
- Check `claude_job_status` if things seem stuck
- Use `stop_claude_jobs` to cancel everything
- Test with small batches first

### ⚡ **Speed Tricks**
```bash
# Quick aliases for common tasks
alias doc_all='for f in *.js; do run_claude_async "Document this: $(cat $f)"; done'
alias test_all='for f in *.py; do run_claude_async "Test this: $(cat $f)"; done'
alias docker_all='run_claude_parallel "Create Dockerfile" "Create docker-compose.yml"'
```

### 🛡️ **Safety First**
```bash
# Always backup before mass changes
backup_before_changes() {
    local backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    cp -r . "$backup_dir/"
    echo "📦 Backup created: $backup_dir"
}
```

### 🔍 **Debug Mode**
```bash
# If things go wrong, enable debug
export CLAUDE_ASYNC_DEBUG=1
run_claude_async "test prompt"
```

---

## 🎊 You're Now a Parallel Processing Wizard!

**Congratulations!** 🎉 You now have 50+ working examples that will make you:
- ⚡ **10x faster** at code generation
- 🚀 **More productive** than your colleagues  
- 💡 **Capable of handling** massive code projects
- 🎯 **Able to automate** repetitive tasks

### 🔥 **Quick Reference Card**
```bash
# The Big 4 Commands You'll Use Daily:
run_claude_parallel "prompt1" "prompt2" "prompt3"  # Multiple at once
run_claude_async "single prompt"                   # One job
claude_job_status                                  # Check progress  
wait_for_claude_jobs                              # Wait for completion
```

### 🚀 **Next Steps**
1. **🧪 Try the examples** - Copy/paste and run them
2. **🔧 Modify for your needs** - Change prompts to match your projects
3. **📈 Scale up gradually** - Start with 2-3 parallel jobs, then more
4. **🎯 Automate everything** - Use loops to process entire codebases
5. **🤝 Share your wins** - Tell others about your productivity gains!

---

**Happy coding, vibe coder!** 🎵✨

*Remember: The best code is code you don't have to write manually!* 🤖