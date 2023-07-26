if [ "${CONFIGURATION}" = "Debug" ]; then
        ${PODS_ROOT}/SwiftLint/swiftlint autocorrect

        ${PODS_ROOT}/SwiftLint/swiftlint --config $SRCROOT/swiftlint.yml --strict
fi
