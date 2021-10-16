# test-go-mod-retract

This is a test repo to demonstrate the current (go1.17.2) issue when trying to
use `retract` in `go.mod` to retract a version in a non-root `go.mod` file.

## Git version history

The first git commit, created by github, has the following files:

```
README.md
LICENCE
```

The second git commit (2d05d02), which is recognized by go toolchain as
`v0.0.0-20211016165524-2d05d02ee912`, has the following files:

```
README.md
LICENSE
lib/
  go.mod
  lib.go
```

This commit demonstrates a common mistake scenario: the project put the `go.mod`
file under a non-root directory without realizing the consequences [0] of it.

[0]: https://github.com/golang/go/issues/34055#issuecomment-763880343

Then, the third git commit (189fa58), which is also later tagged as `v0.1.0`,
tries to correct the mistake from the previous commit,
by removing `lib/go.mod` and add it to the root directory instead:

```
README.md
LICENSE
go.mod
lib/
  lib.go
```

This makes https://pkg.go.dev/github.com/fishy/test-go-mod-retract@v0.1.0/lib
work, but at the same time, it shows that `v0.1.0` is not the "latest" version
of this module, and the latest version is `v0.0.0-20211016165524-2d05d02ee912`.
When you try `go mod get github.com/fishy/test-go-mod-retract/lib@latest`,
it will grab `v0.0.0-20211016165524-2d05d02ee912`,
`go mod get github.com/fishy/test-go-mod-retract@latest` will correctly grab
`v0.1.0`.

So the fourth commit (fb96cca) tries to retract
`v0.0.0-20211016165524-2d05d02ee912`, by adding the following line [1] into
**root** `go.mod` file:

```
retract v0.0.0-20211016165524-2d05d02ee912
```

[1]: https://github.com/fishy/test-go-mod-retract/blob/fb96cca/go.mod#L6

This does NOT work as intended,
because currently `retract` can only be used to retract versions from the same
`go.mod`, not other `go.mod` from the same repository.

The only way to retract that version is to retract it from `lib/go.mod`,
but that totally defeats the purpose of retraction because `lib/go.mod` itself
is the mistake we are trying to fix.
