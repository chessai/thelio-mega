{ maestro }:

[
  # maestro's own overlay (adds `pkgs.maestro`), built from the same crane
  # scaffolding as its package output. Replaces the hand-rolled
  # `final: prev: { maestro = maestro.packages.<system>.default; }` now that
  # maestro exposes `overlays.default` itself (MAE-047).
  maestro.overlays.default
]
