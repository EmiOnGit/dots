
try {
  cargo install --root "./plugins" nu_plugin_highlight 
} catch {
  echo "error can be ignored."
  
}
register "./plugins/bin/nu_plugin_highlight"
