# Multi-Claude-Code (mcc) 🚀

A comprehensive workflow system for managing multiple Claude Code instances working on parallel development tasks using git worktrees.

## Overview

Multi-Claude-Code (mcc) allows you to run multiple Claude Code instances simultaneously, each working on different features in isolated git worktrees. This enables parallel development, reduces context switching, and maintains clean separation between different tasks.

### Key Features

- **🔀 Git Worktree Isolation**: Each task runs in its own isolated worktree
- **🪟 Terminal Integration**: Automatic Terminal.app window management on macOS  
- **📋 Task Tracking**: Built-in progress tracking with TASK.md files
- **🤝 Context Handoff**: Pass context between Claude instances via git commits
- **🧹 Clean Workflow**: Automatic branch creation, merging, and cleanup
- **⚡ Parallel Development**: Work on multiple features simultaneously
- **🎯 Status Overview**: See all active work at a glance

## Quick Start

### Installation

1. **Clone or download** the mcc files to your project directory
2. **Run the setup script**:
   ```bash
   ./setup.sh
   ```
3. **Start your first task**:
   ```bash
   mcc new auth-system
   ```

### Basic Workflow

```bash
# 1. Start a new task (creates worktree + opens Terminal)
mcc new user-authentication

# This creates:
# - New branch: work/user-authentication
# - Worktree: ../user-authentication-worktree/
# - Opens Terminal in the worktree directory
# - TASK.md file for tracking progress

# 2. In the new Terminal window that opens:
# You'll be in the worktree directory on the new branch
claude          # Launch Claude Code (or your editor)
# OR
code .          # VS Code
vim .           # Vim, etc.

# 3. Work on your task, make commits as you go
git add .
git commit -m "Implement login form"

# 4. Save progress and context for handoff (optional)
mcc handoff user-authentication "Login flow completed, working on logout"

# 5. See all active tasks from anywhere
mcc list

# 6. Complete task (merge & cleanup)
mcc done user-authentication

# 7. Check overall status anytime
mcc status
```

## Installation

### Prerequisites

