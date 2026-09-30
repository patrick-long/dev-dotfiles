# Links this repo's config folders to where Wezterm and Neovim look for them.
# Safe to re-run: existing links are skipped and real folders are backed up to *.bak

$links = @{
  "$HOME\AppData\Local\nvim" = "$PSScriptRoot\nvim"
  "$HOME\.config\wezterm" = "$PSScriptRoot\wezterm"
}

foreach ($path in $links.Keys) {
  $existing = Get-Item $path -ErrorAction SilentlyContinue

  if ($existing.LinkType -eq 'Junction') {
    Write-Host "Already linked: $path"
    continue
  }

  if ($existing) {
    Move-Item $path "$path.bak"
    Write-Host "Backed up $path to $path.bak"
  }

  $parent = Split-Path $path

  if (-not (Test-Path $parent)) {
    New-Item -ItemType Directory $parent | Out-Null
  }

  New-Item -ItemType Junction -Path $path -Target $links[$path] | Out-Null
  Write-Host "Linked $path -> $($links[$path])"
}

# Wezterm could load a leftover ~/.wezterm.lua instead of the repo copy
if (Test-Path "$HOME\.wezterm.lua") {
  Move-Item "$HOME\.wezterm.lua" "$HOME\.wezterm.lua.bak"
  Write-Host "Backed up ~/.wezterm.lua to ~/.wezterm.lua.bak"
}

