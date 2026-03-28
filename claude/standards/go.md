# Go Standards

Base Go coding standards for Komodo. Project-level configs may extend these but should not contradict them.

---

## 1. Formatting & tooling

- All code formatted with `gofmt` or `goimports` — no exceptions
- `golangci-lint` must pass before merge; config lives in `.golangci.yaml` at repo root
- No disabling linter rules without a comment explaining why
- Run `go vet ./...` as part of CI

---

## 2. Error handling

- Always handle error return values — never `_` an error
- Wrap errors with context: `fmt.Errorf("fetchUser: %w", err)`
- Return errors up the call stack; don't log and return
- Log errors once — at the top of the call stack where you stop propagating
- No `panic` except for truly unrecoverable initialization failures (missing required config at startup)
- Sentinel errors (`var ErrNotFound = errors.New(...)`) for errors callers need to match; `errors.As`/`errors.Is` for inspection

---

## 3. Naming

- Exported names must have a doc comment
- Interfaces named by behavior: `Reader`, `Writer`, `Handler` — not `IReader`, `ReaderInterface`
- Avoid stutter: `user.Service` not `user.UserService`
- Unexported identifiers: camelCase, no underscores
- Acronyms: consistent casing — `userID`, `httpURL`, `parseJSON` (all caps or all lower, never mixed)
- Test helper functions: `newTestServer(t)`, `mustParseTime(t, s)` — take `t *testing.T` as first arg

---

## 4. Package design

- One package per directory
- Package name = what it provides, singular, lowercase: `order`, `payment`, `middleware`
- Avoid `util`, `common`, `helpers`, `misc` — if you can't name it, split it differently
- Internal packages (`internal/`) for code that must not be imported outside the module
- Minimize exported surface — unexport everything that doesn't need to be consumed externally

---

## 5. Testing

- Table-driven tests using `t.Run` for all non-trivial functions
- Test files in `_test` package (black-box testing) unless internal behavior must be tested
- Use `net/http/httptest` for HTTP handler tests — no real network calls in unit tests
- No mocking frameworks — define minimal interfaces and use test doubles
- Test coverage target: >80% on business logic packages; 100% on security-critical paths
- Test file names mirror the file being tested: `order_service_test.go` for `order_service.go`

---

## 6. Concurrency

- Never share mutable state without synchronization
- Prefer channels for coordination between goroutines; mutexes for protecting shared state
- Document goroutine lifetimes — who starts it, what stops it, what happens on error
- Always propagate and respect `context.Context` cancellation
- Use `sync.WaitGroup` or `errgroup` for goroutine lifecycle management
- `go func()` with no done signal is almost always wrong — capture and handle the goroutine

---

## 7. Performance

- Profile before optimizing — `pprof` is built in, use it
- Avoid premature allocation: prefer stack allocation, reuse slices with `[:0]`, use `strings.Builder`
- `sync.Pool` for frequently allocated short-lived objects on hot paths
- Benchmark critical paths with `testing.B`; store benchmarks alongside the code they measure
- Database queries: use `EXPLAIN ANALYZE` before adding an index; N+1 queries are a bug
