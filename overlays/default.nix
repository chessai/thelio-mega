{ polymc, maestro }:

[
  polymc.overlay

  (final: prev: {
    maestro = maestro.packages.${prev.system}.default;
  })
]
