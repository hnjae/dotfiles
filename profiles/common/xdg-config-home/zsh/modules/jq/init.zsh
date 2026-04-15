if (( ! $+commands[jq] )); then
    return
fi

# # NOTE: https://gist.github.com/rene-d/9e584a7dd2935d0f461904b9f2950007
# # https://stackoverflow.com/questions/51338701/how-do-i-customize-the-colors-used-by-jq-c
# JQ_COLORS = builtins.concatStringsSep ":" [
#   # "0;63" # null
#   "0;90" # null # default: 90
#   "0;33:0;33:0;33" # false/true/numbers
#   "0;32" # strings
#   "0;39:0;39" # arrays/objects # default: 1:39
#   "0;34" # object keys
# ];

export JQ_COLORS="0;90:0;33:0;33:0;33:0;32:0;39:0;39:0;34"
