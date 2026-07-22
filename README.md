# fast16 — IDA Databases and Analysis Artifacts

Reviewed IDA Pro databases and derived analysis for **fast16**, a 2005 Windows malware framework with an embedded Lua 5.0 runtime, network propagation, and a boot-start filesystem driver that applies rule-driven executable patching.

These files accompany the SentinelLABS reports
[Sol Searching | Can Frontier Models Tackle Autonomous Long-Horizon Malware Analysis?](https://www.sentinelone.com/labs/frontier-models-tackle-autonomous-long-horizon-malware-analysis/)
and
[fast16 | Mystery Shadow Brokers Reference Reveals High-Precision Software Sabotage 5 Years Before Stuxnet](https://www.sentinelone.com/labs/fast16-mystery-shadowbrokers-reference-reveals-high-precision-software-sabotage-5-years-before-stuxnet/).

## IDA databases

| File | Component | Contents |
|---|---|---|
| `idbs/svcmgmt.i64` | `svcmgmt.exe` | Carrier and service host with the embedded Lua VM, native bindings, and component storage. |
| `idbs/connect.i64` | `svcmgmt.dll` | MPR connection-notification DLL. On post-operation notifications, it attempts one write of the adjacent UTF-16 strings `remote\0local\0` to `\\.\pipe\p577`. |
| `idbs/fast16.i64` | `fast16.sys` | Boot-start filesystem filter containing the 101-rule matcher, read-path modification machinery, and payload-relocation path. |
| `idbs/fast16_payloads.i64` | Injected payloads | Joint database for the two raw x86/x87 payload templates used by the driver. This is not the Lua policy. |

## Analysis artifacts

| File | Contents |
|---|---|
| `analysis/lua/lua_decompiled_source.lua` | Reviewed Lua 5.0 source-equivalent reconstruction of the encrypted bytecode. It is not the original source text. |
| `analysis/lua/lua_to_native_direct_calls.json` | Map of 92 direct Lua call sites to 44 host-native bindings; no direct sites remain unresolved. |
| `analysis/lua/lua_configuration_manifest.json` | Derived summary of the service, driver, propagation, and connection-notification configuration recovered from the bytecode. |
| `analysis/rule101/RULE101_SEMANTIC_CATALOG.json` | Structural catalog of all 101 rules. It is a review candidate, not final behavioral authority: payload ABI, runtime mechanism, and reachable consequence remain pending, and it is not bound to the current driver and payload IDB hashes. |

## Provenance

The release set began with the R004 database set produced by
**GPT-5.6-Sol High/Standard**. The host, connection-notification, and driver databases were corrected and reviewed in later passes. The injected-payload database and the derived analysis artifacts were produced separately. These are not untouched outputs from a single model run.

We make no claim that these databases are perfect — only that they represent the greatest level of automated refinement the most capable models achieved through proper methodology, repeated standard enforcement, and a lot of tokens burned. We share them so other researchers can verify the work against the sample and build on it rather than start from the raw binary.

## Requirements

Databases were produced with **IDA Pro 9.3**. Earlier versions may not open them.

## ⚠️ Warning

IDA databases embed the full binary content of the analyzed samples. **Treat these files as you would live malware**: handle them in an isolated analysis environment.

## Verification

```
sha256sum -c SHA256SUMS
```

## Versioning

Current release: **v1.0** — see [CHANGELOG.md](CHANGELOG.md). These files may be updated as the community verifies and extends the analysis.

## License

The analysis annotations and artifacts are released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) — see [LICENSE](LICENSE). The embedded sample binaries are not our work and are included solely for research verification.

## Authors

SentinelLABS — Juan Andrés Guerrero-Saade and Gabriel Bernadett-Shapiro
