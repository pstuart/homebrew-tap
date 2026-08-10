class Barista < Formula
  desc "Modular shell statusline for Claude Code CLI"
  homepage "https://github.com/pstuart/Barista"
  url "https://github.com/pstuart/Barista/archive/f7693f71c673e003a9f3d9df0a4c741b6f4181ad.tar.gz"
  version "1.8.0"
  sha256 "7cd24527ec4d4c1306af70af9485ea1db73599c4d62e1e487e68bd53fe858109"
  license "MIT"
  head "https://github.com/pstuart/Barista.git", branch: "main"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on "jq"
  depends_on "bc" => :recommended

  def install
    libexec.install "barista.sh"
    libexec.install "barista.conf"
    libexec.install "VERSION"
    libexec.install "modules"
    libexec.install "lib"

    # Wrapper on PATH for `barista config` / `barista version`
    (bin/"barista").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/barista.sh" "$@"
    EOS
    chmod 0755, bin/"barista"
  end

  def caveats
    <<~EOS
      Barista ships as a Claude Code statusLine command.

      1. Set statusLine.command in ~/.claude/settings.json to:
           #{opt_libexec}/barista.sh

         The opt path follows brew upgrades automatically.

      2. Reconfigure modules/theme anytime:
           barista config

      3. The upstream install.sh is for from-source installations only.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/barista version")
    assert_match "config", shell_output("#{bin}/barista help")
    (testpath/"input.json").write <<~EOS
      {"cwd":"#{testpath}","model":{"display_name":"Test"},"context_window":{"used_percentage":5}}
    EOS
    # statusline render should exit 0
    system "bash", "-c", "#{bin}/barista < #{testpath}/input.json >/dev/null"
  end
end
