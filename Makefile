export

# ---- Define targets ----
# Stata targets
LIBS = $(wildcard ./src/lib/*.do)

# Main targets
all: ./out/tex/article.pdf
.PHONY: all fresh clear-cache tests


# ---- Build rules ----

# Step 1: Data
./out/src/data.log: ./src/data.do $(LIBS)
	@echo "🗄️ $(GREEN_START)Data processing$(GREEN_END)"
	@$(call build_do,$<)

# Step 2: Analysis
./out/src/main.log: ./src/main.do ./out/src/data.log $(LIBS)
	@echo "📊 $(GREEN_START)Running analysis$(GREEN_END)"
	@$(call build_do,$<)

# Step 3: Paper
./out/tex/article.pdf: ./tex/article/main.tex ./out/src/main.log
	@$(call build_tex,$<)

# ---- Utility targets ----

clean: ## Clean up intermediate latex files
	@echo "🧹 $(GREEN_START)Cleaning up...$(GREEN_END)"
	@find ./tex -type f ! -name '*.tex' -delete
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"

fresh: ## Delete all targets
	@echo "😵 $(GREEN_START)Deleting all targets and intermediary files...$(GREEN_END)"
	@find ./out -type f -name "*.pdf" -delete
	@find ./out -type f -name "*.log" -delete
	@find ./assets/tables -type f ! -name ".gitignore" -delete
	@find ./assets/figures -type f ! -name ".gitignore" -delete
	@find ./data/processed -type f ! -name ".gitignore" -delete
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"

tests: ## Run tests
	@echo "🧪 $(GREEN_START)Running tests...$(GREEN_END)"
	@for test in ./tests/*.do; do \
		echo "Running $$test..."; \
		stata-mp -b "$$test"; \
		if tail -2 "$$(basename $$test .do).log" | grep -q "r([0-9]\+);"; then \
			echo "$(RED_START)❌ Test failed: $$test$(RED_END)"; \
			tail -10 "$$(basename $$test .do).log"; \
			exit 1; \
		else \
			echo "$(GREEN_START)✓ $$test passed$(GREEN_END)"; \
			rm "$$(basename $$test .do).log"; \
		fi; \
	done
	@echo "✅ $(GREEN_START)All tests passed!$(GREEN_END)"

help: ## Display this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

# ---- functions ----

# build_do
# -----------
# Runs a Stata do file and moves the log output to ./out directory
# Checks for errors in the log file and fails the build if errors are found
# Arguments:
#   $1 - Path to the .do file (e.g., ./src/data/data.do)
define build_do
	$(eval BASENAME := $(notdir $(basename $(1))))
	$(eval TARGET := $(patsubst %.do,out/%.log,$(1)))
	@echo " $(GREEN_START)📄 Running $(1) -> $(TARGET)...$(GREEN_END)"
	@mkdir -p $(dir $(TARGET))
	@stata-mp -b $(1)
	@if tail -2 $(BASENAME).log | grep -q "r([0-9]\+);"; then \
		echo "$(RED_START)❌ Error in $(1)$(RED_END)"; \
		echo "$(RED_START)Last 10 lines of log:$(RED_END)"; \
		tail -10 $(BASENAME).log; \
		echo "$(RED_START)See $(BASENAME).log for more details$(RED_END)"; \
		exit 1; \
	else \
		mv $(BASENAME).log $(TARGET); \
		echo "✅ $(GREEN_START)Done!$(GREEN_END)"; \
	fi
endef

# build_tex
# -----------
# Compiles a LaTeX file in ./tex/DIR/main.tex and copies the resulting PDF to ./out/tex/DIR.pdf
# Arguments:
#   $1 - Path to the LaTeX main.tex file (e.g., ./tex/article/main.tex)
define build_tex
	$(eval TARGET := $(patsubst tex/%/main.tex,out/tex/%.pdf,$(1)))
	@echo "📝 $(GREEN_START)Compiling $(1) -> $(TARGET)...$(GREEN_END)"
	@mkdir -p ./out/tex/
	@cd $(dir $(1)) &&\
		latexmk -pdf -quiet\
		-interaction=nonstopmode $(notdir $(1))
	@cp $(basename $(1)).pdf $(TARGET)
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"
endef

# --- I/O colors ---
GREEN_START = \033[1;32m
GREEN_END = \033[
RED_START = \033[1;31m
RED_END = \033[0m
