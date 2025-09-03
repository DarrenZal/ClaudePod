#!/bin/bash

# Multi-Claude-Code Setup Script
# Configures the mcc workflow system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
   __  __       _ _   _        ____ _                 _       
  |  \/  |_   _| | |_(_)      / ___| | __ _ _   _  __| | ___  
  | |\/| | | | | | __| |_____| |   | |/ _` | | | |/ _` |/ _ \ 
  | |  | | |_| | | |_| |_____| |___| | (_| | |_| | (_| |  __/ 
  |_|  |_|\__,_|_|\__|_|      \____|_|\__,_|\__,_|\__,_|\___| 
                                                              
   ____          _        ____       _                
  / ___|___   __| | ___  / ___|  ___| |_ _   _ _ __    
 | |   / _ \ / _` |/ _ \ \___ \ / _ \ __| | | | '_ \   
 | |__| (_) | (_| |  __/  ___) |  __/ |_| |_| | |_) | 
  \____\___/ \__,_|\___| |____/ \___|\__|\__,_| .__/  
                                              |_|     

Multi-Claude Workflow Management System
EOF
    echo -e "${NC}"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if we're on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This setup is designed for macOS. Terminal.app integration may not work on other systems."
        exit 1
    fi
    
    # Check for git
    if ! command -v git &> /dev/null; then
        log_error "Git is required but not installed"
        exit 1
    fi
    
    # Check for claude-code (optional warning)
    if ! command -v claude-code &> /dev/null; then
        log_warning "Claude Code CLI not found in PATH"
        log_warning "Make sure to install Claude Code CLI before using mcc"
        log_warning "See: https://docs.anthropic.com/en/docs/claude-code"
    fi
    
    log_success "Prerequisites check complete"
}

# Make mcc executable
setup_executable() {
    log_info "Setting up mcc executable..."
    
    if [[ ! -f "mcc" ]]; then
        log_error "mcc script not found in current directory"
        exit 1
    fi
    
    chmod +x mcc
    log_success "Made mcc executable"
}

# Optionally add to PATH
setup_path() {
    local current_dir
    current_dir=$(pwd)
    
    echo ""
    echo -e "${YELLOW}PATH Setup${NC}"
    echo "=========="
    echo "Would you like to add mcc to your PATH so you can run it from anywhere?"
    echo "This will add the current directory ($current_dir) to your PATH."
    echo ""
    echo "Options:"
    echo "  1) Add to ~/.zshrc (recommended for zsh users)"
    echo "  2) Add to ~/.bash_profile (for bash users)"  
    echo "  3) Skip PATH setup (you'll need to use full path: $current_dir/mcc)"
    echo ""
    
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            local zshrc="$HOME/.zshrc"
            if ! grep -q "$current_dir" "$zshrc" 2>/dev/null; then
                echo "" >> "$zshrc"
                echo "# Multi-Claude-Code (mcc)" >> "$zshrc"
                echo "export PATH=\"$current_dir:\$PATH\"" >> "$zshrc"
                log_success "Added to ~/.zshrc"
                log_info "Run 'source ~/.zshrc' or restart your terminal to use 'mcc' command"
            else
                log_warning "PATH already contains $current_dir"
            fi
            ;;
        2)
            local bash_profile="$HOME/.bash_profile"
            if ! grep -q "$current_dir" "$bash_profile" 2>/dev/null; then
                echo "" >> "$bash_profile"
                echo "# Multi-Claude-Code (mcc)" >> "$bash_profile"
                echo "export PATH=\"$current_dir:\$PATH\"" >> "$bash_profile"
                log_success "Added to ~/.bash_profile"
                log_info "Run 'source ~/.bash_profile' or restart your terminal to use 'mcc' command"
            else
                log_warning "PATH already contains $current_dir"
            fi
            ;;
        3)
            log_info "Skipping PATH setup"
            log_info "Use full path to run: $current_dir/mcc"
            ;;
        *)
            log_warning "Invalid choice. Skipping PATH setup"
            ;;
    esac
}

# Create example roadmap template
create_roadmap_template() {
    log_info "Creating roadmap template..."
    
    if [[ -f "roadmap.md" ]]; then
        log_warning "roadmap.md already exists, skipping template creation"
        return
    fi
    
    cat > roadmap.md << 'EOF'
# Project Roadmap

## Overview
<!-- Brief description of the project and its goals -->

## Current Status
- [ ] Project initialization
- [ ] Core architecture planning
- [ ] Initial implementation

## Planned Features

### Phase 1: Foundation
- [ ] Feature A
- [ ] Feature B
- [ ] Feature C

### Phase 2: Core Functionality  
- [ ] Feature D
- [ ] Feature E
- [ ] Integration tests

### Phase 3: Polish & Launch
- [ ] UI improvements
- [ ] Documentation
- [ ] Performance optimization

## Task Ideas for Multi-Claude Development

### Independent Tasks (Suitable for parallel development)
- [ ] `mcc new user-auth` - User authentication system
- [ ] `mcc new api-endpoints` - REST API development  
- [ ] `mcc new frontend-ui` - UI components
- [ ] `mcc new database-schema` - Database design
- [ ] `mcc new test-suite` - Comprehensive testing
- [ ] `mcc new documentation` - Project documentation

### Sequential Tasks (Require coordination)
- [ ] Core architecture (complete first)
- [ ] Integration layer (depends on architecture)
- [ ] End-to-end testing (needs completed features)

## Notes
<!-- Add planning notes, decisions, and architecture thoughts here -->

## Multi-Claude Workflow Tips

1. **Start Independent Tasks First**: Use `mcc new <task>` for features that can be developed in isolation
2. **Use Handoffs**: Run `mcc handoff <task> "message"` to save context when switching or pausing work
3. **Coordinate Dependencies**: Plan task order to minimize merge conflicts
4. **Regular Status checks**: Use `mcc status` to see overview of all active work
5. **Clean Merges**: Complete tasks with `mcc done <task>` when ready

## Task Templates

### New Feature Template
```bash
mcc new feature-name
# Creates:
# - New branch: work/feature-name  
# - Isolated worktree
# - TASK.md file for tracking progress
# - New Terminal window with Claude Code
```

### Bug Fix Template  
```bash
mcc new fix-issue-123
# Focus the Claude instance on:
# - Understanding the bug
# - Creating reproduction test
# - Implementing fix
# - Verifying solution
```
EOF

    log_success "Created roadmap.md template"
}

# Initialize git repository if needed
init_git_repo() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo ""
        echo -e "${YELLOW}Git Repository Setup${NC}"
        echo "==================="
        echo "No git repository found. Would you like to initialize one?"
        echo ""
        read -p "Initialize git repository? (y/n): " init_git
        
        if [[ "$init_git" =~ ^[Yy]$ ]]; then
            git init
            log_success "Initialized git repository"
            
            # Create initial commit
            git add .
            git commit -m "Initial Multi-Claude-Code setup

- Added mcc workflow management script
- Added setup.sh installer  
- Added roadmap.md template
- Ready for multi-Claude development"
            
            log_success "Created initial commit"
        else
            log_info "Skipping git initialization"
            log_warning "Note: mcc requires a git repository to function"
        fi
    else
        log_success "Git repository already initialized"
    fi
}

# Create .gitignore if needed
create_gitignore() {
    if [[ ! -f ".gitignore" ]]; then
        log_info "Creating .gitignore..."
        
        cat > .gitignore << 'EOF'
# Multi-Claude-Code
.mcc/

# macOS
.DS_Store
.AppleDouble
.LSOverride

# IDE
.vscode/
.idea/
*.swp
*.swo

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
.env

# Logs
logs
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Build outputs
dist/
build/
*.tar.gz

# Temporary files
tmp/
temp/
*.tmp
*.temp
EOF
        
        log_success "Created .gitignore"
    else
        log_info ".gitignore already exists"
    fi
}

# Display completion message and next steps
show_completion() {
    echo ""
    echo -e "${GREEN}"
    cat << 'EOF'
  ____       _               ____                      _      _       _ 
 / ___|  ___| |_ _   _ _ __  / ___|___  _ __ ___  _ __ | | ___| |_ ___| |
 \___ \ / _ \ __| | | | '_ \| |   / _ \| '_ ` _ \| '_ \| |/ _ \ __/ _ \ |
  ___) |  __/ |_| |_| | |_) | |__| (_) | | | | | | |_) | |  __/ ||  __/_|
 |____/ \___|\__|\__,_| .__/ \____\___/|_| |_| |_| .__/|_|\___|\__\___(_)
                      |_|                        |_|                    
