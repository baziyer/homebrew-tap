# typed: strict
# frozen_string_literal: true

# Homebrew bootstrap for the Dark Factory runtime.
class DarkFactory < Formula
  desc "Terminal-first runtime for persistent coding-agent teams"
  homepage "https://github.com/baziyer/dark-factory"
  url "https://github.com/baziyer/dark-factory/releases/download/v0.2.5/latest.json"
  sha256 "524bd7504256b5d6d44f53fe3d1f6a94c4388ae1c7da9bc512ffbbb57c09f620"
  license "MIT"

  depends_on :macos

  resource "binaries" do
    on_arm do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.5/dark-factory-v0.2.5-aarch64-apple-darwin.tar.gz"
      sha256 "22c83ba26fc1776e00c43edacd0859d70556e6b658a5e0e1ca2d02b8dc82b559"
    end
    on_intel do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.5/dark-factory-v0.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "42f6f61936738dd24d273b97b4281520c8668ed24eefa3baea5e2957ce41d586"
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
      https://github.com/baziyer/dark-factory/blob/v0.2.5/launchd/README.md#uninstall to stop
      sessions and unload the service safely before removing anything else.
    EOS
  end

  test do
    %w[factoryd factory-runner factoryctl factory-tui].each do |name|
      assert_equal "#{name} #{version}", shell_output("#{bin}/#{name} --version").strip
    end
  end
end
