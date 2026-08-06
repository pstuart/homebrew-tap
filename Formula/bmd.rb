class Bmd < Formula
  desc "Better Markdown CLI - export and preview markdown files"
  homepage "https://github.com/pstuart/better-markdown"
  url "https://github.com/pstuart/better-markdown/releases/download/v1.0.0/bmd-v1.0.0.tar.gz"
  sha256 "3f6d305ddcc77ccf9a8f3ab54d08d300f6e625b4ba92bf5fce5283eae2bd3d1c"
  license "proprietary"
  version "1.0.0"

  depends_on macos: :sonoma

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

  test do
    assert_match version.to_s, shell_output("#{bin}/bmd --version")
    system "#{bin}/bmd", "--help"
  end
end
