![Glass](https://user-images.githubusercontent.com/3102758/90884068-9549a600-e3e1-11ea-944f-481bd894560e.png)

#### An immersive and minimalistic chat UI for World of Warcraft

## ⚔️ WotLK 3.3.5 Backport

**This is a backported version of Glass for WoW 3.3.5 (Wrath of the Lich King)**, specifically for [Ascension WoW](https://ascension.gg/).

Original addon by [mixxorz](https://github.com/mixxorz/Glass).

[![Demo](https://thumbs.gfycat.com/SkinnyPopularIsabellineshrike-size_restricted.gif)](https://gfycat.com/skinnypopularisabellineshrike)

(Click for slightly higher resolution)

## Why?

I wanted to have a chat UI that didn't look like it was designed in 2004.

I tried several addons that customize the chat interface but was left
unsatisfied. So I decided to make one myself.

The goal of Glass is to be unobtrusive. Messages only appear when they come in
and fades out after a few seconds. Chat tabs are hidden until the player hovers
over the chat UI. There is no always-visible background. Glass is invisible
until the player needs it.

## Install

### For WotLK 3.3.5 / Ascension WoW

1. Download the latest release from [GitHub Releases](https://github.com/your-repo/Glass/releases)
2. Extract the `Glass` folder to `Interface\AddOns\`
3. Restart WoW or type `/reload`

### For Retail WoW

The original Glass addon is available on [CurseForge](https://www.curseforge.com/wow/addons/glass) and [GitHub](https://github.com/mixxorz/Glass/releases)

## Commands

* `/glass` - open the settings window
* `/glass lock` - unlock the chat frame

## Customization

Not everyone likes the same look. Glass tries to accommodate your own
preferences by giving you options to change the:

* Chat frame width, height, and location
* Font and font size
* Message fade out delay
* Background opacity

Moreover, unlike the default chat UI, these settings may be shared between
characters.

## Addon compatibility

### ElvUI

Glass works with ElvUI, but make sure to disable the Chat module.

### Prat 3.0

Glass works with Prat, but make sure to disable the EditBox module.

Prat Timestamps work with Glass but with a caveat. Prat allows you to select
which tabs to enable timestamps on. This is currently not supported and
Timestamps will be enabled on all tabs if the Prat Timestamps module is loaded.
If you want to disable Prat Timestamps, you'll need to set the module to "Don't
load" (just "Disabled" won't work).

Note: WoW's built-in timestamps work with Glass. (Interface -> Social ->
Timestamps)

### Leatrix Plus

Glass works with Leatrix Plus. You might encounter issues when enabling features
that modify chat behaviour such as "Recent chat window" or "Use easy resizing".
Switching these features off will resolve issues with Glass.

## Issues and suggestions

Check the [Issue tracker](https://github.com/mixxorz/Glass/issues) on GitHub
to see if someone else has already reported your issue. If not, leave a comment
on [CurseForge](https://www.curseforge.com/wow/addons/glass).

## WotLK 3.3.5 Backport Notes

This backport includes a compatibility layer (`compat.lua`) that provides polyfills for APIs that don't exist in WotLK:

### Features that work:
- Sliding message frames with fade animations
- Custom fonts and font sizes
- Adjustable frame size and position
- Background opacity settings
- Chat tab management
- Hyperlink tooltips for items, spells, quests, achievements, talents, glyphs

### Limitations in WotLK version:
- **Indented word wrap** - Not supported (API doesn't exist)
- **Mask textures** - Visual masks are disabled (not available in 3.3.5)
- **Message history restoration** - Prat history module not supported (historyBuffer API missing)
- **Battle pets** - Obviously not applicable to WotLK

## License

MIT License

Copyright (c) 2020 Mitchel Cabuloy

WotLK 3.3.5 backport modifications are also released under MIT License.
