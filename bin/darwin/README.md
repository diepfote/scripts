# Darwin scripts for PATH variable

## brew

Did you ever want to this in brew?

```
pacman -Qii <pkg-name> 2>&1 | grep -E '^Required By|^Optional For'
```


[brew-required-by](./brew-required-by) provides this functionality: 

```
brew required-by <pkg-name>
```
