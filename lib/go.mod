module github.com/fishy/test-go-mod-retract/lib

go 1.17

// Have go.mod on non-root, never meant to happen.
retract [v0.0.0-00000000000000-000000000000, v0.0.1-retract]
