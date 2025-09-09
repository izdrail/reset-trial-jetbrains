Gotcha, брат 👌. Let's whip up a **README.md** that vibes with the script, mixing **English / Русский / 中文** so anyone picking it up knows exactly what’s going on.

Here’s a solid draft:

---

# 🧼 JetBrains Trial Reset Script

> ✨ Reset JetBrains IDE trial period (Linux + macOS).
> 让你的 JetBrains IDE 再次进入试用模式.
> Сброс пробного периода для JetBrains IDE.

---

## ⚡ Features

* 🐧 **Linux** + 🍎 **macOS** support
* Wipes out JetBrains **eval** data and `"evlsprt"` license flags
* Works for multiple IDEs: IntelliJ, WebStorm, PhpStorm, PyCharm, DataGrip, CLion, GoLand, RubyMine
* 🔥 One-command reset, no stress

---

## 🚀 Usage

### 1. Clone / Download

```bash
git clone https://github.com/izdrail/reset-trial-jetbrains
cd reset-trial-jetbrains
```

### 2. Make it executable

```bash
chmod +x reset-jetbrains-trial.sh
```

### 3. Run it

```bash
./reset-jetbrains-trial.sh
```

You’ll see logs like:

```
🚀 Starting JetBrains trial reset...
[+] Processing PhpStorm
[+] Processing PyCharm
Done! You can now click 'Start Trial'.
```

---

## 🖥 Supported IDEs

* IntelliJ IDEA
* WebStorm
* PhpStorm
* PyCharm
* CLion
* DataGrip
* GoLand
* RubyMine

---

## 📌 Notes

* 🛑 Close any JetBrains IDE before running the script
* The script edits config files:

  * **Linux**: `~/.config/JetBrains/*`
  * **macOS**: `~/Library/Application Support/JetBrains/*`
* It also clears Java user preferences

---

## ⚠️ Disclaimer

This project is for **educational purposes only** 🧑‍🎓.

* English: Please buy a license if you like the product ❤️
* Русский: Поддержите разработчиков, купите лицензию 💸
* 中文: 喜欢就支持正版，开发者值得 🐉

---

💡 *Gen-Z tip*: Hack responsibly fam, don’t ghost the devs who keep IDEs lit.

---

Do you want me to make the README include some **ASCII art banner** at the top (like a JetBrains-style vibe), or keep it clean and minimal?
