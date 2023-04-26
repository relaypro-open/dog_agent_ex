BUILD_STREAM ?= ci
BUILD_ID ?= 0

.PHONY: build
build: clean docker-build archive

.PHONY: test
test:
	@(mix test)

.PHONY: clean
clean:
	@(rm -rf dist)
	@(rm -f dog_agent_ex)
	@(mix deps.clean --all)

.PHONY: docker-build
docker-build:
	@(docker build --rm -t dog_agent_ex_build -f Dockerfile.jenkins .)

# Create the artifact
.PHONY: archive
archive: dist
	@(docker run dog_agent_ex_build tar \
	   --create \
	   --verbose \
	   --gzip \
	   --exclude="dist" \
	   --exclude="deps" \
	   --exclude=".git" \
	   --exclude=".tool-versions" \
	   --exclude=".elixir_ls" \
	   --exclude=".formatter.exs" \
	   -C dog_agent_ex \
	   --build-arg dog_env=${DOG_ENV} \
	   . > dist/$(BUILD_STREAM)-$(BUILD_ID).tar.gz)

dist:
	mkdir dist
