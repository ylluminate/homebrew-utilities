class Meat < Formula
  desc "Abridge a code diff into a reading diff"
  homepage "https://github.com/boldsoftware/meat"
  license "Apache-2.0"
  # Upstream publishes no tags and no releases -- main is the only ref there is,
  # so this formula tracks it. `brew upgrade --fetch-HEAD` pulls new commits.
  head "https://github.com/boldsoftware/meat.git", branch: "main"

  depends_on "go" => :build

  def install
    # meat has no go.sum and no external dependencies, so the build is fully
    # hermetic -- nothing is fetched from the module proxy inside the sandbox.
    # Pin the toolchain too, so a bumped `go` directive in go.mod cannot make
    # the build reach out for a different Go.
    ENV["GOTOOLCHAIN"] = "local"

    # std_go_args already supplies -trimpath and strips symbols, while still
    # honouring HOMEBREW_BUILD_FROM_SOURCE debug builds. Don't re-pass ldflags.
    system "go", "build", *std_go_args, "./cmd/meat"
  end

  def caveats
    <<~EOS
      meat sends the diff to a hosted model, so it needs credentials:
        export OPENAI_API_KEY=...     # or
        export ANTHROPIC_API_KEY=...

      Optional environment:
        MEAT_MODEL   Default model id (overridden by -model)
        MEAT_CACHE   Cache directory (default ~/.meat; empty disables caching)

      Usage:
        meat                   Abridge the latest commit
        meat HEAD~3            A specific revision
        meat main...HEAD       A commit range
        meat -staged           The staged changes
        git diff | meat        A diff on stdin

      Upstream ships no tagged releases, so this formula tracks main. To pull
      the latest upstream commits:
        brew upgrade --fetch-HEAD ylluminate/utilities/meat
    EOS
  end

  test do
    # meat prints its usage on stderr (flag.FlagSet output), not stdout.
    assert_match "abridge a diff", shell_output("#{bin}/meat -h 2>&1")

    (testpath/"sample.diff").write <<~DIFF
      diff --git a/hello.txt b/hello.txt
      --- a/hello.txt
      +++ b/hello.txt
      @@ -0,0 +1 @@
      +hello
    DIFF

    # With no credentials meat must still read the diff and fail only when it
    # reaches the provider, which exercises the CLI, stdin reader and parser.
    output = with_env(OPENAI_API_KEY: nil, ANTHROPIC_API_KEY: nil,
                      OPENAI_BASE_URL: nil, ANTHROPIC_BASE_URL: nil) do
      shell_output("#{bin}/meat < #{testpath}/sample.diff 2>&1", 1)
    end
    assert_match "credentials", output
  end
end
