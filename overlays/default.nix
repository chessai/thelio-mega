{ maestro }:

[
  (final: prev: {
    maestro = maestro.packages.${prev.system}.default;
  })
]
