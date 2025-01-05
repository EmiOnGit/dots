if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths
set -U fish_user_paths $HOME/.local/bin $fish_user_paths
set -U fish_user_paths $HOME/.local/share/gem/ruby/3.3.0/bin $fish_user_paths
set -gx EDITOR helix
bind \cz fg
alias hx="helix"
alias say="clear && cowsay -rC"

function fish_greeting
    fortune
end
function yy
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
