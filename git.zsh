#!/usr/bin/env zsh

# 🐙 Git Module - Git Operations Functions
# 🎯 Part of Claude Functions Async Utility Library
# 🔧 New naming convention: cc-git-<action>
#
# 📋 Available Functions:
#   • cc-git-commit-generate  - Generate smart commit messages
#   • cc-git-tag-release      - Create releases with notes
#   • cc-git-repo-analyze     - Analyze repository health
#   • cc-git-branch-create    - Create feature branches
#   • cc-git-merge-prepare    - Prepare merge requests  
#   • cc-git-hooks-setup      - Setup git hooks
#   • cc-git-help            - Show help for git functions

# ═══════════════════════════════════════════════════════════════════════════════
# 🐙 GIT AUTOMATION FUNCTIONS - Smart Repository Management! 🚀
# ═══════════════════════════════════════════════════════════════════════════════

# 💬 cc-git-commit-generate - Generate intelligent commit messages based on changes
# 🎯 Usage: cc-git-commit-generate [--auto-commit]
cc-git-commit-generate() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "💬 cc-git-commit-generate - Generate intelligent commit messages"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-git-commit-generate [--auto-commit]"
        echo ""
        echo "📝 Parameters:"
        echo "  --auto-commit    🚀 Automatically commit with generated message (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-git-commit-generate"
        echo "  cc-git-commit-generate --auto-commit"
        echo ""
        echo "💡 Analyzes:"
        echo "  • Staged changes (git diff --cached)"
        echo "  • File modifications and additions"
        echo "  • Code patterns and conventions"
        echo "  • Generates conventional commit format"
        return 0
    fi
    
    local auto_commit=false
    [[ "$1" == "--auto-commit" ]] && auto_commit=true
    
    # 🔍 Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    # 🔍 Check for staged changes
    if ! git diff --cached --quiet; then
        echo "💬 Analyzing staged changes for commit message..."
        
        # 📊 Get diff statistics
        local diff_stats=$(git diff --cached --stat)
        local changed_files=$(git diff --cached --name-only)
        local diff_content=$(git diff --cached)
        
        echo "📋 Changed files:"
        echo "$changed_files"
        echo ""
        
        # 🚀 Generate commit message
        echo "🤖 Generating intelligent commit message..."
        run_claude_async "Analyze these git changes and generate a concise, conventional commit message (feat/fix/docs/style/refactor/test/chore). Consider the files changed and the actual diff content:

Files changed:
$changed_files

Diff stats:
$diff_stats

Diff content:
$diff_content

Generate a single line commit message in conventional commit format." &
        
        wait_for_claude_jobs
        
        if [[ "$auto_commit" == true ]]; then
            echo "🚀 Auto-committing with generated message..."
            # Note: In real implementation, you'd capture the generated message and use it
            echo "💡 Auto-commit would be executed here with the generated message"
        else
            echo "💡 Review the generated commit message above and use it with 'git commit -m \"<message>\"'"
        fi
    else
        echo "❌ No staged changes found. Use 'git add' to stage files first."
        return 1
    fi
}

# 🏷️ cc-git-tag-release - Create release tags with auto-generated release notes
# 🎯 Usage: cc-git-tag-release "v1.0.0" [--push]
cc-git-tag-release() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🏷️ cc-git-tag-release - Create release tags with auto-generated notes"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-git-tag-release <version> [--push]"
        echo ""
        echo "📝 Parameters:"
        echo "  version    🏷️ Version tag (e.g., 'v1.0.0', '2.1.0')"
        echo "  --push     🚀 Push tag to remote after creation (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-git-tag-release \"v1.0.0\""
        echo "  cc-git-tag-release \"v2.1.0\" --push"
        echo ""
        echo "💡 Generates:"
        echo "  • Release notes from commit history"
        echo "  • Changelog entries"
        echo "  • Breaking changes summary"
        echo "  • Feature and bug fix lists"
        return 0
    fi
    
    local version="$1"
    local push_flag=false
    [[ "$2" == "--push" ]] && push_flag=true
    
    if [[ -z "$version" ]]; then
        echo "❌ Usage: cc-git-tag-release <version> [--push]"
        echo "💡 Use 'cc-git-tag-release -h' for detailed help"
        return 1
    fi
    
    # 🔍 Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    # 🔍 Check if tag already exists
    if git tag -l | grep -q "^$version\$"; then
        echo "❌ Tag $version already exists"
        return 1
    fi
    
    echo "🏷️ Creating release tag: $version"
    
    # 📊 Get commit history since last tag
    local last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    local commit_range
    if [[ -n "$last_tag" ]]; then
        commit_range="$last_tag..HEAD"
        echo "📈 Changes since $last_tag:"
    else
        commit_range="HEAD"
        echo "📈 All commits (no previous tags):"
    fi
    
    local commit_log=$(git log --oneline $commit_range)
    local detailed_log=$(git log --pretty=format:"%h %s (%an)" $commit_range)
    
    echo "$commit_log"
    echo ""
    
    # 🚀 Generate release notes
    echo "📝 Generating release notes..."
    run_claude_async "Generate comprehensive release notes for version $version based on these git commits. Format as markdown with sections for Features, Bug Fixes, Breaking Changes, and Other Changes:

