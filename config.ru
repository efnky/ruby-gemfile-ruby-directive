app = ->(env) {
  body = env["PATH_INFO"] == "/up" ? "ok\n" : "ruby-gemfile-ruby-directive up ruby=#{RUBY_VERSION}\n"
  [200, { "content-type" => "text/plain" }, [body]]
}
run app
