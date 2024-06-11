SCHEME := MirrorDiffKit
SCRIPTS_PATH := Scripts
XCODEBUILD_SCRIPTS_PATH := ${SCRIPTS_PATH}/xcodebuild-scripts

.PHONY: all
all: clean test

Logs:
	mkdir Logs

build:
	mkdir build

build/reports: build
	mkdir build/reports

.PHONY: test
test: test-macOS test-iOS test-watchOS test-tvOS test-visionOS

.PHONY: test-macOS
test-macOS:
	# ====== Test on macOS ======
	swift test

.PHONY: test-iOS
test-iOS: Logs build/reports
	# ====== Test on iOS ======
	"${XCODEBUILD_SCRIPTS_PATH}/test" "${SCHEME}" "iOS-17-" "iPhone " "Logs/xcodebuild-test-iOS.log" "build/reports/junit-iOS.xml"

.PHONY: test-watchOS
test-watchOS: Logs build/reports
	# ====== Test on watchOS ======
	"${XCODEBUILD_SCRIPTS_PATH}/test" "${SCHEME}" "watchOS-10-" "Apple Watch " "Logs/xcodebuild-test-watchOS.log" "build/reports/junit-watchOS.xml"

.PHONY: test-tvOS
test-tvOS: Logs build/reports
	# ====== Test on tvOS ======
	"${XCODEBUILD_SCRIPTS_PATH}/test" "${SCHEME}" "tvOS-17-" "Apple TV " "Logs/xcodebuild-test-tvOS.log" "build/reports/junit-tvOS.xml"

.PHONY: test-visionOS
test-visionOS: Logs build/reports
	# ====== Test on visionOS ======
	"${XCODEBUILD_SCRIPTS_PATH}/test" "${SCHEME}" "xrOS-1-" "Apple Vision Pro" "Logs/xcodebuild-test-visionOS.log" "build/reports/junit-visionOS.xml"

.PHONY: clean
clean:
	git clean -fdx
