for fl in $(fd flake.nix .); do
    wdir=$(dirname "$fl")
    printf "parsing: %s\n" "$wdir"
    if gum confirm "Proceed with $wdir?"; then
        cd "$wdir" || exit
        if [ -n "$(git status --porcelain)" ]; then
            printf "There are uncommited changes in %s\n" "$wdir"
            continue
        fi

        if [ -f "Cargo.toml" ]; then
            if gum confirm "This looks like a Rust project. Update Rust dependencies?"; then
                cargo update
            fi
        fi

        if [ -f "go.mod" ]; then
            if gum confirm "This looks like a go project. Update go dependencies?"; then
                go get -u
                go mod tidy
            fi

            if gum confirm "Do you maintain a scripts/vendor_hash.sh? Run it to update vendor hash?"; then
               ./scripts/vendor_hash --update
            fi
        fi

        nix flake update
        if gum confirm "Commit and push $wdir?"; then
            git commit -am "Update"
            git push
        fi

        cd ..
        printf "%s updated\n" "$wdir"
    fi
done
