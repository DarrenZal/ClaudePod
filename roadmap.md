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
