# JBHelloTweak

Proof-of-life tweak for the NuclearTweaks pipeline: verifies logos codegen,
substrate resolution, packaging, and the release path (CI → release PR → APT repo).

Install: add `https://nucleartweaks.github.io/` in Sileo/Cydia (rootless, iOS 15+ jailbreak).
On the jailbroken iOS 27 simulator use `tools/sim-test.sh JBHelloTweak` from the org
workspace instead — it builds rootful and drops the dylib straight into JB-13mini.

* `Package:` id `com.nucleartweaks.jbhellotweak` is immutable from the first release.
* CI is the org-shared `tweak-ci.yml` (device deb only); sim testing is local by design.
