
`FA1.*`
- `FA1.2`/speicalized-without-allowance
  * Hooked
    + Finish hooked transfer function
    + Add sink contracts to test with
    + Add CLI
    + Test
  * `FA1.4`
    + Add receiver check (if account missing)
    + Add `register_account` (add sender with zero balance)
    + Throw error if no account and not receiver
    + Add CLI
    + Test

`lorentz-contract-view`
- Taquito
  * Convert lambda to json and test in taquito
  * Convert JSON to template and test
  * Make merge request to taquito
- Fix up view repo
- Add docs for view repo + Taquito to assets
  * Replace all views there with it

Serokell
- Review injectivity Serokell comments
- Review Indigo
- Ask Serokell about contract primitive entrypoint specification (still missing)
- Morley REPL should work

Morley
- Get multisig up to date with latest Morley
  * Needed for response to least authority audit
- Get all contract repos up to date with Morley
- Finish morley-sop
  * Extract names from annotations
    + Allow manual override of names
    + Provide spec for default names
  * Generate `optparse-applicative`, `aeson` parsers, (JSON specs?)
  * Generate generic CLI tool
    + Consider making compatible with taquito
  * Replace CLI's with morley-sop
  * Write up spec and make blog post
    + Integrate with rest of spec
      - Follow up on spec
    + Integrate with `lorentz-contract-originate`
  * Test against contract archive repo

Misc.
- Add contract setup JSON for `lorentz-contract-originate`
- Finish FA1.2 forwarder for ERX once injectivity is fixed
- Double-check response from Andrea token (I believe they're good to go, might want a bit more docs?)

Documentation
- Oracle docs task
- Add branch doc gen and build script to Morley projects
  * Update asset site docs
- Make regression tests for asset site guides

Contract archive repo
- Setup archive loop to extract:
  * Table of contracts (users)
    + Script to deduplicate contracts before putting in repo
    + Script to isolate code for individual entrypoints (up to constant error values or something) and deduplicate
  * Table of calls + results
- Simple server to keep up to date
  * CI task to run tests against the set
- Script to run (sub) set of contract type-checking/building and/or contract calls and verify against known results
- Add docs to assets site or similar
  * Real promise of contract archive, a la labnet, is to allow testing meta programming

