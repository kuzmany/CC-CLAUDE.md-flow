#!/bin/bash
# CC CLAUDE.md Flow - Diagnostic Tool
# Helps troubleshoot common issues with the profile system

echo "═══════════════════════════════════════════════════════════════"
echo "   CC CLAUDE.md Flow - System Diagnostics"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Running comprehensive system check..."
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

# 1. System Information
echo "1. System Information"
echo "   ────────────────"
echo "   User: $USER"
echo "   Shell: $SHELL"
echo "   OS: $(uname -s)"
echo "   Architecture: $(uname -m)"

# Check if WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "   Environment: WSL"
    WSL=true
else
    echo "   Environment: Native"
    WSL=false
fi
echo ""

# 2. Claude Code Installation
echo "2. Claude Code Installation"
echo "   ────────────────────────"

# Check if claude command exists
if command -v claude &> /dev/null; then
    print_status 0 "Claude Code installed"
    echo "   Version: $(claude --version 2>/dev/null || echo 'Unable to get version')"
else
    print_status 1 "Claude Code not found in PATH"
    echo "   Install with: npm install -g @anthropic-ai/claude-code"
fi
echo ""

# 3. Profile System Check
echo "3. Profile System Configuration"
echo "   ───────────────────────────"

# Check Claude config directory
CLAUDE_CONFIG="$HOME/.claude"
if [ -d "$CLAUDE_CONFIG" ]; then
    print_status 0 "Claude config directory exists"
else
    print_status 1 "Claude config directory missing"
    echo "   Create with: mkdir -p ~/.claude"
fi

# Check if CLAUDE.md exists
if [ -f "$CLAUDE_CONFIG/CLAUDE.md" ]; then
    print_status 0 "CLAUDE.md file exists"
    # Try to detect current profile
    if grep -q "PRIMÁRNY ÚČEL" "$CLAUDE_CONFIG/CLAUDE.md" 2>/dev/null; then
        CURRENT_PROFILE=$(grep "PRIMÁRNY ÚČEL" "$CLAUDE_CONFIG/CLAUDE.md" -A 1 | tail -1)
        echo "   Current profile: $CURRENT_PROFILE"
    fi
else
    print_status 1 "CLAUDE.md file missing"
    echo "   Run setup script to initialize"
fi
echo ""

# 4. Profile Files Check
echo "4. Profile Files"
echo "   ─────────────"

# Try to find profiles directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROFILES_DIR="$(dirname "$SCRIPT_DIR")/profiles"

if [ -d "$PROFILES_DIR" ]; then
    print_status 0 "Profiles directory found"
    echo "   Location: $PROFILES_DIR"
    
    # Check individual profile files
    echo ""
    echo "   Profile files:"
    
    profiles=(
        "CLAUDE_md_master_FINAL_2025-05-26.md:Master"
        "CLAUDE_md_TASK_WORKFLOW_ORCHESTRATOR_2025-05-26.md:Task"
        "CLAUDE_md_WEB_SEARCH_MASTER_2025-05-26_14-53-32.md:Search"
        "CLAUDE_md_CODING_EXPERT_2025-05-27_22-33-32.md:Coding"
        "CLAUDE_md_DATA_SCIENCE_2025-05-27_223-30-16.md:Data"
    )
    
    for profile in "${profiles[@]}"; do
        IFS=':' read -r filename name <<< "$profile"
        if [ -f "$PROFILES_DIR/$filename" ]; then
            SIZE=$(du -h "$PROFILES_DIR/$filename" | cut -f1)
            echo -e "   ${GREEN}✓${NC} $name profile ($SIZE)"
        else
            echo -e "   ${RED}✗${NC} $name profile missing"
        fi
    done
else
    print_status 1 "Profiles directory not found"
    echo "   Expected at: $PROFILES_DIR"
fi
echo ""

# 5. Scripts and Tools
echo "5. Scripts and Tools"
echo "   ─────────────────"

