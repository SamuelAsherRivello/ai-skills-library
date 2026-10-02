# Design

## Context

See `proposal.md` for motivation and scope. The root README already displays the established white banner. The selected art and portrait preview is approved as the shared image base.

## Goals / Non-Goals

**Goals:**

- Keep the face identical to the supplied portrait while placing the portrait on the right.
- Produce evergreen, repository-owned PNG assets with one fresh visual direction across the set.
- Keep all captions exact and typeset as a separate composition step, not generated as pixels by an image model.

**Non-Goals:**

- Add AI product names, AI product logos, or other platform branding.
- Retouch, regenerate, or otherwise alter the face with AI.
- Change skill behavior or add a marketing system or external runtime dependency.

## Decisions

### Create one image and three captioned versions

Create `documentation/marketing/images/` with one text-free 1280×720 image and three 1280×720 versions of that same composition with text. Add the text-free image immediately under the existing white README banner. Do not edit the banner image or its current README reference.

The three variants use the exact captions `Reusable AI Skills`, `AI Workflows`, and `Skills That Scale`, one caption per image. Give each a distinct, manually typeset thumbnail treatment: a fresh two-line Montserrat layout for `Reusable AI Skills`; an enlarged, generously padded plaque for `AI Workflows`, with `AI` and `Workflows` vertically aligned; and a three-line `Skills` / `That` / `Scale` comic burst. Use a different type style for each treatment. Keep all text effects in the left area, outside the portrait frame. The text-free image has no lettering or logos.

Alternative considered: embed the captions directly in generated artwork. Separate text composition is more reliable and makes exact wording verifiable.

### Preserve the portrait through deterministic compositing

Use the supplied portrait as the sole source of the person. Flip the selected artwork horizontally so its visual weight sits left, and place the horizontally mirrored portrait on the far right. Do not use generative editing on the person or face. Keep the portrait pixels unchanged other than the requested horizontal flip and necessary crop/scale. The user approved this preview composition as the base for the set.

Alternative considered: ask an image model to recreate the entire image with the portrait as a reference. That risks changing facial features, so use a separate background and deterministic composition instead.

### Use original, brand-neutral background artwork

Build a fresh layout with complementary dark navy, blue, and amber background art. Use abstract visual cues for reusable skills and connected workflows. Include no logos or named AI products in the artwork or text. Treat the Blender repository only as structural inspiration; do not copy its composition or image files.

Alternative considered: use platform logos to signal compatibility. Omitting them keeps the images evergreen as the tools discussed in videos change.

## Risks / Trade-offs

- [The square portrait may require a crop to fit wide canvases] → Preserve the face and recognizable head/shoulders framing; extend the separately created background rather than stretching the portrait.
- [The new image could look detached from the established white banner] → Reuse its white, blue, and amber accent colors while keeping the thumbnail layout distinct.
- [The source portrait is outside the repository] → Use it only as an input during asset creation; save final composed assets in the repository and do not add the source file itself.

## Migration Plan

1. Save the approved text-free 1280×720 composition as the README image and create three matching captioned PNGs under `documentation/marketing/images/`.
2. Inspect each output for orientation, face preservation, caption accuracy, dimensions, and absence of AI product branding.
3. Add the text-free image directly below the existing banner in `README.md`, leaving the banner reference untouched.
4. Roll back by reverting the README references and removing the new marketing assets.