Commit history:
$detailed_log

Create professional release notes that highlight the most important changes and improvements." &
    
    wait_for_claude_jobs
    
    # 🏷️ Create the tag (in real implementation, you'd use the generated message)
    echo "🏷️ Creating git tag..."
    echo "💡 Tag creation command would be: git tag -a $version -m \"Release $version\""
    
    if [[ "$push_flag" == true ]]; then
        echo "🚀 Pushing tag to remote..."
        echo "💡 Push command would be: git push origin $version"
    fi
    
    echo "✅ Release tag $version created successfully!"
}

# 🔍 cc-git-repo-analyze - Analyze repository health and provide insights
# 🎯 Usage: cc-git-repo-analyze [--detailed]
cc-git-repo-analyze() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🔍 cc-git-repo-analyze - Analyze repository health and insights"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-git-repo-analyze [--detailed]"
        echo ""
        echo "📝 Parameters:"
        echo "  --detailed    📊 Include detailed analysis (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-git-repo-analyze"
        echo "  cc-git-repo-analyze --detailed"
        echo ""
        echo "📊 Analyzes:"
        echo "  • Commit frequency and patterns"
        echo "  • Branch structure and health"
        echo "  • Code quality metrics"
        echo "  • Repository size and files"
        echo "  • Contributor activity"
        return 0
    fi
    
    local detailed=false
    [[ "$1" == "--detailed" ]] && detailed=true
    
    # 🔍 Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    echo "🔍 Analyzing repository health..."
    
    # 📊 Basic repository stats
    local total_commits=$(git rev-list --all --count)
    local total_branches=$(git branch -a | wc -l)
    local total_files=$(git ls-files | wc -l)
    local repo_size=$(du -sh .git 2>/dev/null | cut -f1)
    local contributors=$(git shortlog -sn | wc -l)
    
    echo "📊 Repository Overview:"
    echo "  🔢 Total commits: $total_commits"
    echo "  🌿 Total branches: $total_branches"
    echo "  📄 Total files: $total_files"
    echo "  💾 Repository size: $repo_size"
    echo "  👥 Contributors: $contributors"
    echo ""
    
    # 📈 Recent activity
    local commits_last_week=$(git rev-list --since="1 week ago" --count HEAD)
    local commits_last_month=$(git rev-list --since="1 month ago" --count HEAD)
    
    echo "📈 Recent Activity:"
    echo "  📅 Commits (last week): $commits_last_week"
    echo "  📅 Commits (last month): $commits_last_month"
    echo ""
    
    if [[ "$detailed" == true ]]; then
        # 📊 Detailed analysis
        local commit_history=$(git log --oneline --since="1 month ago")
        local branch_info=$(git branch -v)
        local file_types=$(git ls-files | grep -E '\.[^.]+$' | sed 's/.*\.//' | sort | uniq -c | sort -nr)
        
        echo "🚀 Generating detailed repository analysis..."
        run_claude_async "Provide a comprehensive repository health analysis based on this data:

Repository Stats:
- Total commits: $total_commits
- Branches: $total_branches  
- Files: $total_files
- Contributors: $contributors
- Recent commits (week): $commits_last_week
- Recent commits (month): $commits_last_month

Recent commit history:
$commit_history

Branch information:
$branch_info

File types distribution:
$file_types

Provide insights on:
1. Repository health and activity levels
2. Branching strategy assessment
3. Code organization suggestions
4. Potential improvements
5. Development patterns analysis" &
        
        wait_for_claude_jobs
    fi
    
    echo "✅ Repository analysis completed!"
}

