# TypeScript Standards

Base TypeScript/JavaScript coding standards for Komodo. Project-level configs may extend these.

---

## 1. Type safety

- `"strict": true` in all `tsconfig.json` files — no exceptions
- No `any` without a code comment explaining why it's necessary and what would be needed to remove it
- Use `unknown` over `any` for data from external sources (API responses, parsed JSON, user input)
- Runtime validation with Zod (or equivalent) at all system boundaries — TypeScript types alone are not runtime guarantees
- `as` type assertions only when you have verified the type through code logic — not as a way to silence the compiler

---

## 2. Naming

| Thing | Convention | Example |
|-------|-----------|---------|
| Types, interfaces, classes, components | PascalCase | `OrderSummary`, `UserCard` |
| Variables, functions, methods | camelCase | `fetchOrder`, `isLoading` |
| True constants | SCREAMING_SNAKE | `MAX_RETRY_COUNT` |
| Files (modules) | kebab-case | `order-service.ts` |
| Files (components) | PascalCase | `UserCard.svelte` |
| Enum values | PascalCase | `OrderStatus.Pending` |

- Prefix boolean variables/props with `is`, `has`, `can`, `should`: `isLoading`, `hasError`
- Don't prefix interfaces with `I` — `User` not `IUser`

---

## 3. Null handling

- Use optional chaining (`?.`) for potentially undefined access
- Use nullish coalescing (`??`) for defaults — not `||` (which swallows `0` and `""`)
- Avoid non-null assertions (`!`) — if you use one, add a comment explaining why it's safe
- Prefer explicit null/undefined checks over truthiness when the distinction matters

---

## 4. Async patterns

- Always `async/await` over raw promise chains
- Every rejected promise must be caught — unhandled rejections are bugs
- `Promise.all` for parallel independent operations; `Promise.allSettled` when partial failure is acceptable
- Never `await` in a loop when requests can be parallelized
- Async functions that can fail should throw typed errors, not return `null` to signal failure

---

## 5. Module organization

- Single responsibility per file — one primary export per module
- Re-export from barrel `index.ts` files sparingly: they hurt tree-shaking and create circular import risks
- Prefer direct imports over barrel imports for large modules
- No circular imports — if A imports B and B imports A, extract the shared dependency to C
- Co-locate tests with the file under test: `order-service.test.ts` next to `order-service.ts`

---

## 6. Testing

- Unit tests with Vitest; test behavior, not implementation details
- Mock at module boundaries only — don't mock internal functions of the module under test
- E2E tests with Playwright for critical user flows (auth, checkout, key forms)
- Avoid snapshot tests for logic — snapshot tests for UI components are acceptable if reviewed carefully
- Test names describe behavior: `"returns 404 when order does not exist"` not `"test fetchOrder"`

---

## 7. Frontend / component standards

- Components should be pure where possible — derive state rather than sync it
- No business logic in UI components — use a service or store layer
- Props should be the minimal set needed — don't pass the entire store object when you need one field
- Side effects in `$effect` (Svelte) or `useEffect` (React) must have correct dependencies and cleanup
- Accessibility: interactive elements must be keyboard-navigable; use semantic HTML before ARIA attributes
- No inline styles — use utility classes; no `!important`
