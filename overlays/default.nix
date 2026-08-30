{ maestro }:

[
  (final: prev: {
    maestro = maestro.packages.${prev.stdenv.hostPlatform.system}.default;
  })
]
