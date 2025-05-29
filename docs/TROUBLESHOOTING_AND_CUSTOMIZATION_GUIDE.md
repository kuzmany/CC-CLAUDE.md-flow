# 🔧 Claude Profile System - Troubleshooting & Customization Guide

> **Máte problémy s prepínaním profilov? Tento dokument vám pomôže!**

---

## 🚨 Najčastejšie Problémy a Riešenia

### 1. ❌ "bash: alias: invalid alias name"

**Symptóm:**
```bash
-bash: alias: '/master': invalid alias name
-bash: alias: '/search': invalid alias name
```

**Príčina:** Aliasy v bash nemôžu začínať lomítkom.

**Riešenie:**
1. Otvorte `~/.bashrc`
2. Nájdite sekciu s aliasmi
3. Odstráňte lomítka:
   ```bash
   # Zlé ❌
   alias /master='python3 ...'
   
   # Správne ✅
   alias master='python3 ...'
   ```
4. Reloadnite: `source ~/.bashrc`

---

### 2. ❌ "Profil sa neprepol"

**Symptóm:** Python skript hlási úspech, ale Claude stále používa starý profil.

**Príčina:** Claude Code cachuje CLAUDE.md pri štarte relácie.

**Riešenie:**
1. **Overte správnu cestu:**
   ```bash
   ls -la ~/.claude/CLAUDE.md  # Správne ✅
   ls -la ~/CLAUDE.md          # Nesprávne ❌
   ```

2. **Reštartujte Claude Code:**
   - Ukončite aktuálnu reláciu
   - Spustite znova: `claude --continue`

3. **Overte prepnutie:**
   ```bash
   head -20 ~/.claude/CLAUDE.md | grep "PRIMÁRNY ÚČEL"
   ```

---

### 3. ❌ "No such file or directory"

**Symptóm:** Skript nemôže nájsť profily.

**Riešenie - Prispôsobte cesty:**

1. **Nájdite kde máte profily:**
   ```bash
   find ~ -name "CLAUDE_md_master*.md" 2>/dev/null
   ```

2. **Upravte Python skript** (`claude_profile_switch.py`):
   ```python
   # Zmeňte túto cestu na vašu:
   PROFILES_DIR = "/cesta/k/vašim/profilom"
   ```

3. **Alebo použite environment variable:**
   ```bash
   export CLAUDE_PROFILES_DIR="/cesta/k/profilom"
   ```

---

## 🎯 Ako Prispôsobiť Pre Váš Systém

### Krok 1: Identifikujte Vaše Prostredie

```bash
# Zistite vaše username
echo $USER

# Zistite cestu k Claude config
echo ~/.claude/

# Zistite či používate WSL
uname -a | grep -i microsoft
```

### Krok 2: Upravte Cesty

**Pre Windows (WSL):**
```bash
# Typická štruktúra:
/mnt/c/Users/[VAŠE_MENO]/Documents/ClaudeFiles/...

# Nahraďte [VAŠE_MENO] vašim Windows username
PROFILES_DIR="/mnt/c/Users/[VAŠE_MENO]/Documents/ClaudeFiles/01_claude_code/01_CLAUDE_md/specificky_zamerane_CLAUDE_md"
```

**Pre Mac/Linux:**
```bash
# Typická štruktúra:
~/Documents/ClaudeFiles/...

# Alebo:
PROFILES_DIR="$HOME/Documents/ClaudeFiles/01_claude_code/01_CLAUDE_md/specificky_zamerane_CLAUDE_md"
```

### Krok 3: Vytvorte Setup Script

```bash
#!/bin/bash
# setup-my-profiles.sh

# 1. Nastavte VAŠU cestu k profilom
MY_PROFILES="/cesta/k/vašim/profilom"

# 2. Overte že existuje ~/.claude/
mkdir -p ~/.claude

# 3. Vytvorte Python switcher
cat > ~/claude_switch.py << 'EOF'
#!/usr/bin/env python3
import sys
import os
import shutil

# Tu dajte VAŠU cestu
PROFILES_DIR = os.environ.get('CLAUDE_PROFILES_DIR', '/default/cesta')

PROFILES = {
    'master': 'CLAUDE_md_master_FINAL_2025-05-26.md',
    'search': 'CLAUDE_md_WEB_SEARCH_MASTER_2025-05-26_14-53-32.md',
    'task': 'CLAUDE_md_TASK_WORKFLOW_ORCHESTRATOR_2025-05-26.md',
    'coding': 'CLAUDE_md_CODING_EXPERT_2025-05-27_22-33-32.md',
    'data': 'CLAUDE_md_DATA_SCIENCE_2025-05-27_223-30-16.md'
}

# ... zvyšok kódu ...
EOF

# 4. Pridajte aliasy
echo "" >> ~/.bashrc
echo "# Claude Profile Switching" >> ~/.bashrc
echo "export CLAUDE_PROFILES_DIR='$MY_PROFILES'" >> ~/.bashrc
echo "alias master='python3 ~/claude_switch.py master'" >> ~/.bashrc
echo "alias search='python3 ~/claude_switch.py search'" >> ~/.bashrc
echo "alias task='python3 ~/claude_switch.py task'" >> ~/.bashrc
echo "alias coding='python3 ~/claude_switch.py coding'" >> ~/.bashrc
echo "alias data='python3 ~/claude_switch.py data'" >> ~/.bashrc
echo "alias current='python3 ~/claude_switch.py current'" >> ~/.bashrc

# 5. Aktivujte
source ~/.bashrc
```