# Check for profile switcher
if [ -f "$HOME/claude-profile" ]; then
    print_status 0 "Profile switcher script installed"
    if [ -x "$HOME/claude-profile" ]; then
        print_status 0 "Profile switcher is executable"
    else
        print_status 1 "Profile switcher not executable"
        echo "   Fix with: chmod +x ~/claude-profile"
    fi
else
    print_status 1 "Profile switcher not installed"
    echo "   Run setup script to install"
fi

# Check Python for advanced switcher
if command -v python3 &> /dev/null; then
    print_status 0 "Python 3 installed"
    echo "   Version: $(python3 --version)"
else
    print_warning "Python 3 not found (optional for advanced features)"
fi
echo ""

# 6. Shell Configuration
echo "6. Shell Configuration"
echo "   ──────────────────"

# Check if aliases are configured
if grep -q "# Claude Profile System Aliases" "$HOME/.bashrc" 2>/dev/null; then
    print_status 0 "Aliases configured in .bashrc"
else
    print_status 1 "Aliases not found in .bashrc"
    echo "   Run setup script to add aliases"
fi

# Check if aliases are loaded
if alias master &>/dev/null; then
    print_status 0 "Aliases loaded in current shell"
else
    print_warning "Aliases not loaded in current shell"
    echo "   Reload with: source ~/.bashrc"
fi
echo ""

# 7. Permissions Check
echo "7. Permissions"
echo "   ───────────"

# Check Claude config permissions
if [ -d "$CLAUDE_CONFIG" ]; then
    if [ -w "$CLAUDE_CONFIG" ]; then
        print_status 0 "Claude config directory writable"
    else
        print_status 1 "Claude config directory not writable"
    fi
fi

# Check if we can write to CLAUDE.md
if [ -f "$CLAUDE_CONFIG/CLAUDE.md" ]; then
    if [ -w "$CLAUDE_CONFIG/CLAUDE.md" ]; then
        print_status 0 "CLAUDE.md file writable"
    else
        print_status 1 "CLAUDE.md file not writable"
    fi
fi
echo ""

# 8. Quick Fixes
echo "8. Quick Fix Suggestions"
echo "   ────────────────────"

ISSUES=0

if ! command -v claude &> /dev/null; then
    echo "   → Install Claude Code:"
    echo "     npm install -g @anthropic-ai/claude-code"
    ((ISSUES++))
fi

if [ ! -d "$CLAUDE_CONFIG" ]; then
    echo "   → Create config directory:"
    echo "     mkdir -p ~/.claude"
    ((ISSUES++))
fi

if [ ! -f "$HOME/claude-profile" ]; then
    echo "   → Run setup script:"
    echo "     ./scripts/setup-profiles.sh"
    ((ISSUES++))
fi

if ! alias master &>/dev/null; then
    echo "   → Reload shell configuration:"
    echo "     source ~/.bashrc"
    ((ISSUES++))
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "   ${GREEN}✓${NC} No issues found! System ready to use."
fi
echo ""

# 9. Summary
echo "═══════════════════════════════════════════════════════════════"
if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ Diagnostics Complete - System Healthy${NC}"
    echo ""
    echo "Ready to use! Start with:"
    echo "  claude --dangerously-skip-permissions"
else
    echo -e "${YELLOW}⚠️  Diagnostics Complete - $ISSUES issues found${NC}"
    echo ""
    echo "Fix the issues above, then run diagnostics again."
fi
echo "═══════════════════════════════════════════════════════════════"

# Optional: Save diagnostic report
read -p "Save diagnostic report? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    REPORT_FILE="claude-diagnostics-$(date +%Y%m%d-%H%M%S).txt"
    {
        echo "CC CLAUDE.md Flow - Diagnostic Report"
        echo "Generated: $(date)"
        echo ""
        $0
    } > "$REPORT_FILE" 2>&1
    echo "Report saved to: $REPORT_FILE"
fi
