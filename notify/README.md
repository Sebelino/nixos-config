## Usage

```bash
systemctl --user enable dunst.service
systemctl --user status dunst.service
systemctl --user restart dunst.service
```

## Notes

You might need this in your `.xinitrc`, or else `dunst.service` will fail on start:
```
systemctl --user import-environment DISPLAY
```
