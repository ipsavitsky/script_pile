fzf --ansi \
    --bind "start:reload:tofu state list" \
    --preview "tofu state show {1} | bat --style=plain --color=always -l hcl"