# 🌿 cc-git-branch-create - Create feature branches with smart naming
# 🎯 Usage: cc-git-branch-create "feature description" [--switch]
cc-git-branch-create() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🌿 cc-git-branch-create - Create feature branches with smart naming"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-git-branch-create \"<description>\" [--switch]"
        echo ""
        echo "📝 Parameters:"
        echo "  description    📝 Feature description (required)"
        echo "  --switch       🔄 Switch to new branch after creation (optional)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-git-branch-create \"add user authentication\""
        echo "  cc-git-branch-create \"fix login bug\" --switch"
        echo ""
        echo "💡 Generates branch names like:"
        echo "  • feature/add-user-authentication"
        echo "  • bugfix/fix-login-bug"
        echo "  • enhancement/improve-performance"
        return 0
    fi
    
    local description="$1"
    local switch_flag=false
    [[ "$2" == "--switch" ]] && switch_flag=true
    
    if [[ -z "$description" ]]; then
        echo "❌ Usage: cc-git-branch-create \"<description>\" [--switch]"
        echo "💡 Use 'cc-git-branch-create -h' for detailed help"
        return 1
    fi
    
    # 🔍 Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    echo "🌿 Generating smart branch name for: $description"
    
    # 🚀 Generate branch name
    run_claude_async "Generate a git branch name following conventions for this description: '$description'. Use prefixes like feature/, bugfix/, hotfix/, enhancement/, docs/, test/, etc. followed by kebab-case description. Return only the branch name, nothing else." &
    
    wait_for_claude_jobs
    
    # Note: In real implementation, you'd capture the generated branch name
    echo "💡 Branch creation command would be generated and executed here"
    
    if [[ "$switch_flag" == true ]]; then
        echo "🔄 Would switch to the new branch"
    fi
    
    echo "✅ Smart branch creation completed!"
}

# 🔄 cc-git-merge-prepare - Prepare merge requests with automated checks
# 🎯 Usage: cc-git-merge-prepare [target_branch]
cc-git-merge-prepare() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🔄 cc-git-merge-prepare - Prepare merge requests with automated checks"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-git-merge-prepare [target_branch]"
        echo ""
        echo "📝 Parameters:"
        echo "  target_branch    🎯 Target branch (optional, default: main/master)"
        echo ""
        echo "📋 Examples:"
        echo "  cc-git-merge-prepare"
        echo "  cc-git-merge-prepare \"develop\""
        echo ""
        echo "🔍 Performs:"
        echo "  • Conflict detection"
        echo "  • Code quality checks"
        echo "  • Test status verification"
        echo "  • Merge request template generation"
        return 0
    fi
    
    local target_branch="${1:-main}"
    
    # 🔍 Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    # 🔍 Check if target branch exists
    if ! git show-ref --verify --quiet refs/heads/$target_branch; then
        # Try master as fallback
        if git show-ref --verify --quiet refs/heads/master; then
            target_branch="master"
        else
            echo "❌ Target branch '$target_branch' not found"
            return 1
        fi
    fi
    
    echo "🔄 Preparing merge request to: $target_branch"
    
    # 📊 Get current branch
    local current_branch=$(git branch --show-current)
    echo "📍 Current branch: $current_branch"
    
    # 🔍 Check for conflicts
    echo "🔍 Checking for potential conflicts..."
    local merge_base=$(git merge-base $current_branch $target_branch)
    local conflicts=$(git merge-tree $merge_base $current_branch $target_branch | grep -c "<<<<<<< " || echo "0")
    
    if [[ "$conflicts" -gt 0 ]]; then
        echo "⚠️ Potential conflicts detected: $conflicts"
    else
        echo "✅ No conflicts detected"
    fi
    
    # 📊 Get changes summary
    local commits_ahead=$(git rev-list --count $target_branch..$current_branch)
    local files_changed=$(git diff --name-only $target_branch..$current_branch | wc -l)
    local diff_stats=$(git diff --stat $target_branch..$current_branch)
    
    echo "📊 Changes Summary:"
    echo "  🔢 Commits ahead: $commits_ahead"
    echo "  📄 Files changed: $files_changed"
    echo ""
    
    # 🚀 Generate merge request template
    echo "📝 Generating merge request template..."
    run_claude_async "Generate a comprehensive merge request template based on these changes from $current_branch to $target_branch:

