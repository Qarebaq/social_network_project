# views/ — QML UI

## Structure

```
views/
  run_qml_preview.py       # launch just the UI, no backend needed yet
  qml/
    App.qml                # real entry point: window + StackView(Login <-> Dashboard)
    designsystem/           # tokens only — colors, spacing, type, icon registry
      Colors.qml            # (was empty) filled in from the login screen's palette
      Layout.qml             # sizes/spacing/radius — already existed, untouched
      Typography.qml         # (new) font scale, matches "Segoe UI" used everywhere
      Icons.qml              # (was empty) icon name registry + text fallback glyphs
    components/              # reusable widgets — read tokens, render pixels
      Btn.qml                 # fixed (see PDF) — primary/secondary/ghost/danger button
      AppIcon.qml             # (new) renders an icon by name from designsystem/Icons
      AppTextField.qml, AppComboBox.qml, Card.qml, IconButton.qml,
      SectionHeader.qml, StatChip.qml, EmptyState.qml
    pages/
      LoginPage.qml           # = old Main.qml, structurally unchanged, now embeddable
      DashboardPage.qml       # NEW — the screen after login
```

## What changed vs. what you had

- `Colors.qml`, `Icons.qml`, `Btn.qml` were empty or broken — filled in / fixed.
  Full list of concrete bugs and fixes is in the Persian PDF for the group.
- `Main.qml` was both the window *and* the login screen in one file, so there
  was no way to ever show a second screen. It's now `pages/LoginPage.qml`
  (an embeddable `Item` that emits `loginSucceeded()`), and `App.qml` is the
  real window that switches between pages with a `StackView`. No visual or
  behavioral change to the login screen itself.

## Try it

```
cd views
pip install PySide6
python run_qml_preview.py
```

Log in with `admin` / `1234` (the same demo credentials already in the
login screen) to see it transition into the new dashboard.

## Not done yet

`DashboardPage.qml` currently renders mock data (clearly marked
`--- MOCK DATA ---` near the top of the file). Wiring it to the real
`MainController` / `GraphFacade` is the next step — see the PDF,
"Controller wiring" section, for two ways to do that.
