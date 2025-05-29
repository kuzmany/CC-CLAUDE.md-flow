# 🚀 Claude Profile System - Rýchly Štart za 5 Minút

## Žiadne dlhé čítanie - rovno k veci

Chcete mať tím AI expertov ktorí za vás dokončia akýkoľvek projekt? Tu je návod ako na to. **Reálne 5 minút a funguje to.**

---

## ✅ Čo potrebujete (checklist)

- [ ] **Windows 11** s WSL2 (máte? super)
- [ ] **Claude Code** nainštalovaný (`npm install -g @anthropic-ai/claude-code`)
- [ ] **5 profilových súborov** (link nižšie)
- [ ] **Chuť vyskúšať** niečo čo zmení ako pracujete

---

## 📁 Krok 1: Stiahnite Profile (2 min)

### Možnosť A: Lokálne súbory (ak už máte)
```bash
cd /mnt/c/Users/Jozef/OneDrive/Documents/ClaudeFiles/01_claude_code/01_CLAUDE_md/specificky_zamerane_CLAUDE_md/
ls -la CLAUDE_md_*.md
```

### Možnosť B: Skopírovať z tejto lokácie
Všetky profily sú v: `C:\Users\Jozef\OneDrive\Documents\ClaudeFiles\01_claude_code\01_CLAUDE_md\specificky_zamerane_CLAUDE_md\`

### Čo dostanete:
```
CLAUDE_md/
├── CLAUDE_md_master_FINAL_2025-05-26.md (36KB)
├── CLAUDE_md_TASK_WORKFLOW_ORCHESTRATOR_2025-05-26.md (42KB)
├── CLAUDE_md_WEB_SEARCH_MASTER_2025-05-26_14-53-32.md (38KB)
├── CLAUDE_md_CODING_EXPERT_2025-05-27_22-33-32.md (45KB)
└── CLAUDE_md_DATA_SCIENCE_2025-05-27_223-30-16.md (41KB)
```

---

## ⚙️ Krok 2: Setup Script (1 min)

Vytvorte súbor `~/setup-profiles.sh`:

```bash
#!/bin/bash
# Claude Profile System - One-time setup

# Definujte vašu cestu (upravte podľa potreby)
PROFILES_PATH="/mnt/c/Users/Jozef/OneDrive/Documents/ClaudeFiles/01_claude_code/01_CLAUDE_md/specificky_zamerane_CLAUDE_md"

# Vytvorte helper script
cat > ~/claude-profile <<'EOF'
#!/bin/bash
case $1 in
    master) cp "$PROFILES_PATH/CLAUDE_md_master_FINAL_2025-05-26.md" ~/.claude/CLAUDE.md ;;
    task) cp "$PROFILES_PATH/CLAUDE_md_TASK_WORKFLOW_ORCHESTRATOR_2025-05-26.md" ~/.claude/CLAUDE.md ;;
    search) cp "$PROFILES_PATH/CLAUDE_md_WEB_SEARCH_MASTER_2025-05-26_14-53-32.md" ~/.claude/CLAUDE.md ;;
    coding) cp "$PROFILES_PATH/CLAUDE_md_CODING_EXPERT_2025-05-27_22-33-32.md" ~/.claude/CLAUDE.md ;;
    data) cp "$PROFILES_PATH/CLAUDE_md_DATA_SCIENCE_2025-05-27_223-30-16.md" ~/.claude/CLAUDE.md ;;
    *) echo "Usage: claude-profile {master|task|search|coding|data}" ;;
esac
echo "✅ Profile switched to: $1"
EOF

# Make it executable
chmod +x ~/claude-profile

# Set master as default
~/claude-profile master

echo "✅ Claude Profile System installed!"
echo "Usage: claude-profile [master|task|search|coding|data]"
```

Spustite:
```bash
chmod +x ~/setup-profiles.sh
~/setup-profiles.sh
```

---

## 🎮 Krok 3: Prvý Test (2 min)

### Test 1: Jednoduchá úloha
```bash
claude --dangerously-skip-permissions

You: Vytvor mi TODO list aplikáciu

# Sledujte ako Claude:
# 1. Začne ako Master
# 2. Prepne na Task (plán)
# 3. Prepne na Coding (implementácia)
# 4. Vráti sa na Master (delivery)
```

### Test 2: Komplexná úloha
```bash
You: Analyzuj tieto sales dáta a vytvor stratégiu na Q2

# Sledujte orchestráciu:
# Master → Data → Task → Master
```

---

## 🔥 That's it! Máte funkčný Profile System

### Čo teraz môžete:

**Jednoduchým príkazom:**
- Vytvoriť kompletné aplikácie
- Analyzovať dáta s reportami
- Plánovať a realizovať projekty
- Automatizovať workflows
- Škálovať vašu produktivitu

**Príklady príkazov ktoré fungujú:**
```
"Vytvor e-shop pre moju firmu"
"Analyzuj tieto dáta a navrhni stratégiu"
"Oprav bugs v tomto projekte"
"Vytvor marketing plán na Q2"
"Automatizuj tento manuálny proces"
```

---

## 💡 Quick Tips pre Maximum Efektivity

### DO ✅
- **Zadávajte jasný cieľ**, nie kroky
- **Nechajte systém pracovať** - neprerušujte
- **Používajte prirodzený jazyk** - žiadne technické príkazy
- **Sledujte a učte sa** z automatických prepnutí

### DON'T ❌
- **Nemikromanažujte** profily
- **Neprerušujte** uprostred workflow
- **Nenúťte** jeden profil robiť všetko
- **Nepoužívajte** bez `--dangerously-skip-permissions`

---

## 🆘 Troubleshooting (30 sekúnd na vyriešenie)

### "Command not found"
```bash
export PATH=$PATH:~/.npm-global/bin
source ~/.bashrc
```

### "Profile sa neprepol"
```bash
current  # Zistite aktívny profil
master   # Reset na základný
```

### "Permission denied"
```bash
chmod +x ~/claude-profile
chmod 666 ~/.claude/CLAUDE.md
```

### "Cesty nefungujú"
Upravte `PROFILES_PATH` v setup scripte na vašu skutočnú cestu.

---

## 📈 Čo Ďalej?

### Level 1: Základy (tento týždeň)
- [ ] Vyskúšajte všetkých 5 profilov
- [ ] Dokončite prvý projekt
- [ ] Zmerajte úsporu času

### Level 2: Pokročilý (budúci týždeň)
- [ ] Vytvorte custom workflows
- [ ] Pridajte vlastné trigger words
- [ ] Automatizujte rutinné úlohy

### Level 3: Expert (do mesiaca)
- [ ] Vytvorte vlastné profily
- [ ] Zdieľajte s tímom
- [ ] Škálujte na celú firmu

---

## 🎉 Gratulujem!

**Za 5 minút ste získali:**
- Tím 5 AI expertov
- Automatizovaný workflow systém
- 5-10x boost produktivity
- Neobmedzené možnosti

**Váš prvý projekt čaká. Začnite teraz:**
```bash
claude --dangerously-skip-permissions
```

---

## 🔗 Užitočné Linky

- **Dokumentácia:** Súbor `Claude_Profile_System_Documentation.md` v tom istom adresári
- **Príklady:** Súbor `Profile_Workflow_Examples.md` v tom istom adresári
- **Autonómny návod:** Súbor `AUTONOMOUS_PROFILE_SWITCHING_GUIDE.md` v tom istom adresári
- **Hlavný profil:** `CLAUDE_md_master_FINAL_2025-05-26.md`

---

*5 minút setup. Lifetime productivity boost.*
*Version 1.0 | 2025-05-28*