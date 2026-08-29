# Security Policy

## Scope

`resizable_panel_group` is a Flutter UI package. It does not provide network,
storage, authentication, or secret-management features.

Primary risks are likely to be layout, gesture, focus, keyboard, or semantics
bugs rather than traditional backend vulnerabilities.

## Reporting a vulnerability

Do not open a public GitHub issue for a suspected security problem.

Instead:

1. Contact the maintainer privately with a clear description, impact, and
   reproduction details if available.
2. Or use GitHub Security Advisories:
   [Private advisory draft](../../security/advisories/new)

## Response timeline

- Acknowledgment target: within 2-3 business days.
- Fix timing depends on severity and reproducibility.
- Public disclosure should happen after a fix ships.

## What not to report here

- General Flutter security questions
- Issues in third-party dependencies that do not involve this package directly
- Ordinary rendering or usability bugs better suited for the normal issue
  tracker

## Security best practices for users

- Keep Flutter and package dependencies up to date.
- Review UI behavior that could affect accessibility or unexpected interaction.
- Report suspicious keyboard, semantics, or focus behavior if it could mislead
  users or assistive technologies.
