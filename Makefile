hf-login:
	git pull origin main
	git switch main
	pip install -U "huggingface_hub[cli]"
	@if [ -z "$(HF)" ]; then echo "Error: HF token is missing!"; exit 1; fi
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	@if [ -z "$(HF)" ]; then echo "Error: HF token is missing!"; exit 1; fi
	huggingface-cli upload Sreenidhi31/Enhanced-OSCC ./App --repo-type=space --commit-message "Sync App files"
	huggingface-cli upload Sreenidhi31/Enhanced-OSCC ./Model --repo-type=space --commit-message "Sync Model files"
	@# Optional uploads
	@if [ -f requirements.txt ]; then huggingface-cli upload Sreenidhi31/Enhanced-OSCC requirements.txt --repo-type=space --commit-message "Sync requirements"; fi
	@if [ -f README.md ]; then huggingface-cli upload Sreenidhi31/Enhanced-OSCC README.md --repo-type=space --commit-message "Sync README"; fi

deploy: hf-login push-hub
