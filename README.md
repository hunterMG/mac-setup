# Mac Setup

Use Mac like a pro.

This guide is designed for both geeks and non-geeks, so certain sections may be detailed, but it remains worth reading.

Create an issue if you have any suggestions.

Icon meanings:
- 🤫: personal opinion

## 🎯 TL;DR

Install ChatGPT and Codex (or any other reliable AI assistants), then have them set up your Mac for you.

Use ChatGPT to answer your questions and Codex to perform actions.

### ‼️ Warning

LLMs can make mistakes, so do not click "confirm/allow" if you are not confident about the output and commands of agents.

Traditional style settings are listed below:

## 🛠️ Must have applications

### [Homebrew](https://brew.sh/)
The Missing Package Manager for macOS (or Linux). Install your familiar software with a single command.

Open `Terminal.app` and run the following command to install Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installing multiple software packages via Homebrew, you can run the following command daily to upgrade all of them.
```bash
brew update && brew upgrade
```

Useful brew aliases:
```bash
alias b="brew"
alias bic="brew install --cask"
alias bs="brew search"
bu() {
    # 1. Get all outdated items and filter out the specific ones
    local outdated_items
    # add cask names to the grep -v pattern to exclude them from the upgrade list
    outdated_items=$(brew outdated | grep -E -v "gimp|inkscape|xnconvert|bluestacks")

    # 2. Check if the list is empty
    if [ -n "$outdated_items" ]; then
        echo "Upgrading the following items:"
        echo "$outdated_items"
        
        # 3. Use xargs to pass the filtered list to brew upgrade
        echo $outdated_items | xargs brew upgrade
    else
        echo "No items to upgrade (excluding [gimp|inkscape|xnconvert])."
    fi
}
```

### [Raycast](https://www.raycast.com/)
A collection of powerful productivity tools all within an extendable launcher. Fast, ergonomic and reliable.

```bash
brew install --cask raycast
```

🤫 If you're not a geek, Raycast is recommended over Alfred.

### [Alfred](https://www.alfredapp.com/)
An award-winning app for macOS which boosts your efficiency with hotkeys, keywords, text expansion and more. Search your Mac and the web, and be more productive with custom actions to control your Mac.

```bash
brew install --cask alfred
```

🤫 It's very recommended to buy its [powerpack](https://www.alfredapp.com/powerpack/) to use [Alfred workflows](https://www.alfredapp.com/workflows/).

### [Snipaste](https://www.snipaste.com/)
A simple but powerful snipping tool that allows you to pin screenshots back onto the screen.

```bash
brew install --cask snipaste
```

### [Pixpin](https://pixpin.cn/)
A versatile screenshot tool with scroll capture, GIF recording and OCR text recognition.

```bash
brew install --cask pixpin
```

🤫 I only use its scroll capture feature.

### [Aldente](https://apphousekitchen.com/)
The all-in-one charge limiter app for your MacBook to maximize battery health.

```bash
brew install --cask aldente
```

### [KeyClu](https://sergii.tatarenkov.name/keyclu/support/)
A simple and handy overview of all shortcuts for any application on macOS.

```bash
brew install --cask keyclu
```

### [ShowyEdge](https://showyedge.pqrs.org/)
A visible indicator of the current input source displayed as a color bar at the top edge of the screen.

```bash
brew install --cask showyedge
```

### [IINA](https://iina.io/)
The modern media player for macOS, based on mpv.

```bash
brew install --cask iina
```

## 📟 Terminal

### [iTerm2](https://iterm2.com/)
A terminal emulator for macOS that does amazing things — split panes, search, autocomplete, and more.

```bash
brew install --cask iterm2
```

## Optional

### Stats / iStatMenus
1. [Stats](https://mac-stats.com/) 

   A free, open-source macOS system monitor that lives in your menu bar — track CPU, GPU, RAM, disk, network and more.

   ```bash
   brew install --cask stats
   ```

2. [iStatMenus](https://bjango.com/mac/istatmenus/)

   The most powerful system monitoring app for macOS, right in your menubar.

   ```bash
   brew install --cask istat-menus
   ```
