# zotero

## Troubleshooting

### Google Docs integration doesn't work

If you are experiencing issues with the Google Docs integration in Zotero, try relaunching
Chromium in XWayland:

```
$ chromium --ozone-platform=x11 --enable-features=UseOzonePlatform
```

This time, an OAuth2 window should pop up when you press the Zotero button.
Afterwards, you can relaunch Chromium normally. It should still work.
