SHELL := /bin/bash
.DEFAULT_GOAL := build

APP_NAME ?= Starter
PRODUCT_NAME ?= Starter
BUNDLE_ID ?= com.example.starter
CONFIGURATION ?= debug
VERSION ?= $(shell head -n 1 VERSION 2>/dev/null)
NOTARY_PROFILE ?= starter-notary
APP := build/$(APP_NAME).app

.PHONY: help doctor quality-tools check validate skills workflow-test format lint test package-build \
        build release run install uninstall icon notary-setup dist clean rename

help:
	@echo "SwiftPM workflows (macOS):"
	@echo "  make / make build     Build and ad-hoc sign build/$(APP_NAME).app"
	@echo "  make package-build    Compile the app with SwiftPM only"
	@echo "  make test             Run AppCore tests with SwiftPM"
	@echo "  make check            Validate, lint, test, and compile"
	@echo "  make run              Build and launch the app"
	@echo "  make install          Install the app in /Applications"
	@echo "  make uninstall        Remove it from /Applications"
	@echo ""
	@echo "Quality and maintenance:"
	@echo "  make doctor           Check macOS and Apple command-line tools"
	@echo "  make validate         Repository/static/skill checks"
	@echo "  make workflow-test    Test Make orchestration with mocked tools"
	@echo "  make format           Apply SwiftFormat and safe SwiftLint fixes"
	@echo "  make lint             Verify SwiftFormat and SwiftLint"
	@echo "  make icon PNG=...     Create a macOS .icns file"
	@echo "  make rename NAME=MyApp [BUNDLE_ID=com.example.myapp]"
	@echo ""
	@echo "Distribution:"
	@echo "  make notary-setup     Store notarization credentials in Keychain"
	@echo "  make dist             Sign, notarize, staple, and checksum a zip"
	@echo "  make clean"

doctor:
	@[[ "$$(uname -s)" == "Darwin" ]] || { echo "error: the app requires macOS"; exit 1; }
	@command -v swift >/dev/null || { echo "error: install a Swift 6 toolchain"; exit 1; }
	@command -v codesign >/dev/null || { echo "error: codesign is unavailable"; exit 1; }
	@command -v xcrun >/dev/null || { echo "error: xcrun is unavailable"; exit 1; }
	@swift --version

quality-tools:
	@command -v swiftformat >/dev/null || { \
	  echo "error: SwiftFormat is required for this optional quality target"; exit 1; }
	@command -v swiftlint >/dev/null || { \
	  echo "error: SwiftLint is required for this optional quality target"; exit 1; }

check: validate lint test package-build

validate:
	./scripts/static-checks.sh

skills:
	./scripts/check-skills.sh

workflow-test:
	./scripts/test-make-workflows.sh

format: quality-tools
	swiftformat --config .swiftformat Sources Tests Package.swift
	swiftlint --fix --config .swiftlint.yml

lint: quality-tools
	swiftformat --lint --config .swiftformat Sources Tests Package.swift
	swiftlint lint --strict --config .swiftlint.yml

test:
	swift test

package-build:
	swift build --product "$(PRODUCT_NAME)" --configuration "$(CONFIGURATION)"

build: doctor
	APP_NAME="$(APP_NAME)" PRODUCT_NAME="$(PRODUCT_NAME)" BUNDLE_ID="$(BUNDLE_ID)" \
	  CONFIGURATION="$(CONFIGURATION)" VERSION="$(VERSION)" ./scripts/build-macos-app.sh

release: CONFIGURATION := release
release: build

run: build
	open "$(APP)"

install: build
	rm -rf "/Applications/$(APP_NAME).app"
	cp -R "$(APP)" /Applications/
	@echo "Installed /Applications/$(APP_NAME).app"

uninstall:
	rm -rf "/Applications/$(APP_NAME).app"

icon: doctor
	@test -n "$(PNG)" || { echo "usage: make icon PNG=path/to/icon-1024.png"; exit 64; }
	./scripts/make-icons.sh "$(PNG)"

notary-setup: doctor
	NOTARY_PROFILE="$(NOTARY_PROFILE)" ./scripts/notary-setup.sh

dist: doctor
	APP_NAME="$(APP_NAME)" PRODUCT_NAME="$(PRODUCT_NAME)" BUNDLE_ID="$(BUNDLE_ID)" \
	  VERSION="$(VERSION)" NOTARY_PROFILE="$(NOTARY_PROFILE)" ./scripts/release-macos.sh

rename:
	@test -n "$(NAME)" || { echo "usage: make rename NAME=MyApp [BUNDLE_ID=com.example.myapp]"; exit 64; }
	./scripts/rename.sh "$(NAME)" "$(if $(filter command line,$(origin BUNDLE_ID)),$(BUNDLE_ID),)"

clean:
	rm -rf .build build dist
