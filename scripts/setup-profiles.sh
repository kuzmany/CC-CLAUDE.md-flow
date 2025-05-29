#!/bin/bash
# CC CLAUDE.md Flow - Quick Setup Script
# This script sets up the profile system for autonomous AI collaboration

echo "═══════════════════════════════════════════════════════════════"
echo "   CC CLAUDE.md Flow - Profile System Setup"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Function to check if running in WSL
is_wsl() {
    if grep -qi microsoft /proc/version; then
        return 0
    else
        return 1
    fi
}

# Detect the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Set profile paths
if is_wsl; then
    echo "✓ Detected WSL environment"
    # Convert to Windows path if in WSL
    WIN_PATH=$(wslpath -w "$PROJECT_ROOT")
    PROFILES_DIR="$PROJECT_ROOT/profiles"
else
    echo "✓ Detected native Linux/Mac environment"
    PROFILES_DIR="$PROJECT_ROOT/profiles"
fi

# Check if profiles exist
if [ ! -d "$PROFILES_DIR" ]; then
    echo "✗ Error: Profiles directory not found at $PROFILES_DIR"
    echo "  Please ensure you're running this from the project root"
    exit 1
fi

# Create Claude config directory if it doesn't exist
CLAUDE_CONFIG_DIR="$HOME/.claude"
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    echo "→ Creating Claude config directory..."
    mkdir -p "$CLAUDE_CONFIG_DIR"
fi

# Create the profile switcher script
echo "→ Creating profile switcher script..."
cat > "$HOME/claude-profile" << 'EOF'
#!/bin/bash
# Claude Profile Switcher

PROFILES_DIR="PLACEHOLDER_PROFILES_DIR"

case $1 in
    master)
        cp "$PROFILES_DIR/CLAUDE_md_master_FINAL_2025-05-26.md" ~/.claude/CLAUDE.md
        echo "✅ Profile switched to: Master (Universal coordinator)"
        ;;
    task)
        cp "$PROFILES_DIR/CLAUDE_md_TASK_WORKFLOW_ORCHESTRATOR_2025-05-26.md" ~/.claude/CLAUDE.md
        echo "✅ Profile switched to: Task & Workflow Orchestrator"
        ;;
    search)
        cp "$PROFILES_DIR/CLAUDE_md_WEB_SEARCH_MASTER_2025-05-26_14-53-32.md" ~/.claude/CLAUDE.md
        echo "✅ Profile switched to: Web Search Master"
        ;;
    coding)
        cp "$PROFILES_DIR/CLAUDE_md_CODING_EXPERT_2025-05-27_22-33-32.md" ~/.claude/CLAUDE.md
        echo "✅ Profile switched to: Professional Coding Expert"
        ;;
    data)
        cp "$PROFILES_DIR/CLAUDE_md_DATA_SCIENCE_2025-05-27_223-30-16.md" ~/.claude/CLAUDE.md
        echo "✅ Profile switched to: Data Science & Analytics"
        ;;
    current)
        if [ -f ~/.claude/CLAUDE.md ]; then
            CURRENT=$(head -20 ~/.claude/CLAUDE.md | grep "PRIMÁRNY ÚČEL" -A 1 | tail -1)
            echo "📍 Current profile: $CURRENT"
        else
            echo "❌ No profile currently set"
        fi
        ;;
    *)
        echo "Usage: claude-profile {master|task|search|coding|data|current}"
        echo ""
        echo "Profiles:"
        echo "  master  - Universal coordinator"
        echo "  task    - Project management & planning"
        echo "  search  - Research & information gathering"
        echo "  coding  - Professional development"
        echo "  data    - Analytics & insights"
        echo "  current - Show active profile"
        ;;
esac
EOF

# Replace placeholder with actual path
sed -i "s|PLACEHOLDER_PROFILES_DIR|$PROFILES_DIR|g" "$HOME/claude-profile"

# Make it executable
chmod +x "$HOME/claude-profile"

# Add aliases to bashrc if not already present
if ! grep -q "# Claude Profile System Aliases" "$HOME/.bashrc"; then
    echo "→ Adding aliases to .bashrc..."
    cat >> "$HOME/.bashrc" << 'EOF'

# Claude Profile System Aliases
alias master='claude-profile master'
alias task='claude-profile task'
alias search='claude-profile search'
alias coding='claude-profile coding'
alias data='claude-profile data'
alias current='claude-profile current'

# Quick workflow commands
alias claude-flow='claude --dangerously-skip-permissions'
alias cf='claude-flow'  # Even shorter alias
EOF
fi

# Set master as default profile
echo "→ Setting Master as default profile..."
"$HOME/claude-profile" master

# Final instructions
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✅ Setup Complete!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "🎯 Quick Start:"
echo "   1. Reload your shell: source ~/.bashrc"
echo "   2. Start Claude: claude --dangerously-skip-permissions"
echo "   3. Give it any task and watch the magic!"
echo ""
echo "📋 Available Commands:"
echo "   master  - Switch to Master profile"
echo "   task    - Switch to Task profile"
echo "   search  - Switch to Search profile"
echo "   coding  - Switch to Coding profile"
echo "   data    - Switch to Data profile"
echo "   current - Show active profile"
echo ""
echo "⚡ Pro tip: Use 'cf' as shortcut for 'claude --dangerously-skip-permissions'"
echo ""
echo "Ready to boost your productivity 5x? Let's go! 🚀"
echo "═══════════════════════════════════════════════════════════════"
