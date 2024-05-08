if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths
# set -U fish_user_paths $HOME/.rustup $fish_user_paths
set -gx EDITOR helix
alias hx="helix"

function fish_greeting
    fortune
end
