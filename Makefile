install:
	pip install -r requirements.txt

format:
	black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	
	echo '\n## Confusion Matrix Plot' >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
	
	cml comment create report.md

hf-login:
	git pull origin main
	git switch main
	pip install -U "huggingface_hub[cli]"
	@if [ -z "$(HF)" ]; then echo "Error: HF token is missing!"; exit 1; fi
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	@if [ -z "$(HF)" ]; then echo "Error: HF token is missing!"; exit 1; fi
	huggingface-cli upload Sreenidhi31/Drug-Classification ./App --repo-type=space --commit-message "Sync App files"
	huggingface-cli upload Sreenidhi31/Drug-Classification ./Model --repo-type=space --commit-message "Sync Model"
	huggingface-cli upload Sreenidhi31/Drug-Classification ./Results --repo-type=space --commit-message "Sync Metrics"

deploy: hf-login push-hub
