class Plocate < Formula
  desc "Fast file search for macOS using posting lists and trigram indexing"
  homepage "https://github.com/ylluminate/plocate-macos"
  license "GPL-2.0-or-later"
  head "https://github.com/ylluminate/plocate-macos.git", branch: "main"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "zstd"
  depends_on :macos

  def install
    args = %W[
      -Dinstall_systemd=false
      -Dinstall_cron=false
      -Ddbpath=plocate/plocate.db
      -Dconfpath=#{etc}/updatedb.conf
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    etc.install "updatedb.conf.darwin" => "updatedb.conf" unless (etc/"updatedb.conf").exist?

    (var/"lib/plocate").mkpath
  end

  def caveats
    <<~EOS
      Build the initial database (requires sudo):
        sudo #{sbin}/updatedb

      To configure exclusions, edit:
        #{etc}/updatedb.conf

      External volumes are excluded by default. To index a specific volume:
        sudo #{sbin}/updatedb -U /Volumes/MyDrive -o #{var}/lib/plocate/myvolume.db
        #{bin}/plocate -d #{var}/lib/plocate/myvolume.db <pattern>
    EOS
  end

  service do
    run [opt_sbin/"updatedb", "--output", var/"lib/plocate/plocate.db"]
    run_type :interval
    interval 86400
    require_root true
    process_type :background
    log_path var/"log/plocate-updatedb.log"
    error_log_path var/"log/plocate-updatedb.log"
  end

  test do
    (testpath/"test_dir/sub").mkpath
    (testpath/"test_dir/hello.txt").write "test"
    (testpath/"test_dir/sub/deep.log").write "test"

    system sbin/"updatedb", "-U", testpath/"test_dir",
           "-o", testpath/"test.db", "--require-visibility", "no"
    assert_predicate testpath/"test.db", :exist?
    assert_match "hello.txt", shell_output("#{bin}/plocate -d #{testpath}/test.db hello")
  end
end
