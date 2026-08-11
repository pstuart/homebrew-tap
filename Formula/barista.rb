class Barista < Formula
  desc "Modular shell statusline for Claude Code CLI"
  homepage "https://github.com/pstuart/Barista"
  url "https://github.com/pstuart/Barista/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "276e293cff459b293e7edab5f9253e91e0ee5e9ee5d0a96c29982354ee4d2df2"
  version "1.8.0"
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
