function wt-install
    # Replace a symlinked node_modules with a real yarn install.
    # Run this inside a worktree when you need its own node_modules
    # (e.g. before running `yarn add` or changing dependencies).

    if test -L node_modules
        echo "→ Removing node_modules symlink..."
        rm node_modules
    else if test -d node_modules
        echo "node_modules already exists (not a symlink), running yarn install anyway"
    end

    yarn install
    echo "✓ node_modules installed"
end
