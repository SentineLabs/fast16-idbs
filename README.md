# fast16 — Gold-Master IDA Databases

Annotated IDA Pro databases and investigation artifacts for **fast16**, a 2005 Windows sabotage toolkit targeting high-precision solvers used to model nuclear-weapons behavior.

These databases accompany the SentinelLABS post *Sol Searching | Can Frontier Models Tackle Autonomous Long-Horizon Malware Analysis?* <!-- TODO: post URL --> and the original fast16 research: [fast16: Mystery ShadowBrokers Reference Reveals High-Precision Software Sabotage 5 Years Before Stuxnet](https://www.sentinelone.com/labs/fast16-mystery-shadowbrokers-reference-reveals-high-precision-software-sabotage-5-years-before-stuxnet/) ([s1.ai/fast16](https://s1.ai/fast16)).

## Contents

| File | Component | Description |
|---|---|---|
| `idbs/svcmgmt.i64` | `svcmgmt.exe` (host) | Gold-master database for the host service implant, with findings from the embedded components folded back in. |
| `idbs/connect.i64` | Connect | Embedded component recovered from the host sample. <!-- TODO: authors confirm description --> |
| `idbs/fast16.i64` | fast16 kernel driver | The driver superficially resembling a filesystem rootkit; contains the 101-rule patching engine. |
| `idbs/fast16_payloads.i64` | Lua operations framework | The encrypted Lua-driven operations framework and payloads. <!-- TODO: authors confirm description --> |

## Provenance

These artifacts were produced during a multi-stage reverse-engineering benchmark of frontier reasoning models. The best candidate databases, produced by a GPT-5.6 Sol (high) run, were then put through an extensive adversarial refinement process using an ensemble of models.

We make no claim that these databases are perfect — only that they represent the greatest level of automated refinement the most capable models achieved through proper methodology, repeated standard enforcement, and a lot of tokens burned. We share them so other researchers can verify the work against the sample and build on it rather than start from the raw binary.

## Requirements

Databases were produced with **IDA Pro 9.3**. Earlier versions may not open them.

## ⚠️ Warning

IDA databases embed the full binary content of the analyzed samples. **Treat these files as you would live malware**: handle them in an isolated analysis environment.

## Verification

```
sha256sum -c SHA256SUMS
```

| SHA-256 | File |
|---|---|
| `4b2f31e521bca594c967ad8242db820b4932d5a98eb13c5898225c69eee3081b` | `idbs/svcmgmt.i64` |
| `d3bc690a24c643c71166badd81239ca80f409fbed72453d1e2eed71ccb33c22a` | `idbs/connect.i64` |
| `beacb54a980679b152ab02148808b7ce5ecf199d5232fc3907d1766eb3cd629a` | `idbs/fast16.i64` |
| `5b8ffc4a4db90fc9ba4e81c286a1118c02f5d6d5d8219c7707c6bbc9d0daf1dd` | `idbs/fast16_payloads.i64` |

## Versioning

Current release: **v1.0** — see [CHANGELOG.md](CHANGELOG.md). These databases may be updated as the community verifies and extends the analysis.

## License

<!-- TODO: pending decision (CC BY 4.0 proposed) -->

## Authors

SentinelLABS — Juan Andrés Guerrero-Saade & Gabriel Bernadett-Shapiro
