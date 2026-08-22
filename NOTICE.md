# Notices and provenance

This repository is an original implementation assembled after studying the projects below. The audit was performed on 2026-08-22. Upstream names and links are acknowledgements, not endorsements.

## twostraws/swiftui-agent-skill

- Repository: <https://github.com/twostraws/swiftui-agent-skill>
- Audited revision: `be297ff80dddec529af1f9b1f1f114aab6c9d11c`
- Licence in audited repository: MIT
- Copyright notice: Copyright (c) 2026 Paul Hudson
- Influence: policy-level guidance for current SwiftUI APIs, Observation data flow, typed navigation, accessibility, performance, concurrency, hygiene, and review structure.
- Reuse boundary: the local `.pi/skills/` suite adapts these principles into project-specific functional domains and independently worded reference files. It does not vendor verbatim upstream skill/reference files. The local skill index maps every audited upstream domain to its adaptation.

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
- Reuse boundary: `swift-style-tooling`, `swift-testing`, `.swiftformat`, and `.swiftlint.yml` are smaller project-specific adaptations. The upstream command plugin and full configurations are not vendored.

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

## rcarmo/EditorBridge

- Repository: <https://github.com/rcarmo/EditorBridge>
- Audited revision: `ab4715b958cf717143f8f958e1e673aef63453d6`
- Licence in audited repository: MIT
- Copyright notice: Copyright (c) 2026 Rui Carmo
- Influence: first-party implementation precedent for SwiftPM library and executable products, a native SwiftUI `@main` application, manual macOS `.app` assembly, and bundle-level code signing without an Xcode project.
- Reuse boundary: this template independently adapts the public build topology and conventional Apple bundle layout to its existing architecture, release policy, resources, and naming. It does not vendor EditorBridge source files.

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
- Reuse boundary: `apple-design-review` and `apple-typography` translate the general concerns into independently worded, system-first native SwiftUI guidance. The web/Electron CSS examples, fixed values, and fake-window implementation material were not copied.

## Local skill suite

The project-local skills are distributed under this repository's MIT licence. Their `metadata.provenance` fields identify adapted inputs, and `.pi/skills/README.md` maps source domains to local skills. The suite intentionally refactors source guidance by function rather than reproducing upstream repository names or file layouts.

The local suite includes original extensions for domains that were referenced or required but not supplied as complete audited skills: concurrency, testing, typography, performance profiling, runtime hardening, localisation, privacy/security, SwiftPM project workflows, and release operations.

## Other tools

This repository names SwiftFormat, SwiftLint, GitHub Actions, SwiftPM, and Apple command-line tools as development or build dependencies. Their distributions retain their respective licences; none of their source code is included here. SwiftFormat and SwiftLint are optional unless their explicit Make targets are used and may be installed by any method that puts them on `PATH`.
