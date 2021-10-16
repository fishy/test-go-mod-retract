module github.com/fishy/test-go-mod-retract

go 1.17

// Have go.mod on non-root, never meant to happen.
retract v0.0.0-20211016165524-2d05d02ee912
