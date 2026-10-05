# Spec Delta

## Purpose

Defines how an existing external Tiled tileset is assessed, authored, and
verified for safe Wang-based room and Figure 8 generation.

## ADDED Requirements

### Requirement: Autotiling is authored separately from art conversion
The library SHALL provide a `tiled-ai-add-tileset-autotiling` workflow for an
existing external TSX. Art conversion SHALL remain a separate workflow and
SHALL NOT imply that the converted art supports Wang autotiling.

#### Scenario: Converted art needs terrain metadata
- **WHEN** a user requests autotiling for an existing external TSX
- **THEN** the workflow inspects that exact TSX before adding or updating any
  Wang metadata

### Requirement: Fitness is evidence-based and scoped
The autotiling workflow SHALL classify an exact tileset as Wang-ready, limited
Wang-ready, or not Wang-ready from an inspected assignment and rendered
fixture. A limited result SHALL name the supported topology and missing masks.

#### Scenario: A fixture lacks a required mask
- **WHEN** a requested footprint requires an unassigned Wang pattern
- **THEN** the workflow reports the limitation and does not declare the
  tileset Wang-ready for that footprint

### Requirement: Room-frame art paints the walkable region
For a room-frame tileset whose source reference maps corners, sides, and an
interior tile to a single edge colour, the workflow SHALL paint the complete
walkable footprint rather than manually painting a one-cell wall stroke.

#### Scenario: Dungeon Figure 8 proof
- **WHEN** the exact tileset supplies the nine rectangular-room masks
- **THEN** a fixture with two-cell-wide routes and a 4×4 inner core renders
  directional boundary walls and a repeated interior floor without missing or
  wrong-facing Wang cells

### Requirement: Saved output is verified
The workflow SHALL save the exact external TSX and disposable fixture map only
after checking their generated cell data, layer structure, and bounded render.

#### Scenario: Successful fixture handoff
- **WHEN** the fixture passes its rendered and cell-data checks
- **THEN** the workflow returns clickable links to the saved TSX and map plus
  the terrain-set name, colour, supported topology, and fitness outcome
