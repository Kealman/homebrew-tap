class Cland < Formula
  desc "Coordinate a crew of coding agents"
  homepage "https://cland.app"
  url "https://codeload.github.com/Kealman/cland-v0/tar.gz/refs/tags/v0.3.2"
  version "0.3.2"
  sha256 "7385f0ce1c899b57835085cadf69725474b32fa036c69eb19ccb55ea1f1ec99e"
  license "Apache-2.0"

  depends_on "node@24"

  def install
    node = Formula["node@24"].opt_bin
    ENV.prepend_path "PATH", node
    system node/"node", "-e", "const [major, minor] = process.versions.node.split('.').map(Number); if (major !== 24 || minor < 13) process.exit(1)"
    system "sh", "packaging/build-install.sh"
    libexec.install Dir["*", ".[^.]*"].reject { |path| [".git", ".github", ".cland"].include?(path) }
    (bin/"cland").write_env_script libexec/"hub/bin/cland.ts", PATH: "#{node}:$PATH"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cland --version")
    # A fresh machine may have no harness or Git identity; doctor reports those
    # prerequisites without requiring an agent account or starting a hub.
    output = shell_output("#{bin}/cland doctor 2>&1; code=$?; test \"$code\" -le 1")
    assert_match "node", output.downcase
  end
end