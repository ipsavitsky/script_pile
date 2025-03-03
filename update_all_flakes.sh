for fl in $(fd flake.nix .); do
    wdir=$(dirname "$fl")
    printf "parsing: %s\n" "$wdir"
    if gum confirm "Proceed with $wdir?"; then
        cd "$wdir" || exit
        nix flake update
        cd ..
        printf "%s updated, don't forget to check build and commit\n" "$wdir"
    fi
done
