choice=$(dialog --clear \
    --menu "What part of terraform state do you want to browse?" 0 0 0 \
    "state" "List terraform state" \
    "output" "List terraform outputs" \
    2>&1 >/dev/tty)

case $choice in
"state")
    bind="start:reload:tofu state list"
    preview="tofu state show {1} | bat --style=plain --color=always -l hcl"
    ;;
"output")
    bind="start:reload:tofu output -json | jq -r 'keys[]'"
    preview="tofu output {1} | bat --style=plain --color=always -l json"
    ;;
esac

fzf --ansi \
    --bind "$bind" \
    --preview "$preview"
