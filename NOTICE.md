# Notices and provenance

This repository is an original implementation assembled after studying the projects below. The audit was performed on 2026-08-22. Upstream names and links are acknowledgements, not endorsements.

## twostraws/swiftui-agent-skill

- Repository: <https://github.com/twostraws/swiftui-agent-skill>
- Audited revision: `be297ff80dddec529af1f9b1f1f114aab6c9d11c`
- Licence in audited repository: MIT
- Copyright notice: Copyright (c) 2026 Paul Hudson
- Influence: policy-level guidance for current SwiftUI APIs, Observation data flow, typed navigation, accessibility, performance, concurrency, hygiene, and review structure.
- Reuse boundary: this template restates and adapts principles in its own project-specific documentation and code. It does not vendor the upstream skill or reference files.

MIT notice for the audited source:

> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.

## airbnb/swift

- Repository: <https://github.com/airbnb/swift>
- Audited revision: `44685a412d510eabe4de918949d585391153c790`
- Licence in audited repository: MIT
- Copyright notice: Copyright (c) 2012 Airbnb
- Influence: readability-oriented Swift style, two-space indentation, line-length policy, naming, safe formatting/lint division, and rules discouraging direct standard-output logs, unchecked sendability, and legacy file literals.
- Reuse boundary: local `.swiftformat` and `.swiftlint.yml` are smaller, independently selected configurations suited to this template; the upstream formatter plugin and full configurations are not vendored.

MIT notice for the audited source:

> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.

## tqbf/swiftui-app

- Repository: <https://github.com/tqbf/swiftui-app>
- Audited revision: `3ca1cc4b8ffdbd3b628cc847574c9951b036fe12`
- Licence status at audit: no explicit licence file or grant was found.
- Influence: high-level ideas around a small SwiftUI app, Make workflows, rename/icon helpers, strict concurrency, signing, notarisation, and operational documentation.
- Reuse boundary: no upstream source text or code was copied. Scripts, sample domain, UI, architecture, and documentation here were independently designed and written.

## ceorkm/macos-design-skill

- Repository: <https://github.com/ceorkm/macos-design-skill>
- Audited revision: `8f528a2364f996cd42f02a10b1b27198a74ca2a3`
- Licence status at audit: the README says “MIT”; no standalone licence file or complete copyright/licence notice was found.
- Influence: reference-level prompts to treat keyboard access, search, drag-and-drop, light/dark appearance, progressive disclosure, native window composition, and interaction feedback as first-class macOS concerns.
- Reuse boundary: the web/Electron CSS examples and fixed-value design system were not copied. This template translates general concerns into original, system-first SwiftUI guidance.

## Other tools

This repository names XcodeGen, SwiftFormat, SwiftLint, Homebrew, GitHub Actions, and Apple command-line tools as development dependencies. Their own distributions and repositories retain their respective licences; none of their source code is included here.
