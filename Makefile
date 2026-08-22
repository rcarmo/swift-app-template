SHELL := /bin/bash
.DEFAULT_GOAL := help

APP_NAME ?= Starter
PROJECT := $(APP_NAME).xcodeproj
CONFIGURATION ?= Debug
PLATFORM ?= iOS Simulator
IOS_DEVICE ?= platform=iOS Simulator,name=iPhone 16 Pro
MAC_DESTINATION ?= platform=macOS
VERSION ?= $(shell head -n 1 VERSION 2>/dev/null)
NOTARY_PROFILE ?= starter-notary

.PHONY: help bootstrap deps validate skills generate resolve format lint test test-package \
        build-ios build-macos build-tvos build-visionos build-watchos app-macos run-macos icon \
        notary-setup dist clean rename

help:
	@echo "Setup and quality:"
	@echo "  make bootstrap        Install Homebrew tools and generate the Xcode project"
	@echo "  make validate         Linux-safe repository/static checks"
	@echo "  make skills           Validate local skill metadata and coverage"
	@echo "  make generate         Generate $(PROJECT) with XcodeGen"
	@echo "  make format           Apply SwiftFormat"
	@echo "  make lint             Verify SwiftFormat and SwiftLint"
	@echo "  make test-package     Run portable AppCore tests with SwiftPM"
	@echo ""
	@echo "Xcode builds (macOS only):"
	@echo "  make test             Run the SwiftPM unit tests"
	@echo "  make build-ios        Build the iOS simulator target"
	@echo "  make build-macos      Build the generated macOS target"
	@echo "  make build-tvos       Build the tvOS simulator target"
	@echo "  make build-visionos   Build the visionOS simulator target"
	@echo "  make build-watchos    Build the watchOS simulator target"
	@echo ""
	@echo "Local macOS bundle and release:"
	@echo "  make app-macos        Build and ad-hoc sign build/$(APP_NAME).app with Xcode"
	@echo "  make run-macos        Build and open the local macOS app bundle"
	@echo "  make icon PNG=...     Create iOS/macOS Xcode and .icns assets"
	@echo "  make notary-setup     Store notary credentials in the login keychain"
	@echo "  make dist             Sign, notarize, staple and checksum a macOS zip"
	@echo ""
	@echo "Template maintenance:"
	@echo "  make rename NAME=MyApp [BUNDLE_ID=com.example.myapp]"
	@echo "  make clean"

deps:
	@command -v swift >/dev/null || { echo "error: install Xcode/Swift"; exit 1; }
	@command -v xcodebuild >/dev/null || { echo "error: install Xcode"; exit 1; }
	@command -v xcodegen >/dev/null || { echo "error: brew install xcodegen"; exit 1; }
	@command -v swiftformat >/dev/null || { echo "error: brew install swiftformat"; exit 1; }
	@command -v swiftlint >/dev/null || { echo "error: brew install swiftlint"; exit 1; }

bootstrap:
	@command -v brew >/dev/null || { echo "error: Homebrew is required"; exit 1; }
	brew bundle
	$(MAKE) generate

validate:
	./scripts/static-checks.sh

skills:
	./scripts/check-skills.sh

generate:
	@command -v xcodegen >/dev/null || { echo "error: brew install xcodegen"; exit 1; }
	xcodegen generate

resolve: generate
	xcodebuild -resolvePackageDependencies -project "$(PROJECT)" -scheme "$(APP_NAME)-iOS"

format:
	swiftformat --config .swiftformat Sources Tests Package.swift
	swiftlint --fix --config .swiftlint.yml

lint:
	swiftformat --lint --config .swiftformat Sources Tests Package.swift
	swiftlint lint --strict --config .swiftlint.yml

test-package:
	swift test

test: test-package

build-ios: generate
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-iOS" -configuration "$(CONFIGURATION)" -destination '$(IOS_DEVICE)' CODE_SIGNING_ALLOWED=NO

build-macos: generate
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-macOS" -configuration "$(CONFIGURATION)" -destination '$(MAC_DESTINATION)' CODE_SIGNING_ALLOWED=NO

build-tvos: generate
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-tvOS" -configuration "$(CONFIGURATION)" -destination 'generic/platform=tvOS Simulator' CODE_SIGNING_ALLOWED=NO

build-visionos: generate
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-visionOS" -configuration "$(CONFIGURATION)" -destination 'generic/platform=visionOS Simulator' CODE_SIGNING_ALLOWED=NO

build-watchos: generate
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-watchOS" -configuration "$(CONFIGURATION)" -destination 'generic/platform=watchOS Simulator' CODE_SIGNING_ALLOWED=NO

app-macos: generate
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-macOS" -configuration Debug -destination '$(MAC_DESTINATION)' -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO
	@rm -rf "build/$(APP_NAME).app"
	@cp -R "build/DerivedData/Build/Products/Debug/$(APP_NAME).app" "build/$(APP_NAME).app"
	@codesign --force --sign - --entitlements "Config/$(APP_NAME).entitlements" "build/$(APP_NAME).app"
	@codesign --verify --strict --verbose=2 "build/$(APP_NAME).app"

run-macos: app-macos
	open "build/$(APP_NAME).app"

icon:
	@test -n "$(PNG)" || { echo "usage: make icon PNG=path/to/icon-1024.png"; exit 64; }
	./scripts/make-icons.sh "$(PNG)"

notary-setup:
	NOTARY_PROFILE="$(NOTARY_PROFILE)" ./scripts/notary-setup.sh

dist: generate
	APP_NAME="$(APP_NAME)" VERSION="$(VERSION)" NOTARY_PROFILE="$(NOTARY_PROFILE)" ./scripts/release-macos.sh

rename:
	@test -n "$(NAME)" || { echo "usage: make rename NAME=MyApp [BUNDLE_ID=com.example.myapp]"; exit 64; }
	./scripts/rename.sh "$(NAME)" "$(BUNDLE_ID)"

clean:
	rm -rf .build build dist DerivedData "$(PROJECT)"
