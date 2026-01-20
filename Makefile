NAMESPACE := cmapua
GODOT_VERSION := 4.5.1
DOTNET_VERSION := 8.0
BLENDER_VERSION := 4.5.5

all: build push

build:
	docker build \
		--target godot-base \
		--build-arg VERSION=$(GODOT_VERSION) \
		--build-arg DOTNET_VERSION=$(DOTNET_VERSION) \
		--build-arg BLENDER_VERSION=$(BLENDER_VERSION) \
		-t $(NAMESPACE)/godot-base:$(GODOT_VERSION) \
		.
	docker build \
		--target godot-blender \
		--build-arg VERSION=$(GODOT_VERSION) \
		--build-arg DOTNET_VERSION=$(DOTNET_VERSION) \
		--build-arg BLENDER_VERSION=$(BLENDER_VERSION) \
		-t $(NAMESPACE)/godot-blender:$(GODOT_VERSION) \
		.
	docker build \
		--target godot-export \
		--build-arg VERSION=$(GODOT_VERSION) \
		--build-arg DOTNET_VERSION=$(DOTNET_VERSION) \
		--build-arg BLENDER_VERSION=$(BLENDER_VERSION) \
		-t $(NAMESPACE)/godot-export:$(GODOT_VERSION) \
		.

push:
	docker push $(NAMESPACE)/godot-base:$(GODOT_VERSION)
	docker push $(NAMESPACE)/godot-blender:$(GODOT_VERSION)
	docker push $(NAMESPACE)/godot-export:$(GODOT_VERSION)