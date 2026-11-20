# pipeline-trust-demo

A small, public experiment for the InfraCraft Labs guide
["Five questions that tell you if your pipeline deserves trust"](https://infracraftlabs.com/insights/five-pipeline-trust-questions/).

It checks on real GitHub runs that one deploy workflow can serve both a normal release and a rollback:

1. CI builds the image once, pushes it, and passes its digest to `deploy.yml` (`workflow_call`).
2. `deploy.yml` runs in the `production` environment (branch rule: `main`), which holds a dummy
   `DEPLOY_TOKEN`. The job prints only the token's length.
3. A rollback is `deploy.yml` started by hand (`workflow_dispatch`) with an older digest.

`scripts/deploy.sh` deploys nothing; it prints the image reference and refuses anything not pinned
to a digest. Actions are pinned to commit SHAs.

## Results (20 November 2026)

| Run | What happened | Result |
|---|---|---|
| [Release 1](https://github.com/infracraftlabs/pipeline-trust-demo/actions/runs/44829809711) | push to `main`; build pushed the image, deploy got its digest | deployed `sha256:5d2ec860…`, token length 32 |
| [Release 2](https://github.com/infracraftlabs/pipeline-trust-demo/actions/runs/44829973747) | push to `main` | deployed `sha256:2edcfd3d…`, token length 32 |
| [Release 3, first try](https://github.com/infracraftlabs/pipeline-trust-demo/actions/runs/44830153955) | `deploy.yml` asked for `packages: read`, the caller job did not grant it | startup failure: "is requesting 'packages: read', but is only allowed 'packages: none'" (actionlint did not catch it) |
| [Release 3](https://github.com/infracraftlabs/pipeline-trust-demo/actions/runs/44830226854) | caller job grants `packages: read` | deployed `sha256:50eef03f…` |
| [Rollback](https://github.com/infracraftlabs/pipeline-trust-demo/actions/runs/44830358342) | `deploy.yml` started by hand with release 1's digest | digest found, deployed `sha256:5d2ec860…`; run took 11 seconds |
| [Rollback to a missing digest](https://github.com/infracraftlabs/pipeline-trust-demo/actions/runs/44830416805) | started by hand with a digest that was never pushed | failed at the inspect step with `not found`; the deploy step never ran |

The image package is private, so the digests can't be pulled without access.
Not tested here: pull requests from forks, required reviewers on the environment, registry cleanup.