- **macOS** (for Terminal.app integration)
- **Git** (version 2.5+)
- **Claude Code CLI** ([Installation guide](https://docs.anthropic.com/en/docs/claude-code))

### Setup Options

#### Option 1: Automatic Setup (Recommended)
```bash
git clone <your-project> project-name
cd project-name
curl -O https://raw.githubusercontent.com/your-repo/mcc/main/setup.sh
chmod +x setup.sh
./setup.sh
```

#### Option 2: Manual Setup
1. Download `mcc` and `setup.sh` to your project directory
2. Make executable: `chmod +x mcc setup.sh`
3. Run setup: `./setup.sh`

#### Option 3: Global Installation
```bash
# Clone to a dedicated directory
git clone <mcc-repo> ~/mcc
cd ~/mcc
./setup.sh
# Choose option 1 or 2 to add to PATH
```

## Commands Reference

### Core Commands

| Command | Alias | Description | Example |
|---------|-------|-------------|---------|
| `mcc new <task>` | `n` | Create new worktree and launch Claude | `mcc new auth-system` |
| `mcc list` | `ls` | List all active tasks | `mcc list` |
| `mcc status` | `st` | Show detailed status overview | `mcc status` |
| `mcc done <task>` | `d` | Complete, merge, and cleanup task | `mcc done auth-system` |
| `mcc handoff <task> [msg]` | `h` | Create context handoff commit | `mcc handoff auth-system "Login working"` |
| `mcc cleanup` | `c` | Clean up orphaned worktrees | `mcc cleanup` |
| `mcc help` | | Show help and usage | `mcc help` |

### Command Details

#### `mcc new <task-name>`
Creates a new development task with:
- Isolated git worktree in `../<task-name>-worktree/`
- New branch with `work/` prefix
- TASK.md file for progress tracking
- New Terminal window that attempts to launch Claude Code

**What happens:**
1. Creates isolated worktree directory
2. Sets up new branch from your main/master branch
3. Opens new Terminal window and navigates to worktree
4. Attempts to run `claude-code` (install Claude Code CLI first)
5. If Claude Code CLI isn't installed, you can manually run `claude` or your preferred editor

**Example:**
```bash
mcc new user-profile
# Creates: work/user-profile branch
# Directory: ../user-profile-worktree/  
# Opens: New Terminal in worktree directory
# Run: claude, code ., vim ., etc. to start working
```

#### `mcc list`
Shows all active tasks with status indicators:
- 🟢 **Active**: Worktree exists, no changes
- 🟡 **Working**: Uncommitted changes present  
- 🔵 **Ready**: Commits ready to merge

#### `mcc status`
Comprehensive overview showing:
- Current branch
- All git worktrees
- Active task details
- Branch relationships

#### `mcc done <task-name>`
Completes a task by:
1. Checking for uncommitted changes
2. Switching to main branch
3. Pulling latest changes
4. Merging feature branch
5. Cleaning up worktree and branch
6. Updating task tracking

#### `mcc handoff <task-name> [message]`
Creates a handoff commit for context sharing:
- Stages all current changes
- Creates commit with handoff message
- Updates TASK.md with progress
- Enables smooth context transfer

## Daily Workflow Examples

### Scenario 1: Multiple Independent Features

```bash
# Morning: Start multiple parallel tasks
mcc new user-authentication    # Claude 1: Auth system
mcc new product-catalog       # Claude 2: Product features  
mcc new payment-integration   # Claude 3: Payment system

# Check what's active
mcc list
# 🟢 user-authentication (work/user-authentication)
# 🟢 product-catalog (work/product-catalog)  
# 🟢 payment-integration (work/payment-integration)

# Afternoon: Save progress and switch focus
mcc handoff user-authentication "Login/logout complete, need password reset"
mcc handoff product-catalog "CRUD operations done, working on search"

# Evening: Complete finished work
mcc done payment-integration   # First completed feature
mcc status                     # Check remaining work
```

### Scenario 2: Sequential Development

```bash
# Start with architecture
mcc new core-architecture

# Once architecture is ready, start dependent tasks
mcc handoff core-architecture "Database schema and API structure defined"
mcc new api-implementation     # Based on architecture
mcc new frontend-components    # Can work in parallel

# Complete in dependency order
mcc done core-architecture
mcc done api-implementation  
mcc done frontend-components
```

### Scenario 3: Bug Fix Workflow

```bash
# Urgent bug fix
mcc new fix-login-issue

# Work on fix, test, document
mcc handoff fix-login-issue "Identified root cause: session timeout"
mcc handoff fix-login-issue "Fix implemented, testing edge cases"

# Complete when verified
mcc done fix-login-issue
```

## Task Organization

### TASK.md Structure

Each worktree contains a `TASK.md` file for tracking:

```markdown
# Task: user-authentication

**Branch:** work/user-authentication  
**Created:** 2024-01-15 09:30:00  
**Status:** In Progress  

## Description
Implement complete user authentication system with login, logout, 
registration, and password reset functionality.

## Progress
- [x] Initial setup
- [x] Login form and validation
- [x] JWT token handling  
- [ ] Password reset flow
- [ ] Email verification
- [ ] Testing and documentation

## Notes
- Using bcrypt for password hashing
- JWT stored in httpOnly cookies for security
- Integration with existing user database

## Handoff Information
Latest handoff: "Login flow completed, logout working. 
Next: implement password reset email system."
```

### Directory Structure

```
project-root/
├── mcc                          # Main script
├── setup.sh                    # Setup script  
├── README.md                   # This file
├── roadmap.md                  # Project planning (created by setup)
├── .mcc/                       # MCC data directory
│   └── active_tasks.txt        # Task tracking
├── .git/                       # Main repository
│   └── worktrees/             # Worktree metadata
└── ../
    ├── task1-worktree/        # Isolated worktree 1
    │   ├── TASK.md           # Task tracking
    │   └── [project files]   # Full project copy
    ├── task2-worktree/        # Isolated worktree 2
    │   ├── TASK.md           # Task tracking  
    │   └── [project files]   # Full project copy
    └── ...
```

## Advanced Usage

### Custom Branch Naming

By default, branches use the `work/` prefix. To customize:

```bash
# Edit mcc script
WORKTREE_PREFIX="feature/"  # Changes to feature/task-name
WORKTREE_PREFIX=""         # No prefix: just task-name
```

### Terminal Window Management

MCC uses AppleScript to manage Terminal windows:

```bash
# Windows are automatically titled with task names
# Example: "Claude: user-authentication"

# Arrange windows manually or use window management tools
# like Rectangle, Magnet, or built-in macOS features
```

### Integration with IDEs

While MCC launches Terminal with Claude Code, you can also:

```bash
# Open worktree in VS Code
code ../task-name-worktree/

# Or other editors
subl ../task-name-worktree/
vim ../task-name-worktree/
```

### Custom Claude Code Command

If your Claude Code installation has a different command name:

```bash
# Edit mcc script, change:
CLAUDE_CMD="claude-code"
# To:
CLAUDE_CMD="your-custom-command"
```

## Coordination Strategies

### Managing Dependencies

1. **Plan Task Order**: Start with foundational work
2. **Use Handoffs**: Share context frequently
3. **Merge Regularly**: Avoid long-running branches
4. **Communicate**: Use commit messages and TASK.md

### Avoiding Conflicts

1. **File Separation**: Work on different files when possible  
2. **Feature Flags**: Use flags for incomplete features
3. **Small Commits**: Make atomic, focused commits
4. **Regular Rebasing**: Keep branches up to date

### Context Sharing

```bash
# Before switching focus
mcc handoff current-task "Current status and next steps"

# After resuming  
git log --oneline -5  # Review recent commits
cat TASK.md          # Read task context
```

## Troubleshooting

### Common Issues

#### "Not in a git repository"
```bash
# Initialize git repo
git init
git add .
git commit -m "Initial commit"
```

#### "Worktree directory already exists" 
```bash
# Clean up manually
rm -rf ../task-name-worktree/
git worktree prune

# Or use different task name
mcc new task-name-v2
```

#### "Claude Code command not found"
This is expected if you haven't installed the Claude Code CLI yet.

**Solutions:**
```bash
# Option 1: Install Claude Code CLI (when available)
# Follow instructions at https://docs.anthropic.com/en/docs/claude-code

# Option 2: Use whatever command launches Claude Code for you
# In the Terminal that opens, just run:
claude        # If you have this command
code .        # VS Code
vim .         # Vim
subl .        # Sublime Text
# etc.

# Option 3: Update mcc script with your command
# Edit the CLAUDE_CMD variable in the mcc script:
CLAUDE_CMD="claude"  # or whatever your command is
```

#### "Merge conflicts"
```bash
# During mcc done, if conflicts occur:
git status                    # See conflicted files
# Resolve conflicts manually
git add resolved-files
git commit -m "Resolve merge conflicts"
mcc done task-name           # Retry
```

#### "Terminal window not opening"
```bash
# Check Terminal permissions in System Preferences > Security & Privacy
# Or run Claude Code manually:
cd ../task-name-worktree/
claude-code
```

### Recovery Commands

```bash
# List all worktrees
git worktree list

# Remove orphaned worktree
git worktree remove ../task-worktree/ --force

# Clean up branches  
git branch -D work/task-name

# Reset active tasks tracking
rm .mcc/active_tasks.txt
mcc list  # Rebuilds tracking
```

### Debug Mode

For troubleshooting, add debug output:

```bash
# Edit mcc script, add after #!/bin/bash:
set -x  # Enable debug mode
```

## Configuration

### Environment Variables

```bash
# Custom configuration
export MCC_WORKTREE_PREFIX="feature/"
export MCC_CLAUDE_CMD="my-claude-command"  
export MCC_TERMINAL_APP="iTerm"  # Future: other terminal support
```

### Per-Project Settings

Create `.mccrc` in your project root:

```bash
# .mccrc
WORKTREE_PREFIX="epic/"
CLAUDE_CMD="claude-dev"
```

## Integrations

### CI/CD Integration

```yaml
# .github/workflows/mcc-check.yml
name: MCC Branch Check
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Check MCC branches
      run: |
        # Custom checks for work/ branches
        git branch -r | grep work/ && echo "Work branches detected"
```

### IDE Extensions

Future integrations could include:
- VS Code extension for MCC management
- Sublime Text plugin
- Vim/Neovim integration

## FAQ

**Q: Can I use mcc with existing branches?**  
A: MCC creates new branches with the `work/` prefix. To use existing branches, manually create worktrees with `git worktree add`.

**Q: What happens if Claude Code crashes?**  
A: The worktree remains intact. Simply `cd ../task-worktree/` and run `claude-code` again.

**Q: Can I use multiple main branches?**  
A: Currently MCC assumes one main branch. For multiple bases, manually specify: `git worktree add -b new-branch ../path existing-branch`.

**Q: How do I backup my work?**  
A: All work is in git. Use `git push origin work/branch-name` to backup individual branches.

**Q: Can I customize the TASK.md template?**  
A: Yes, edit the `new_task()` function in the mcc script to customize the template.

## Contributing

### Bug Reports
1. Check existing issues
2. Provide reproduction steps  
3. Include system info (macOS version, git version, etc.)

### Feature Requests
1. Describe use case
2. Explain expected behavior
3. Consider backward compatibility

### Pull Requests
1. Fork the repository
2. Create feature branch
3. Add tests if applicable  
4. Update documentation
5. Submit PR with clear description

## License

[Add your license here]

## Changelog

### v1.0.0 - Initial Release
- Core workflow management
- Git worktree integration
- Terminal.app automation  
- Task tracking system
- Context handoff features
- Comprehensive documentation

---

## Support

- **Documentation**: This README and inline help (`mcc help`)
- **Issues**: [GitHub Issues](https://github.com/your-repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/discussions)

---

**Happy Multi-Claude Development!** 🚀

*Built for developers who want to maximize productivity with parallel Claude Code instances.*