EOF
    echo -e "${NC}"
    
    echo -e "${CYAN}Multi-Claude-Code Setup Complete!${NC}"
    echo "=================================="
    echo ""
    echo -e "${PURPLE}Next Steps:${NC}"
    echo "1. Review and customize roadmap.md for your project"
    echo "2. Start your first task: $(which mcc >/dev/null && echo 'mcc' || echo './mcc') new <task-name>"
    echo "3. Check status anytime: $(which mcc >/dev/null && echo 'mcc' || echo './mcc') status"
    echo ""
    echo -e "${PURPLE}Quick Start Example:${NC}"
    echo "  $(which mcc >/dev/null && echo 'mcc' || echo './mcc') new auth-system     # Start new authentication task"
    echo "  $(which mcc >/dev/null && echo 'mcc' || echo './mcc') list              # See active tasks"  
    echo "  $(which mcc >/dev/null && echo 'mcc' || echo './mcc') handoff auth-system 'Login working'  # Save progress"
    echo "  $(which mcc >/dev/null && echo 'mcc' || echo './mcc') done auth-system   # Complete and merge"
    echo ""
    echo -e "${PURPLE}Key Features:${NC}"
    echo "  ✅ Git worktree isolation for parallel development"
    echo "  ✅ Automatic Terminal window management"  
    echo "  ✅ Task tracking with TASK.md files"
    echo "  ✅ Context handoff between Claude instances"
    echo "  ✅ Clean merge and cleanup workflow"
    echo ""
    echo -e "${YELLOW}Need Help?${NC}"
    echo "  $(which mcc >/dev/null && echo 'mcc' || echo './mcc') help               # Show all commands"
    echo "  Read README.md for detailed documentation"
    echo ""
    echo -e "${GREEN}Happy Multi-Claude Development! 🚀${NC}"
}

# Main setup function
main() {
    print_header
    
    echo "Setting up Multi-Claude-Code workflow system..."
    echo ""
    
    check_prerequisites
    setup_executable
    create_roadmap_template
    create_gitignore
    init_git_repo
    setup_path
    
    show_completion
}

# Run setup
main "$@"