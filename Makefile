images := debian-cui debian-gui ubuntu-cui ubuntu-gui

.PHONY: all format validate $(images)

all: $(images)

$(images):
	cd $@ && packer build .

# Format all templates
format:
	@for image in $(images); do \
		cd $$image; packer fmt .; cd ..; \
	done

# Validate all templates
validate:
	@for image in $(images); do \
		cd $$image; packer validate .; cd ..; \
	done
