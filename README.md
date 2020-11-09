# Zoom Link Extraction from macOS Calendars

**NOTE:** This script will not run in xcode (will give you a not enough permissions error)

Used in this bash function

```shell
function zmn() {
  val=`calendar-links| fzf | awk -F ',' '{print $2}'`
  if [ -n $val ]; then
    open $val
  else
    echo "No zoom links to open."
  fi
}
```
