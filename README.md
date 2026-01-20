# Godot .NET Docker Images for CI/CD

> This repository is still a work in progress.

This repository is for maintaining the Dockerfile used for building and pushing Docker images for the .NET version of Godot, based on [SdgGames' Godot CICD Docker Images](https://gitlab.com/sdggames/godot-cicd). 

It also includes an image that includes Blender for projects that have `.blend` files.

# Images
- `godot-base`: includes Godot .NET, the corresponding .NET SDK, and their dependencies
- `godot-blender`: `godot-base` + Blender and its dependencies
- `godot-export`: `godot-blender` + Godot export templates

# Usage

> Setting a specific Blender version currently doesn't work; instead, the latest Blender version available in APT is used.

This project includes a Makefile to make building easier. Requires `make` to be installed on the system.

To build all images:
```
make build
```

To push all images to Docker Hub:
```
make push
```

To do all of the above:
```
make all
```

## Development
To build an individual image:
```bash
docker build --target $NAME -t $NAMESPACE/$NAME:$VERSION .

# example:
docker build --target godot-blender -t cmapua/godot-blender:4.5.1 .
```

To run an image locally:
```bash
docker run --rm -it --entrypoint bash $NAMESPACE/$NAME:$VERSION

# example:
docker run --rm -it --entrypoint bash cmapua/godot-blender:4.5.1
```