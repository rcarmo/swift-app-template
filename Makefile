SHELL := /bin/bash
.DEFAULT_GOAL := build

APP_NAME ?= Starter
PROJECT := $(APP_NAME).xcodeproj
CONFIGURATION ?= Debug
IOS_DESTINATION ?= generic/platform=iOS Simulator
CATALYST_DESTINATION ?= platform=macOS,variant=Mac Catalyst
MAC_DESTINATION ?= platform=macOS
TVOS_DESTINATION ?= generic/platform=tvOS Simulator
VISIONOS_DESTINATION ?= generic/platform=visionOS Simulator
WATCHOS_DESTINATION ?= generic/platform=watchOS Simulator
VERSION ?= $(shell head -n 1 VERSION 2>/dev/null)
NOTARY_PROFILE ?= starter-notary

ifeq ($(SKIP_DOCTOR),1)
DEPS_PREREQUISITES :=
else
DEPS_PREREQUISITES := doctor
endif

.PHONY: help doctor tools bootstrap bootstrap-all deps check prepare validate skills workflow-test \
        generate resolve format lint test test-package build build-all build-ios build-catalyst \
        build-macos build-tvos build-visionos build-watchos app-macos run-macos open-project \
        icon notary-setup dist clean rename

help:
	@echo "One-shot workflows (macOS):"
	@echo "  make bootstrap        Install Brewfile tools, validate, test, and build macOS"
	@echo "  make bootstrap-all    Bootstrap and build every configured Apple target"
	@echo "  make / make build     Validate, lint, test, generate, and build macOS"
	@echo "  make build-all        Validate, test, and build all Apple targets"
	@echo "  make check            Validate, lint, and run AppCore tests"
	@echo ""
	@echo "Setup and quality:"
	@echo "  make doctor           Check full Xcode and required Apple SDKs"
	@echo "  make tools            Install/update Homebrew tools from Brewfile"
	@echo "  make validate         Portable repository/static/skill checks"
	@echo "  make skills           Validate local skill metadata and coverage"
	@echo "  make workflow-test    Test bootstrap/build orchestration with mocked tools"
	@echo "  make generate         Generate $(PROJECT) with XcodeGen"
	@echo "  make resolve          Resolve local/package dependencies"
	@echo "  make format           Apply SwiftFormat and safe SwiftLint fixes"
	@echo "  make lint             Verify SwiftFormat and SwiftLint"
	@echo "  make test             Run portable AppCore tests with SwiftPM"
	@echo ""
	@echo "Individual Xcode builds (macOS):"
	@echo "  make build-ios        Build the generic iOS Simulator target"
	@echo "  make build-catalyst   Build the Mac Catalyst target"
	@echo "  make build-macos      Build the native macOS target"
	@echo "  make build-tvos       Build the generic tvOS Simulator target"
	@echo "  make build-visionos   Build the generic visionOS Simulator target"
	@echo "  make build-watchos    Build the generic watchOS Simulator target"
	@echo ""
	@echo "Local macOS app and release:"
	@echo "  make app-macos        Build and ad-hoc sign build/$(APP_NAME).app"
	@echo "  make run-macos        Build and open the local macOS app"
	@echo "  make open-project     Generate and open $(PROJECT)"
	@echo "  make icon PNG=...     Create iOS/macOS Xcode and .icns assets"
	@echo "  make notary-setup     Store notarization credentials in Keychain"
	@echo "  make dist             Sign, notarize, staple, and checksum a macOS zip"
	@echo ""
	@echo "Template maintenance:"
	@echo "  make rename NAME=MyApp [BUNDLE_ID=com.example.myapp]"
	@echo "  make clean"

doctor:
	@[[ "$$(uname -s)" == "Darwin" ]] || { \
	  echo "error: native Apple builds require macOS"; \
	  echo "       portable checks are available with: make validate"; \
	  exit 1; \
	}
	@command -v xcode-select >/dev/null || { echo "error: xcode-select is unavailable"; exit 1; }
	@command -v xcodebuild >/dev/null || { echo "error: install full Xcode"; exit 1; }
	@command -v xcrun >/dev/null || { echo "error: install Xcode command-line tools"; exit 1; }
	@developer_dir="$$(xcode-select -p 2>/dev/null)"; \
	case "$$developer_dir" in \
	  */Xcode*.app/Contents/Developer) ;; \
	  *) \
	    echo "error: full Xcode is not selected (active developer dir: $$developer_dir)"; \
	    echo "       run: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"; \
	    exit 1 ;; \
	esac
	@xcodebuild -version >/dev/null 2>&1 || { \
	  echo "error: Xcode first-launch setup is incomplete"; \
	  echo "       run: sudo xcodebuild -runFirstLaunch"; \
	  exit 1; \
	}
	@sdks="$$(xcodebuild -showsdks 2>/dev/null)"; \
	for sdk in macosx iphonesimulator appletvsimulator watchsimulator xrsimulator; do \
	  echo "$$sdks" | grep -q -- "-sdk $$sdk" || { \
	    echo "error: required SDK '$$sdk' is unavailable in the selected Xcode"; \
	    exit 1; \
	  }; \
	done
	@xcrun --find swift >/dev/null || { echo "error: Swift toolchain not found through xcrun"; exit 1; }
	@echo "Xcode prerequisite check passed ($$(xcodebuild -version | tr '\n' ' '))."

