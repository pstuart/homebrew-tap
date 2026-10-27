# frozen_string_literal: true

class Barista < Formula
  desc "Modular shell statusline for Claude Code CLI"
  homepage "https://github.com/pstuart/Barista"
  url "https://github.com/pstuart/Barista/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "276e293cff459b293e7edab5f9253e91e0ee5e9ee5d0a96c29982354ee4d2df2"
  license "MIT"
  head "https://github.com/pstuart/Barista.git", branch: "main"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on "jq"
  uses_from_macos "bc"

  def install
    libexec.install "barista.sh", "barista.conf", "VERSION", "modules", "lib"

    # Wrapper on PATH. Do not symlink: barista.sh resolves SCRIPT_DIR from
    # BASH_SOURCE, so a bin/ symlink would look for modules next to the link.
    wrapper = bin/"barista"
    wrapper.write <<~EOS
      #!/bin/bash
      exec "#{libexec}/barista.sh" "$@"
    EOS
    wrapper.chmod 0755
  end

  def caveats
    <<~EOS
      Barista ships as a Claude Code statusLine command. Point statusLine in
      ~/.claude/settings.json at the opt path so upgrades keep working; Homebrew
      does not expand $(brew --prefix) inside JSON:

        {"statusLine": {"type": "command", "command": "#{opt_libexec}/barista.sh"}}

      Reconfigure modules/theme anytime with `barista config`. The upstream
      install.sh is for from-source installations only; update with
      `brew upgrade barista`.
    EOS
  end

  test do
    assert_path_exists libexec/"lib/config-tui.sh"
    assert_path_exists libexec/"modules/utils.sh"
    assert_path_exists libexec/"VERSION"
    assert_match version.to_s, shell_output("#{bin}/barista version")
    assert_match "config", shell_output("#{bin}/barista help")
    assert_match "Usage: barista config", shell_output("#{bin}/barista config --help")
  end
end
