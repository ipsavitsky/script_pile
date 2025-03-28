choice=$(gum choose \
  --header "What part of terraform state do you want to browse?" \
  "state" "output")

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
