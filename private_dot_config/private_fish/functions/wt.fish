function wt
    set BRANCH $argv[1]
    set MAIN_REPO /Users/jonathanyan/Developer/staging
    set WORKTREE_PATH "../$BRANCH"

    if test -z "$BRANCH"
        echo ""
        echo "Usage: wt <branch-name>"
        echo ""
        echo "Examples:"
        echo "  wt feature/my-branch         → creates new branch + worktree (off current HEAD)"
        echo "  wt feature/existing          → checks out existing branch + worktree"
        echo "  wt feature/my-branch --link  → symlink node_modules instead of yarn install"
        echo ""
        echo "What it does:"
        echo "  1. Creates or checks out worktree at ../<branch-name>"
        echo "  2. Copies .env from $MAIN_REPO"
        echo "  3. Runs yarn install in background (or symlinks node_modules with --link)"
        echo "  4. Copies generated files from main (skips yarn generate)"
        echo ""
        echo "If you used --link and later need a real install: run 'wt-install'"
        echo ""
        return 1
    end

    # 1. Create/checkout worktree
    if git show-ref --verify --quiet "refs/heads/$BRANCH" || git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"
        git worktree add "$WORKTREE_PATH" "$BRANCH"
        echo "✓ Checked out existing branch: $BRANCH"
    else
        git worktree add -b "$BRANCH" "$WORKTREE_PATH"
        echo "✓ Created new branch: $BRANCH"
    end

    # 2. Copy .env
    cp "$MAIN_REPO/.env" "$WORKTREE_PATH/.env"
    echo "✓ Copied .env"

    # 3. node_modules — symlink if --link passed and lockfiles match; else yarn install in background
    if contains -- --link $argv
        if diff -q "$MAIN_REPO/yarn.lock" "$WORKTREE_PATH/yarn.lock" > /dev/null 2>&1
            ln -s "$MAIN_REPO/node_modules" "$WORKTREE_PATH/node_modules"
            echo "✓ Symlinked node_modules (run 'wt-install' to unlink and do a real install)"
        else
            echo "⚠ yarn.lock differs — running yarn install in background (ignoring --link)"
            set wt_abs (realpath $WORKTREE_PATH)
            fish -c "cd $wt_abs && yarn install" &
            disown
            echo "✓ yarn install started in background"
        end
    else
        echo "→ Running yarn install in background..."
        set wt_abs (realpath $WORKTREE_PATH)
        fish -c "cd $wt_abs && yarn install" &
        disown
        echo "✓ yarn install started in background"
    end

    # 4. Copy generated files (avoids running yarn generate)
    set generated_dirs \
        "apps/pms/web/src/generated" \
        "apps/patientApp/webV2/src/generated" \
        "apps/zendesk-widget/ui/src/generated" \
        "api/src/generated" \
        "packages/frontend/shared/src/generated" \
        "packages/theme/src/generated" \
        "packages/zenstack/migration-files/zenstack-enhancer" \
        "packages/zenstack/migration-files/client/dist" \
        "packages/zenstack/migration-files/typegraphql/dist" \
        "packages/zenstack/migration-files/masked-client"

    for dir in $generated_dirs
        if test -d "$MAIN_REPO/$dir"
            mkdir -p (dirname "$WORKTREE_PATH/$dir")
            cp -r "$MAIN_REPO/$dir" "$WORKTREE_PATH/$dir"
        end
    end

    # Copy generated schema files
    for f in "api/schema.graphql" "packages/graphql/src/generated.graphql"
        if test -f "$MAIN_REPO/$f"
            cp "$MAIN_REPO/$f" "$WORKTREE_PATH/$f"
        end
    end

    # Copy patient API schema files
    if test -d "$MAIN_REPO/apps/patientApp/api/src/graphql"
        for f in $MAIN_REPO/apps/patientApp/api/src/graphql/*.schema.graphql
            if test -f $f
                cp $f "$WORKTREE_PATH/apps/patientApp/api/src/graphql/"
            end
        end
    end

    echo "✓ Copied generated files"
    cd $WORKTREE_PATH
end
