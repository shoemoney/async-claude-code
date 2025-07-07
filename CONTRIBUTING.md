# 🤝 Contributing to Claude Code Async Runner

Thank you for your interest in contributing to Claude Code Async Runner! 🎉 This project thrives on community contributions and we welcome all forms of help.

## 🌟 Ways to Contribute

### 🐛 **Bug Reports**
Found a bug? Help us squash it!

**Before submitting:**
- 🔍 Search [existing issues](../../issues) to avoid duplicates
- ✅ Ensure you're using the latest version
- 📋 Test with minimal reproduction case

**When reporting:**
- 🎯 Use a clear, descriptive title
- 📝 Provide step-by-step reproduction instructions
- 💻 Include system information (OS, Zsh version, Claude Code version)
- 📋 Share error messages and logs
- 🎯 Describe expected vs actual behavior

### ✨ **Feature Requests**
Have an idea for improvement?

**Guidelines:**
- 🎯 Clearly describe the problem you're solving
- 💡 Explain the proposed solution
- 🔗 Provide use cases and examples
- 📊 Consider performance and compatibility impacts
- 🤔 Discuss alternatives you've considered

### 📚 **Documentation Improvements**
Help make our docs better!

**Areas that need help:**
- 📖 Tutorial improvements
- 🔧 Setup instructions
- 💡 More examples and recipes
- 🌍 Translation to other languages
- 🎥 Video tutorials

### 🔧 **Code Contributions**
Ready to code? Here's how!

## 🛠️ Development Setup

### 📋 **Prerequisites**
```bash
# ✅ Required tools
- Zsh shell (version 5.0+)
- Claude Code CLI
- Git
- Basic understanding of shell scripting
```

### 🔧 **Local Development**
```bash
# 1️⃣ Fork and clone
git clone https://github.com/YOUR-USERNAME/claude-code-async.git
cd claude-code-async

# 2️⃣ Install dependencies
git clone https://github.com/mafredri/zsh-async ~/.zsh-async

# 3️⃣ Source the main script
source claude-code-async.zsh

# 4️⃣ Test your setup
run_claude_async "echo 'Hello, World!'"
```

## 📝 **Development Guidelines**

### 🎯 **Code Style**
- 📏 Use 4 spaces for indentation (no tabs)
- 📝 Include comprehensive comments with emojis
- 🏷️ Use descriptive variable names
- 🔧 Follow existing function naming patterns
- ⚡ Optimize for readability and performance

### 💬 **Comment Standards**
```bash
# 🎯 Function description with emoji
# This function does something specific and important
function_name() {
    local param="$1"                    # 📝 Parameter description
    
    # 🔄 Processing step explanation
    for item in "${items[@]}"; do
        # 💡 Inner logic explanation
        process_item "$item"            # ⚡ Action description
    done
}
```

### 🧪 **Testing Guidelines**
- ✅ Test new features with small batches first
- 🔄 Verify retry logic with intentional failures
- 📊 Test resource limits with system monitoring
- 🌐 Test network failure scenarios
- 🔒 Verify file locking mechanisms

### 📚 **Documentation Standards**
- 📝 Update README.md for new features
- 🔧 Add function documentation to relevant files
- 💡 Include practical examples
- 🎯 Explain use cases and benefits
- ⚠️ Document any breaking changes

## 🔄 **Pull Request Process**

### 📋 **Before Submitting**
- [ ] 🔍 Read and follow this contributing guide
- [ ] ✅ Test your changes thoroughly
- [ ] 📝 Update documentation as needed
- [ ] 🧹 Ensure code follows style guidelines
- [ ] 🔄 Rebase on latest main branch

### 📤 **Submitting PR**
1. **🏷️ Use descriptive title**: `Add retry logic for batch processing`
2. **📝 Provide detailed description**:
   ```markdown
   ## 🎯 Changes Made
   - Added exponential backoff retry logic
   - Improved error handling for network failures
   - Added configuration options for retry attempts
   
   ## ✅ Testing Done
   - Tested with intentional network failures
   - Verified exponential backoff timing
   - Tested with various batch sizes
   
   ## 📋 Checklist
   - [x] Tests pass
   - [x] Documentation updated
   - [x] Follows code style guidelines
   ```

