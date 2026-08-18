# typed: strict
# frozen_string_literal: true

# Homebrew bootstrap for the Dark Factory runtime.
class DarkFactory < Formula
  desc "Terminal-first runtime for persistent coding-agent teams"
  homepage "https://github.com/baziyer/dark-factory"
  url "https://github.com/baziyer/dark-factory/releases/download/v0.2.1/latest.json"
  sha256 "f82c7088064b9d09d27de15c5640dbe0146541677235744ef68845dce101c472"
  license "MIT"

  depends_on :macos

  resource "binaries" do
    on_arm do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.1/dark-factory-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "578979331997387b264524aafb17aac092938dd14e0da81dbca2222fcb7ee496"
    end
    on_intel do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.1/dark-factory-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "cdea2ab806bc461e4d1c1f3a2eb0f910fa52c200a840a909ee3a2e6b57316860"
    end
  end

  def install
    resource("binaries").stage do
      bin.install "factoryd", "factory-runner", "factoryctl", "factory-tui"
    end
  end

  def caveats
    <<~EOS
      Homebrew installs the bootstrap commands; it does not own the running factory.
      Run `factoryctl init` to install the active runtime and optional launchd job
      under ~/.dark-factory. Do not use `brew services` for Dark Factory.

      `brew upgrade` updates this bootstrap copy. Use
      `factoryctl update --install` to atomically update the active runtime while
      preserving live sessions and rollback binaries.

      `brew uninstall dark-factory` removes only the bootstrap commands. The
      launchd job, active runtime, and state under ~/.dark-factory remain. Follow
      https://github.com/baziyer/dark-factory/blob/v0.2.1/launchd/README.md#uninstall to stop
      sessions and unload the service safely before removing anything else.
    EOS
  end

  test do
    %w[factoryd factory-runner factoryctl factory-tui].each do |name|
      assert_equal "#{name} #{version}", shell_output("#{bin}/#{name} --version").strip
    end
  end
end