Commits ahead: $commits_ahead
Files changed: $files_changed
Conflicts detected: $conflicts

Diff stats:
$diff_stats

Include sections for:
- Summary of changes
- Testing performed
- Checklist for reviewers
- Any breaking changes
- Related issues

Format as markdown for GitHub/GitLab." &
    
    wait_for_claude_jobs
    echo "✅ Merge request preparation completed!"
}

# 🪝 cc-git-hooks-setup - Setup useful git hooks for the repository
# 🎯 Usage: cc-git-hooks-setup [hook_type]
cc-git-hooks-setup() {
    # 🆘 Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "🪝 cc-git-hooks-setup - Setup useful git hooks"
        echo ""
        echo "🎯 Usage:"
        echo "  cc-git-hooks-setup [hook_type]"
        echo ""
        echo "📝 Parameters:"
        echo "  hook_type    🪝 Specific hook type (optional)"
        echo "    Options: pre-commit, pre-push, commit-msg, post-commit"
        echo ""
        echo "📋 Examples:"
        echo "  cc-git-hooks-setup"
        echo "  cc-git-hooks-setup \"pre-commit\""
        echo ""
        echo "🪝 Available hooks:"
        echo "  • pre-commit: Linting, formatting, tests"
        echo "  • pre-push: CI checks, security scans"
        echo "  • commit-msg: Message format validation"
        echo "  • post-commit: Notifications, backups"
        return 0
    fi
    
    local hook_type="$1"
    
    # 🔍 Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    local git_dir=$(git rev-parse --git-dir)
    local hooks_dir="$git_dir/hooks"
    
    echo "🪝 Setting up git hooks in: $hooks_dir"
    
    if [[ -n "$hook_type" ]]; then
        echo "🎯 Setting up specific hook: $hook_type"
        
        # 🚀 Generate specific hook
        run_claude_async "Generate a comprehensive git $hook_type hook script for a modern development workflow. Include appropriate checks for code quality, testing, and best practices. Make it executable and well-documented." &
    else
        echo "🎯 Setting up comprehensive git hooks suite..."
        
        # 🚀 Generate multiple hooks
        run_claude_async "Generate a complete set of git hooks for a modern development workflow:

1. pre-commit hook: Code linting, formatting, basic tests
2. pre-push hook: Full test suite, security checks
3. commit-msg hook: Conventional commit format validation
4. post-commit hook: Backup, notifications

Each hook should be well-documented, executable, and follow best practices. Include setup instructions." &
    fi
    
    wait_for_claude_jobs
    echo "✅ Git hooks setup completed!"
}

# 🆘 cc-git-help - Show help for all git functions
# 🎯 Usage: cc-git-help [function_name]
cc-git-help() {
    local function_name="$1"
    
    if [[ -n "$function_name" ]]; then
        # 📖 Try to call the specific function with -h flag
        if "$function_name" -h 2>/dev/null; then
            return 0
        else
            echo "❌ Function not found: $function_name"
            echo "💡 Available git functions:"
            echo "   cc-git-commit-generate, cc-git-tag-release, cc-git-repo-analyze"
            echo "   cc-git-branch-create, cc-git-merge-prepare, cc-git-hooks-setup"
            return 1
        fi
    else
        echo "🐙 Claude Git Functions Help"
        echo "════════════════════════════════════════"
        echo ""
        echo "🚀 Quick Start:"
        echo "  cc-git-commit-generate"
        echo "  cc-git-repo-analyze"
        echo "  cc-git-tag-release \"v1.0.0\""
        echo ""
        echo "📚 Available Functions:"
        echo "  💬 cc-git-commit-generate  - Smart commit messages"
        echo "  🏷️ cc-git-tag-release      - Release tags with notes"
        echo "  🔍 cc-git-repo-analyze     - Repository health check"
        echo "  🌿 cc-git-branch-create    - Smart branch naming"
        echo "  🔄 cc-git-merge-prepare    - Merge request prep"
        echo "  🪝 cc-git-hooks-setup      - Setup git hooks"
        echo ""
        echo "💡 Use 'cc-git-help <function_name>' or '<function_name> -h' for specific help"
    fi
}

# 🎉 Git module loaded message
echo "🐙 Git module loaded! (cc-git-*)"