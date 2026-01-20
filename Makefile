NAMESPACE := cmapua
GODOT_VERSION := 4.5.1
DOTNET_VERSION := 8.0
BLENDER_VERSION := 4.5.5
IMAGE_BASE := godot-base
IMAGE_BLENDER := godot-blender-apt
IMAGE_EXPORT := godot-export

all: build push

build:
	docker build \
		--target $(IMAGE_BASE) \
		--build-arg VERSION=$(GODOT_VERSION) \
		--build-arg DOTNET_VERSION=$(DOTNET_VERSION) \
		--build-arg BLENDER_VERSION=$(BLENDER_VERSION) \
		-t $(NAMESPACE)/$(IMAGE_BASE):$(GODOT_VERSION) \
		.
	docker build \
		--target $(IMAGE_BLENDER) \
		--build-arg VERSION=$(GODOT_VERSION) \
		--build-arg DOTNET_VERSION=$(DOTNET_VERSION) \
		--build-arg BLENDER_VERSION=$(BLENDER_VERSION) \
		-t $(NAMESPACE)/godot-blender:$(GODOT_VERSION) \
		.
	docker build \
		--target $(IMAGE_EXPORT) \
		--build-arg VERSION=$(GODOT_VERSION) \
		--build-arg DOTNET_VERSION=$(DOTNET_VERSION) \
		--build-arg BLENDER_VERSION=$(BLENDER_VERSION) \
		-t $(NAMESPACE)/$(IMAGE_EXPORT):$(GODOT_VERSION) \
		.

push:
	docker push $(NAMESPACE)/$(IMAGE_BASE):$(GODOT_VERSION)
	docker push $(NAMESPACE)/godot-blender:$(GODOT_VERSION)
	docker push $(NAMESPACE)/$(IMAGE_EXPORT):$(GODOT_VERSION)