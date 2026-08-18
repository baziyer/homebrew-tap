# typed: strict
# frozen_string_literal: true

# Homebrew bootstrap for the Dark Factory runtime.
class DarkFactory < Formula
  desc "Terminal-first runtime for persistent coding-agent teams"
  homepage "https://github.com/baziyer/dark-factory"
  url "https://github.com/baziyer/dark-factory/releases/download/v0.2.2/latest.json"
  sha256 "083d25f2b97977b96714c97bcab64d710845e676ce30b7f7e301abee16c76f13"
  license "MIT"

  depends_on :macos

  resource "binaries" do
    on_arm do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.2/dark-factory-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "50dc47abbbf1c9706de8a6257692d41c9fbd221b3a49a049a2bca717565b1479"
    end
    on_intel do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.2/dark-factory-v0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "ff3aec2cf43c8ba2c4ece33cdb5ccf0e87f5c0a2acbb76944526fdc1f0a36158"
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
      https://github.com/baziyer/dark-factory/blob/v0.2.2/launchd/README.md#uninstall to stop
      sessions and unload the service safely before removing anything else.
    EOS
  end

  test do
    %w[factoryd factory-runner factoryctl factory-tui].each do |name|
      assert_equal "#{name} #{version}", shell_output("#{bin}/#{name} --version").strip
    end
  end
end
