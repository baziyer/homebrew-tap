# typed: strict
# frozen_string_literal: true

# Homebrew bootstrap for the Dark Factory runtime.
class DarkFactory < Formula
  desc "Terminal-first runtime for persistent coding-agent teams"
  homepage "https://github.com/baziyer/dark-factory"
  version "0.2.0"
  license "MIT"

  depends_on :macos

  resource "binaries" do
    on_arm do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.0/dark-factory-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "913174b2de1d79a011cfeafb76375adfdc3c214732430c97663f1a5fda0bc265"
    end
    on_intel do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.0/dark-factory-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "1d003ad7c491ad8cd1e147144c8955aecbaebb7477362b2820af1904760d1aa1"
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
      https://github.com/baziyer/dark-factory/blob/v0.2.0/launchd/README.md#uninstall to stop
      sessions and unload the service safely before removing anything else.
    EOS
  end

  test do
    %w[factoryd factory-runner factoryctl factory-tui].each do |name|
      assert_match version.to_s, shell_output("#{bin}/#{name} --version")
    end
  end
end
