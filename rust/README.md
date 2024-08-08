cargo run --bin uniffi-bindgen generate --library ./target/release/libmw_ios_rust.dylib --language swift --out-dir ./bindings

xcodebuild -create-xcframework \
        -library ./target/aarch64-apple-ios-sim/release/libmw_ios_rust.a -headers ./bindings \
        -library ./target/aarch64-apple-ios/release/libmw_ios_rust.a -headers ./bindings \
        -output "ios/Mobile.xcframework"
