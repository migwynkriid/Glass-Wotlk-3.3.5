# Changelog

## 1.7.0-wotlk (2026-06-18) - WotLK 3.3.5 Backport

**This is a backport of Glass to WoW 3.3.5 (Wrath of the Lich King) for Ascension WoW.**

### Backport Changes
* Added `compat.lua` compatibility layer with polyfills for missing APIs:
  - `Mixin()` function for object mixins
  - `MouseIsOver()` for cursor position checking
  - `CreateObjectPool()` for object pooling
  - `C_Timer` functions using OnUpdate frame
  - `SetColorTexture()` using white texture + SetVertexColor
  - `SOUNDKIT` constants for sound playback
  - Various no-op stubs for unsupported features
* Updated TOC for Interface 30300
* Replaced `GeneralDockManager` usage with custom dock frame
* Removed Battle.net pet tooltip support (not in WotLK)
* Removed Focus texture handling from EditBox (retail only)
* Removed `BackdropTemplate` dependency
* Removed `historyBuffer` hooks (API doesn't exist)
* Added safe checks for optional globals (BNToastFrame, ChatAlertFrame, etc.)
* Updated hyperlink types for WotLK (added talent, glyph; removed battlepet, currency)

### Known Limitations
* Indented word wrap not available (API missing)
* Mask textures disabled (not supported)
* Message history restoration not available
* Some visual effects simplified

---

## 1.7.0 (2020-09-29)

* Add line indention support

## 1.6.0 (2020-09-23)

* Refactor gradient backgrounds (#109)
* Refactor scroll overlay (#109)
* Refactor new message alert (#109)
* Refactor OnUpdate handler (#109)
* Fix GMOTD not displaying (#110)
* Add support for Prat's history module (#100)

## 1.5.0 (2020-09-14)

* Add more customization options (#107)
* Add in-game changelog (#108)

## 1.4.2 (2020-09-09)

* Fix icons not sliding up (#99)
* Fix messages not being displayed sometimes (#99)
* Fix issues with scrolling after frame resize (#99)

## 1.4.1 (2020-09-08)

* Fix AceDB issues

## 1.4.0 (2020-09-07)

* Add classic support (#95)

## 1.3.0 (2020-09-06)

* Add support for third-party chat links (#90)
* Improve scrolling behavior (#92)
* Force chatStyle to classic (#94)

## 1.2.1 (2020-09-01)

* Fix conflict with ElvUI Mover

## 1.2.0 (2020-08-31)

* Major rearchitecture (#79)
* Add support for new tab whisper mode (#80)

## 1.1.1 (2020-08-26)

* Fix text processing pipeline (#70)
* Fix jittery animations (#71)
* Fix dependency issues (#72)

## 1.1.0 (2020-08-24)

* Add "Unlock Window" option to context menu - SammyJames
* Add support for Prat timestamps

## 1.0.1 (2020-08-22)

* Fix Battle.net toast position
* Fix some icon textures being squished

## 1.0.0 (2020-08-22)

* Initial release
