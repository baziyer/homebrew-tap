# typed: strict
# frozen_string_literal: true

# Homebrew bootstrap for the Dark Factory runtime.
class DarkFactory < Formula
  desc "Terminal-first runtime for persistent coding-agent teams"
  homepage "https://github.com/baziyer/dark-factory"
  url "https://github.com/baziyer/dark-factory/releases/download/v0.2.4/latest.json"
  sha256 "ecbda37a651e7c2fabb92a9b764ac3832381d42bacb4c4f45dbca4e24f704e6f"
  license "MIT"

  depends_on :macos

  resource "binaries" do
    on_arm do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.4/dark-factory-v0.2.4-aarch64-apple-darwin.tar.gz"
      sha256 "ca4545971384b161f7b96252b97379751240cf34f1cbc182c0e032ce33d928f6"
    end
    on_intel do
      url "https://github.com/baziyer/dark-factory/releases/download/v0.2.4/dark-factory-v0.2.4-x86_64-apple-darwin.tar.gz"
      sha256 "eca7bf4bf134901c800e39d6cfdacd15866f8d72c9b86107acbb70bc565266d8"
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
      https://github.com/baziyer/dark-factory/blob/v0.2.4/launchd/README.md#uninstall to stop
      sessions and unload the service safely before removing anything else.
    EOS
  end

  test do
    %w[factoryd factory-runner factoryctl factory-tui].each do |name|
      assert_equal "#{name} #{version}", shell_output("#{bin}/#{name} --version").strip
    end
  end
end