tools: doctor
	@command -v brew >/dev/null || { \
	  echo "error: Homebrew is required to install XcodeGen, SwiftFormat, and SwiftLint"; \
	  echo "       install it from https://brew.sh, then run make bootstrap again"; \
	  exit 1; \
	}
	brew bundle --file=Brewfile

deps: $(DEPS_PREREQUISITES)
	@command -v swift >/dev/null || { echo "error: Swift is unavailable through the selected Xcode"; exit 1; }
	@command -v xcodegen >/dev/null || { echo "error: xcodegen missing; run make bootstrap"; exit 1; }
	@command -v swiftformat >/dev/null || { echo "error: swiftformat missing; run make bootstrap"; exit 1; }
	@command -v swiftlint >/dev/null || { echo "error: swiftlint missing; run make bootstrap"; exit 1; }

bootstrap: tools
	@$(MAKE) --no-print-directory SKIP_DOCTOR=1 build
	@echo "Bootstrap complete: $(PROJECT) and a verified macOS build are ready."

bootstrap-all: tools
	@$(MAKE) --no-print-directory SKIP_DOCTOR=1 build-all
	@echo "Bootstrap complete: every configured Apple target built successfully."

check: validate lint test-package

prepare: check resolve

validate:
	./scripts/static-checks.sh

skills:
	./scripts/check-skills.sh

workflow-test:
	./scripts/test-make-workflows.sh

generate: deps
	xcodegen generate

resolve: generate
	xcodebuild -resolvePackageDependencies -project "$(PROJECT)" -scheme "$(APP_NAME)-macOS"

format: deps
	swiftformat --config .swiftformat Sources Tests Package.swift
	swiftlint --fix --config .swiftlint.yml

lint: deps
	swiftformat --lint --config .swiftformat Sources Tests Package.swift
	swiftlint lint --strict --config .swiftlint.yml

test-package: deps
	swift test

test: test-package

build: build-macos
	@echo "Build complete: $(APP_NAME)-macOS ($(CONFIGURATION))."

build-all: build-ios build-catalyst build-macos build-tvos build-visionos build-watchos
	@echo "Build complete: all configured Apple targets ($(CONFIGURATION))."

build-ios build-catalyst build-macos build-tvos build-visionos build-watchos: prepare

build-ios:
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-iOS" \
	  -configuration "$(CONFIGURATION)" -destination '$(IOS_DESTINATION)' CODE_SIGNING_ALLOWED=NO

build-catalyst:
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-iOS" \
	  -configuration "$(CONFIGURATION)" -destination '$(CATALYST_DESTINATION)' CODE_SIGNING_ALLOWED=NO

build-macos:
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-macOS" \
	  -configuration "$(CONFIGURATION)" -destination '$(MAC_DESTINATION)' CODE_SIGNING_ALLOWED=NO

build-tvos:
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-tvOS" \
	  -configuration "$(CONFIGURATION)" -destination '$(TVOS_DESTINATION)' CODE_SIGNING_ALLOWED=NO

build-visionos:
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-visionOS" \
	  -configuration "$(CONFIGURATION)" -destination '$(VISIONOS_DESTINATION)' CODE_SIGNING_ALLOWED=NO

build-watchos:
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-watchOS" \
	  -configuration "$(CONFIGURATION)" -destination '$(WATCHOS_DESTINATION)' CODE_SIGNING_ALLOWED=NO

app-macos: prepare
	xcodebuild build -project "$(PROJECT)" -scheme "$(APP_NAME)-macOS" -configuration Debug \
	  -destination '$(MAC_DESTINATION)' -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO
	@rm -rf "build/$(APP_NAME).app"
	@cp -R "build/DerivedData/Build/Products/Debug/$(APP_NAME).app" "build/$(APP_NAME).app"
	@codesign --force --sign - --entitlements "Config/$(APP_NAME).entitlements" "build/$(APP_NAME).app"
	@codesign --verify --strict --verbose=2 "build/$(APP_NAME).app"
	@echo "Local app ready: build/$(APP_NAME).app"

run-macos: app-macos
	open "build/$(APP_NAME).app"

open-project: generate
	open "$(PROJECT)"

icon: doctor
	@test -n "$(PNG)" || { echo "usage: make icon PNG=path/to/icon-1024.png"; exit 64; }
	./scripts/make-icons.sh "$(PNG)"

notary-setup: doctor
	NOTARY_PROFILE="$(NOTARY_PROFILE)" ./scripts/notary-setup.sh

dist: prepare
	APP_NAME="$(APP_NAME)" VERSION="$(VERSION)" NOTARY_PROFILE="$(NOTARY_PROFILE)" \
	  ./scripts/release-macos.sh

rename:
	@test -n "$(NAME)" || { echo "usage: make rename NAME=MyApp [BUNDLE_ID=com.example.myapp]"; exit 64; }
	./scripts/rename.sh "$(NAME)" "$(BUNDLE_ID)"

clean:
	rm -rf .build build dist DerivedData "$(PROJECT)"
