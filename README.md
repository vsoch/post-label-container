# Post Label Container

How can we apply labels to a container after it's built? I recently ran into
this issue, and came up with a simple solution that I wanted to share with
others. The example here will build a simple container with spack, and then
generate (and apply) some labels after the fact. This works doing the following:

1. Define a [Dockerfile](Dockerfile) with something that warrants post-labeling. I chose spack compilers.
2. Use the [GitHub Workflow](.github/workflows/build-deploy.yaml) to build a matrix of containers and apply the label post build for multiple arches, or a [simpler workflow](.github/workflows/simple-build-deploy.yaml) that does the same.

The workflow uses buildx, but separates arches into separate builds, each with a different container
architecture (and tagged appropriately).

## Why can't we do all platforms at once with buildx?

What still does not work well is if you need to extend to different architectures.
The buildx action, if using load=True, does not support multiple manifests (e.g., if you
provide more than one platform). This means that in order to use the same image layers
again with labels, we would have only built for one architecture, and would
only have that base available. For this reason, I separated the architectures out,
and then had one workflow per architecture, making sure to include the architecture
as the tag so that there wouldn't be a race to push different containers to the same tag.

## Why do we do a push 

I tried using load and the cache to preserve the container between steps, but
every time it wanted to pull from (a non-existing) container URI, and given that
the container did exist, it would be incorrectly pulling an older image each time.
So instead I opted for running the labeling and final deploy just on push to main,
and for a pull request I do a vanilla build that does not push.
