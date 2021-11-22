import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :math_kid, MathKidWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "hM4Qyi5KEY3ij+zQn2RsAyeP0l7u8hPYpZuLQfODZj/Hen8vpFROEj1q50ZTSZuz",
  server: false

# In test we don't send emails.
config :math_kid, MathKid.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
