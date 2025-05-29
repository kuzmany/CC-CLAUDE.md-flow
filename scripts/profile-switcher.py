#!/usr/bin/env python3
"""
CC CLAUDE.md Flow - Profile Switcher
Advanced profile management with automatic detection and switching
"""

import os
import sys
import shutil
import json
from datetime import datetime
from pathlib import Path

class ProfileSwitcher:
    def __init__(self):
        # Detect environment
        self.is_wsl = 'microsoft' in os.uname().release.lower() if hasattr(os, 'uname') else False
        
        # Set paths
        self.script_dir = Path(__file__).parent.absolute()
        self.project_root = self.script_dir.parent
        self.profiles_dir = self.project_root / 'profiles'
        self.claude_config = Path.home() / '.claude'
        self.claude_md = self.claude_config / 'CLAUDE.md'
        
        # Profile mappings
        self.profiles = {
            'master': {
                'file': 'CLAUDE_md_master_FINAL_2025-05-26.md',
                'name': 'Master (Universal Coordinator)',
                'emoji': '🌐',
                'keywords': ['general', 'help', 'start', 'basic']
            },
            'task': {
                'file': 'CLAUDE_md_TASK_WORKFLOW_ORCHESTRATOR_2025-05-26.md',
                'name': 'Task & Workflow Orchestrator',
                'emoji': '📋',
                'keywords': ['plan', 'project', 'organize', 'workflow', 'todo']
            },
            'search': {
                'file': 'CLAUDE_md_WEB_SEARCH_MASTER_2025-05-26_14-53-32.md',
                'name': 'Web Search Master',
                'emoji': '🔍',
                'keywords': ['find', 'search', 'research', 'lookup', 'information']
            },
            'coding': {
                'file': 'CLAUDE_md_CODING_EXPERT_2025-05-27_22-33-32.md',
                'name': 'Professional Coding Expert',
                'emoji': '💻',
                'keywords': ['code', 'program', 'debug', 'implement', 'develop']
            },
            'data': {
                'file': 'CLAUDE_md_DATA_SCIENCE_2025-05-27_223-30-16.md',
                'name': 'Data Science & Analytics',
                'emoji': '📊',
                'keywords': ['analyze', 'data', 'statistics', 'graph', 'metrics']
            }
        }
        
    def ensure_claude_config(self):
        """Create Claude config directory if it doesn't exist"""
        self.claude_config.mkdir(exist_ok=True)
        
    def switch_profile(self, profile_name):
        """Switch to specified profile"""
        if profile_name not in self.profiles:
            print(f"❌ Unknown profile: {profile_name}")
            self.show_help()
            return False
            
        profile = self.profiles[profile_name]
        source_file = self.profiles_dir / profile['file']
        
        if not source_file.exists():
            print(f"❌ Profile file not found: {source_file}")
            return False
            
        try:
            # Backup current profile if exists
            if self.claude_md.exists():
                backup_name = f"CLAUDE.md.backup.{datetime.now().strftime('%Y%m%d_%H%M%S')}"
                shutil.copy2(self.claude_md, self.claude_config / backup_name)
            
            # Copy new profile
            shutil.copy2(source_file, self.claude_md)
            print(f"{profile['emoji']} Profile switched to: {profile['name']}")
            
            # Log the switch
            self.log_switch(profile_name)
            return True
            
        except Exception as e:
            print(f"❌ Error switching profile: {e}")
            return False
            
    def get_current_profile(self):
        """Detect current active profile"""
        if not self.claude_md.exists():
            return None
            
        try:
            with open(self.claude_md, 'r', encoding='utf-8') as f:
                content = f.read(1000)  # Read first 1000 chars
                
            # Check each profile
            for name, profile in self.profiles.items():
                profile_path = self.profiles_dir / profile['file']
                if profile_path.exists():
                    with open(profile_path, 'r', encoding='utf-8') as f:
                        profile_start = f.read(500)
                    if profile_start in content:
                        return name
                        
        except Exception as e:
            print(f"⚠️  Error reading current profile: {e}")
            
        return None
        
    def auto_detect_profile(self, user_input):
        """Automatically detect best profile based on user input"""
        input_lower = user_input.lower()
        scores = {}
        
        for name, profile in self.profiles.items():
            score = 0
            for keyword in profile['keywords']:
                if keyword in input_lower:
                    score += 1
            scores[name] = score
            
        # Return profile with highest score, default to master
        best_profile = max(scores.items(), key=lambda x: x[1])
        return best_profile[0] if best_profile[1] > 0 else 'master'
        
    def show_status(self):
        """Show current profile and system status"""
        print("═══════════════════════════════════════════════════════════════")
        print("   CC CLAUDE.md Flow - System Status")
        print("═══════════════════════════════════════════════════════════════")
        
        current = self.get_current_profile()
        if current:
            profile = self.profiles[current]
            print(f"📍 Current Profile: {profile['emoji']} {profile['name']}")
        else:
            print("❌ No profile currently set")
            
        print(f"📁 Profiles Directory: {self.profiles_dir}")
        print(f"⚙️  Environment: {'WSL' if self.is_wsl else 'Native'}")
        
        # Check profile files
        print("\n📋 Available Profiles:")
        for name, profile in self.profiles.items():
            file_path = self.profiles_dir / profile['file']
            status = "✅" if file_path.exists() else "❌"
            print(f"   {status} {profile['emoji']} {name}: {profile['name']}")
            
    def log_switch(self, profile_name):
        """Log profile switches for analytics"""
        log_file = self.claude_config / 'profile_switches.log'
        try:
            with open(log_file, 'a') as f:
                f.write(f"{datetime.now().isoformat()},{profile_name}\n")
        except:
            pass  # Logging is optional
            
    def show_help(self):
        """Show help information"""
        print("\nUsage: profile-switcher.py [command] [args]")
        print("\nCommands:")
        print("  switch [profile]  - Switch to specified profile")
        print("  current          - Show current profile")
        print("  status           - Show system status")
        print("  auto [text]      - Auto-detect best profile for given text")
        print("  help             - Show this help")
        print("\nProfiles:")
        for name, profile in self.profiles.items():
            print(f"  {name:8} - {profile['name']}")
            
def main():
    switcher = ProfileSwitcher()
    switcher.ensure_claude_config()
    
    if len(sys.argv) < 2:
        switcher.show_status()
        return
        
    command = sys.argv[1].lower()
    
    if command == 'switch' and len(sys.argv) >= 3:
        switcher.switch_profile(sys.argv[2])
    elif command == 'current':
        current = switcher.get_current_profile()
        if current:
            profile = switcher.profiles[current]
            print(f"{profile['emoji']} Current profile: {profile['name']}")
        else:
            print("❌ No profile currently set")
    elif command == 'status':
        switcher.show_status()
    elif command == 'auto' and len(sys.argv) >= 3:
        text = ' '.join(sys.argv[2:])
        best_profile = switcher.auto_detect_profile(text)
        print(f"🎯 Best profile for your task: {best_profile}")
        switcher.switch_profile(best_profile)
    elif command == 'help':
        switcher.show_help()
    else:
        # Direct profile name as argument
        if command in switcher.profiles:
            switcher.switch_profile(command)
        else:
            print(f"❌ Unknown command: {command}")
            switcher.show_help()

if __name__ == '__main__':
    main()