---

## 🔍 Diagnostické Príkazy

### Kompletná Diagnostika
```bash
# Vytvorte diagnostický script
cat > ~/diagnose-claude.sh << 'EOF'
#!/bin/bash
echo "=== Claude Profile System Diagnostika ==="
echo ""
echo "1. Systém Info:"
echo "   User: $USER"
echo "   Shell: $SHELL"
echo "   OS: $(uname -s)"
echo ""
echo "2. Claude Config:"
echo "   Config dir exists: $(test -d ~/.claude && echo "✓" || echo "✗")"
echo "   CLAUDE.md exists: $(test -f ~/.claude/CLAUDE.md && echo "✓" || echo "✗")"
echo ""
echo "3. Profily:"
if [ -n "$CLAUDE_PROFILES_DIR" ]; then
    echo "   Profiles dir: $CLAUDE_PROFILES_DIR"
    echo "   Dir exists: $(test -d "$CLAUDE_PROFILES_DIR" && echo "✓" || echo "✗")"
    if [ -d "$CLAUDE_PROFILES_DIR" ]; then
        echo "   Nájdené profily:"
        ls -1 "$CLAUDE_PROFILES_DIR"/*.md 2>/dev/null | wc -l
    fi
else
    echo "   ⚠️  CLAUDE_PROFILES_DIR nie je nastavená!"
fi
echo ""
echo "4. Aliasy:"
alias | grep -E "(master|search|task|coding|data|current)" | wc -l
echo ""
echo "5. Python:"
echo "   Python3: $(which python3)"
echo "   Version: $(python3 --version)"
EOF

chmod +x ~/diagnose-claude.sh
~/diagnose-claude.sh
```

---

## 📝 Checklist Pre Nových Používateľov

- [ ] **1. Stiahnite profily** do vašej preferovanej lokácie
- [ ] **2. Upravte cesty** v setup scripte na vaše
- [ ] **3. Skontrolujte** že máte `~/.claude/` adresár
- [ ] **4. Spustite setup** a reloadnite bashrc
- [ ] **5. Testujte** s `current` príkazom
- [ ] **6. Pri problémoch** spustite diagnostiku

---

## 💡 Pro Tipy

### Použitie Symlinkov
```bash
# Vytvorte symlink pre jednoduchší prístup
ln -s "/dlhá/cesta/k/profilom" ~/claude-profiles
```

### Git Integrácia
```bash
# Verzujte vaše profily
cd ~/claude-profiles
git init
git add *.md
git commit -m "Initial profiles"
```

### Backup Stratégia
```bash
# Automatický backup pri prepnutí
cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)
```

---

## 🆘 Kde Hľadať Pomoc

1. **GitHub Issues:** [Sem pridajte link na váš GitHub]
2. **Discord:** [Váš Discord server]
3. **Reddit:** r/ClaudeAI

### Pri Hlásení Problému Uveďte:
1. Výstup z `~/diagnose-claude.sh`
2. Verziu Claude Code: `claude --version`
3. Váš OS a shell
4. Presné chybové hlášky

---

## 🎉 Úspešná Inštalácia Vyzerá Takto:

```bash
$ current
✅ Aktuálny profil: Master (Univerzálny)

$ task
✅ Profil prepnutý na: Task & Workflow Orchestrator
   Plánovanie a organizácia projektov

$ master
✅ Profil prepnutý na: Master (Univerzálny)
   Základný profil pre všeobecné použitie
```

---

*Vytvorené pre komunitu Claude Code používateľov. Zdieľajte, upravujte, zlepšujte! 🚀*