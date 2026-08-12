class Bmd < Formula
  desc "Better Markdown CLI - export and preview markdown files"
  homepage "https://github.com/pstuart/homebrew-tap"
  url "https://github.com/pstuart/homebrew-tap/releases/download/bmd-v1.0.0/bmd-v1.0.0.tar.gz"
  sha256 "3f6d305ddcc77ccf9a8f3ab54d08d300f6e625b4ba92bf5fce5283eae2bd3d1c"
  license :cannot_represent

  livecheck do
    url "https://github.com/pstuart/homebrew-tap/releases"
    regex(%r{href=.*?/releases/tag/bmd-v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia_or_later

  def install
    # Homebrew strips the archive's single bmd-dist top-level directory.
    libexec.mkpath
    (libexec/"Frameworks").mkpath

    bin.install "bmd"
    (libexec/"Frameworks").install "Frameworks/BetterMarkdownKit.framework"

    # Prefer the path baked by release-archive.sh; repair legacy assets only.
    old_framework_path = "@rpath/BetterMarkdownKit.framework/Versions/A/BetterMarkdownKit"
    framework_path = "@executable_path/../libexec/Frameworks/BetterMarkdownKit.framework/Versions/A/BetterMarkdownKit"
    linked_libraries = (bin/"bmd").dynamically_linked_libraries(resolve_variable_references: false)
    if linked_libraries.include?(old_framework_path)
      (bin/"bmd").change_install_name(old_framework_path, framework_path)
      system "codesign", "--force", "--sign", "-", "--timestamp=none", bin/"bmd"
    end
  end

  def caveats
    <<~EOS
      The public release asset contains an Apple Silicon (arm64) binary.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bmd --version")
    system bin/"bmd", "--help"
  end
end
