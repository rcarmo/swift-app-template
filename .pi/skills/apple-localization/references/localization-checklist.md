# Localisation checklist

## Strings

- Buttons, menus, commands, titles, labels, hints, errors, empty states, onboarding, accessibility text, notifications, and permission explanations are localisable.
- Translator context explains ambiguous nouns/verbs and placeholders.
- Interpolation remains one catalog entry so translators can reorder it.
- Plurals/variants use catalog rules and automatic grammar agreement where supported.

## Formatting

- Date/time uses locale-aware format styles and a deliberate time-zone choice.
- Currency carries the correct currency code; it is not inferred from the current locale when the data has its own currency.
- Measurements use `Measurement`/format styles and appropriate unit width.
- Person names use `PersonNameComponents` and its format style.
- Data interchange dates/numbers remain locale-independent at the protocol boundary.

## Layout

- Test pseudo-localisation or representative long strings.
- Verify right-to-left mirroring and use leading/trailing rather than left/right.
- Do not mirror directional media/icons whose meaning is absolute.
- Text can wrap and controls remain reachable at accessibility sizes.
- Tables/toolbars/sidebars still work with expansion.

## Search and sorting

User-entered local search normally uses `localizedStandardContains`. Sorting shown to users should use locale-aware comparison when domain ordering does not supersede it. Exact identifiers, file hashes, and protocol fields use domain-specific comparison.

## Testing

Use fixed locale/calendar/time zone in deterministic formatter tests. UI/manual testing should include an RTL language and a long-text locale. Avoid asserting full localized sentences in logic tests unless testing the catalog integration itself.
