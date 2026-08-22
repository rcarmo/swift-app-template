# Accessibility checklist

## Semantics

- Every control has a useful name that matches visible language.
- Dynamic labels retain a stable Voice Control input name.
- Group composite rows when separate children add noise; expose separate actions when users need them.
- Mark headings so VoiceOver rotor navigation follows the content hierarchy.
- Add accessibility values for progress, status, sliders, and custom controls.
- Hide decorative or repeated imagery. Describe informative images.
- Give charts a summary plus inspectable values or an equivalent table.

## Text and layout

- Use semantic text styles.
- Test the largest supported macOS text and accessibility settings.
- Let text wrap; keep essential controls reachable.
- Avoid `.caption2` for meaningful content and use `.caption` sparingly.
- Do not put variable text in fixed-height containers.
- Keep clickable targets easy to acquire. Verify every action with keyboard and accessibility focus.

## Colour and appearance

- Check contrast in light, dark, and increased-contrast appearances.
- Add text, shape, icon, or pattern when colour communicates selection, status, or error.
- Respect `.accessibilityDifferentiateWithoutColor`.
- Use semantic system colours and materials instead of opacity-based substitutes.
- Check Reduce Transparency where material affects legibility.

## Motion

Respect the `accessibilityReduceMotion` environment value. Replace large movement, parallax, zoom, or repeated motion with a restrained state or opacity change. Completion must remain understandable without animation.

## Input and focus

- Full Keyboard Access reaches every action in a logical order.
- Focus remains visible and predictable through lists, tables, toolbars, sheets, deletion, and filtering.
- Drag and drop has an Import, Export, Copy, Share, or menu alternative.
- Hover-only affordances have keyboard and accessibility alternatives.
- VoiceOver selection and keyboard selection remain synchronised.

## Manual run

Run the assembled app on macOS with VoiceOver, Voice Control, Full Keyboard Access, the largest supported text setting, Reduce Motion, Reduce Transparency, Differentiate Without Color, and Increase Contrast. Accessibility identifiers support automation; they do not replace user-facing labels.
