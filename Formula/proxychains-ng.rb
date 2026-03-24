class ProxychainsNg < Formula
  desc "SOCKS5/HTTP hook preloader with arm64e support"
  homepage "https://github.com/rofl0r/proxychains-ng"
  license "GPL-2.0-or-later"
  head "https://github.com/rofl0r/proxychains-ng.git", branch: "master"

  depends_on :macos

  # Conflicts with the official homebrew-core formula
  conflicts_with "homebrew/core/proxychains-ng",
    because: "this tap builds universal arm64+arm64e for -arm64e_preview_abi systems"

  def install
    # Build universal arm64 + arm64e. Required on systems with
    # nvram boot-args containing -arm64e_preview_abi, which makes
    # dyld reject plain arm64 DYLD_INSERT_LIBRARIES injections.
    ENV.append "CFLAGS", "-arch arm64 -arch arm64e"
    ENV.append "LDFLAGS", "-arch arm64 -arch arm64e"

    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config" unless (etc/"proxychains.conf").exist?
  end

  def caveats
    <<~EOS
      This is an arm64e-compatible build of proxychains-ng.
      It works on systems with -arm64e_preview_abi in nvram boot-args.

      Config file: #{etc}/proxychains.conf
      User override: ~/.proxychains/proxychains.conf

      Usage:
        proxychains4 curl http://ifconfig.me
        proxychains4 topgrade
        proxychains4 brew install <formula>

      To upgrade when upstream updates:
        brew upgrade --fetch-HEAD ylluminate/utilities/proxychains-ng
    EOS
  end

  test do
    assert_match "proxychains-ng", shell_output("#{bin}/proxychains4 test 2>&1", 1)

    # Verify arm64e slice exists in the dylib
    assert_match "arm64e", shell_output("file #{lib}/libproxychains4.dylib")
  end
end
