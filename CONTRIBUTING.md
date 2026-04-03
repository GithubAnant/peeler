# Contributing to Peeler

Thanks for your interest in contributing! Here's how to get started.

## Getting Started

1. Fork the repo and clone your fork
2. Make sure you have Xcode 15+ and Swift 6.0 installed
3. Run `swift build` to verify everything compiles
4. Run `swift run` to launch the app in debug mode

## Making Changes

1. Create a branch off `main` for your work
2. Keep commits focused — one logical change per commit
3. Test your changes by building and running the app locally
4. Make sure `swift build` compiles without warnings

## Pull Requests

- Open a PR against `main`
- Describe what you changed and why
- Keep PRs small and focused — easier to review, faster to merge
- If your PR adds a new feature, mention how to test it

## Dependencies

- Sparkle is used for in-app updates
- Keep `SUPublicEDKey` and `SUFeedURL` in `Sources/Peeler/Resources/Info.plist` aligned with the release pipeline

## Code Style

- Follow existing patterns in the codebase
- Use SwiftUI for UI, AppKit only where necessary
- Keep files focused on a single responsibility
- Keep third-party dependencies minimal and justified

## Reporting Issues

- Use GitHub Issues to report bugs or suggest features
- Include your macOS version and steps to reproduce for bugs
- Screenshots are helpful for UI issues

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
