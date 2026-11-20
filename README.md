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

## Results

Filled in after the runs.