3. **🔗 Link related issues**: "Fixes #123" or "Addresses #456"

### 🔍 **Review Process**
- 👥 All PRs require review from maintainers
- 🔄 Address review feedback promptly  
- ✅ Ensure CI checks pass
- 📝 Update PR description if scope changes

## 🎯 **Priority Areas**

### 🚀 **High Priority**
- 🐛 Bug fixes for existing functionality
- 📊 Performance improvements
- 🔐 Security enhancements
- 📚 Documentation improvements

### 💡 **Medium Priority**
- ✨ New recipe patterns
- 🔧 Developer experience improvements
- 🧪 Additional testing scenarios
- 🌐 Cross-platform compatibility

### 🌟 **Nice to Have**
- 🎨 UI/CLI improvements
- 📹 Video tutorials
- 🌍 Internationalization
- 🔌 Plugin system

## 🎓 **Learning Resources**

### 📚 **Understanding the Codebase**
- 📖 Start with [`claude-async-readme.md`](claude-async-readme.md)
- 🔍 Study [`claude-async-instructions.md`](claude-async-instructions.md)
- 🍳 Explore recipes in [`claude-async-cookbook.md`](claude-async-cookbook.md)

### 🧠 **Shell Scripting Resources**
- [Advanced Bash Scripting Guide](https://tldp.org/LDP/abs/html/)
- [Zsh Manual](http://zsh.sourceforge.net/Doc/)
- [zsh-async Documentation](https://github.com/mafredri/zsh-async)

### 🎓 **Learn from IndyDevDan**
- 📺 [IndyDevDan YouTube Channel](https://www.youtube.com/c/IndyDevDan)
- 🌐 [IndyDevDan Website](https://indydevdan.com)
- 🤖 Claude Code programming tutorials

## 🤔 **Questions?**

### 💬 **Get Help**
- 📋 [Open an issue](../../issues) for questions
- 💡 Check existing documentation first
- 🔍 Search closed issues for similar questions

### 🌐 **Community**
- 🎓 Learn from [IndyDevDan's tutorials](https://www.youtube.com/c/IndyDevDan)
- 🤖 Official [Claude Code documentation](https://docs.anthropic.com/claude-code)
- 🐚 [Zsh community resources](https://github.com/ohmyzsh/ohmyzsh)

## 🏆 **Recognition**

Contributors are recognized in several ways:
- 📝 Listed in README.md contributors section
- 🎉 Mentioned in release notes
- ⭐ GitHub contributor badge
- 🙏 Special thanks for significant contributions

## 📜 **Code of Conduct**

### 🤝 **Our Standards**
- 🌟 Be respectful and inclusive
- 💡 Welcome newcomers and help them learn
- 🎯 Focus on constructive feedback
- 🧠 Assume positive intent
- 🚀 Celebrate diverse perspectives

### 🚫 **Unacceptable Behavior**
- ❌ Harassment or discrimination
- 💢 Trolling or inflammatory comments
- 🚫 Publishing private information
- 😠 Personal attacks
- 🔥 Disruptive behavior

### 📞 **Reporting**
If you experience or witness unacceptable behavior:
- 📧 Email maintainers privately
- 📋 Open a confidential issue
- 🛡️ All reports will be handled respectfully

## 🙏 **Thank You!**

Every contribution helps make Claude Code Async Runner better for everyone. Whether you:
- 🐛 Report a bug
- 💡 Suggest a feature  
- 📝 Improve documentation
- 🔧 Submit code
- 🌟 Spread the word

**You're making a difference!** 🎉

---

> **💡 Pro Tip**: Start small! Even fixing a typo or improving a comment is a valuable contribution that helps you learn the codebase.

**Happy coding!** 🚀✨