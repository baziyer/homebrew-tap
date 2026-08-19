# typed: strict
# frozen_string_literal: true

# Homebrew bootstrap for the Dark Factory runtime.
class DarkFactory < Formula
  desc "Terminal-first runtime for persistent coding-agent teams"
  homepage "https://github.com/baziyer/dark-factory"
  url "https://github.com/baziyer/dark-factory/releases/download/v0.2.3/latest.json"
  sha256 "b5defd08873c92fc873832641f20a178f8bbff0f6769101cd794064fdd01f20c"
  license "MIT"

  depends_on :macos

  resource "binaries" do
    on_arm do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.3/dark-factory-v0.2.3-aarch64-apple-darwin.tar.gz"
      sha256 "b9b52d388f61a0930cd03c9ebaf4f63baf3b8ff8eff5f3fa095ef1300b67a7a8"
    end
    on_intel do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.3/dark-factory-v0.2.3-x86_64-apple-darwin.tar.gz"
      sha256 "b8d4d93eb801b447f8ec2632db4a140dd0b0d5e39ba8d4c91b6e580f329d9d7c"
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
      https://github.com/baziyer/dark-factory/blob/v0.2.3/launchd/README.md#uninstall to stop
      sessions and unload the service safely before removing anything else.
    EOS
  end

  test do
    %w[factoryd factory-runner factoryctl factory-tui].each do |name|
      assert_equal "#{name} #{version}", shell_output("#{bin}/#{name} --version").strip
    end
  end
end
