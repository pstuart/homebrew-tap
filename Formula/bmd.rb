class Bmd < Formula
  desc "Better Markdown CLI - export and preview markdown files"
  homepage "https://github.com/pstuart/better-markdown"
  url "https://github.com/pstuart/homebrew-tap/releases/download/bmd-v1.0.0/bmd-v1.0.0.tar.gz"
  sha256 "3f6d305ddcc77ccf9a8f3ab54d08d300f6e625b4ba92bf5fce5283eae2bd3d1c"
  license :cannot_represent
  version "1.0.0"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  livecheck do
    url :homepage
    regex(%r{href=.*?/releases/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  def install
    # Archive layout: bmd-dist/bmd + bmd-dist/Frameworks/BetterMarkdownKit.framework
    libexec.mkpath
    (libexec/"Frameworks").mkpath

    bin.install "bmd-dist/bmd" => "bmd"
    (libexec/"Frameworks").install "bmd-dist/Frameworks/BetterMarkdownKit.framework"

    # Prefer baked rpath from release-archive.sh; re-apply if still @rpath.
    framework_path = "@executable_path/../libexec/Frameworks/BetterMarkdownKit.framework/Versions/A/BetterMarkdownKit"
    system "install_name_tool", "-change",
           "@rpath/BetterMarkdownKit.framework/Versions/A/BetterMarkdownKit",
           framework_path,
           bin/"bmd"
    system "codesign", "--force", "--sign", "-", "--timestamp=none", bin/"bmd"
  end

  def caveats
    <<~EOS
      The bmd release tarball is hosted on the private pstuart/better-markdown
      repository. Install requires a GitHub token with access to that repo:

        export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)

      Binary is Apple Silicon (arm64) only.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bmd --version")
    system bin/"bmd", "--help"
  end
end
